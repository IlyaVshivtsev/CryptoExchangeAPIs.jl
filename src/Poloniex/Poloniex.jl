module Poloniex

export PoloniexCommonQuery,
    PoloniexPublicQuery,
    PoloniexAccessQuery,
    PoloniexPrivateQuery,
    PoloniexAPIError,
    PoloniexClient,
    PoloniexData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle, EasyCurl

using ..CryptoExchangeAPIs

import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError,
    AbstractAPIsData,
    AbstractAPIsQuery,
    AbstractAPIsClient,
    AbstractAPIsConfig

abstract type PoloniexData <: AbstractAPIsData end
abstract type PoloniexCommonQuery  <: AbstractAPIsQuery end
abstract type PoloniexPublicQuery  <: PoloniexCommonQuery end
abstract type PoloniexAccessQuery  <: PoloniexCommonQuery end
abstract type PoloniexPrivateQuery <: PoloniexCommonQuery end

"""
    PoloniexConfig <: AbstractAPIsConfig

Poloniex client config.

## Required fields
- `base_url::String`: Base URL for the client.

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `interface::String`: Interface for the client.
- `proxy::String`: Proxy information for the client.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
"""
Base.@kwdef struct PoloniexConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    PoloniexClient <: AbstractAPIsClient

Client for interacting with Poloniex exchange API.

## Fields
- `config::PoloniexConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct PoloniexClient <: AbstractAPIsClient
    config::PoloniexConfig
    curl_client::CurlClient

    function PoloniexClient(config::PoloniexConfig)
        new(config, CurlClient())
    end

    function PoloniexClient(; kw...)
        return PoloniexClient(PoloniexConfig(; kw...))
    end
end

"""
    isopen(client::PoloniexClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::PoloniexClient) = isopen(c.curl_client)

"""
    close(client::PoloniexClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::PoloniexClient) = close(c.curl_client)

"""
    public_config = PoloniexConfig(; base_url = "https://api.poloniex.com")
"""
const public_config = PoloniexConfig(; base_url = "https://api.poloniex.com")

"""
    PoloniexAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `code::Int64`: Error code.
- `message::String`: Error message.
"""
struct PoloniexAPIError{T} <: AbstractAPIsError
    code::Int64
    message::String

    function PoloniexAPIError(code::Int64, x...)
        return new{code}(code, x...)
    end
end

function Base.show(io::IO, e::PoloniexAPIError)
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", e.message, "\"")
end

CryptoExchangeAPIs.error_type(::PoloniexClient) = PoloniexAPIError

function CryptoExchangeAPIs.request_sign!(::PoloniexClient, query::Q, ::String)::Q where {Q<:PoloniexPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::PoloniexClient, query::Q, endpoint::String)::Q where {Q<:PoloniexPrivateQuery}
    query.signTimestamp = Dates.now(UTC)
    query.signature = nothing
    body::String = Serde.to_query(query)
    acces_endpoint = "/$endpoint"
    salt = join(["GET", acces_endpoint, body], "\n")
    query.signature = Base64.base64encode(digest("sha256", client.config.secret_key, salt))
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:PoloniexPublicQuery}
    return ""
end

function CryptoExchangeAPIs.request_body(query::Q)::String where {Q<:PoloniexPrivateQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:PoloniexPublicQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_query(::Q)::String where {Q<:PoloniexPrivateQuery}
    return ""
end

function CryptoExchangeAPIs.request_headers(client::PoloniexClient, ::PoloniexPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

function CryptoExchangeAPIs.request_headers(client::PoloniexClient, query::PoloniexPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "key" => client.config.public_key,
        "signTimestamp" => timestamp(NanoDate(query.signTimestamp)),
        "signature" => query.signature,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Markets/Markets.jl")

end
