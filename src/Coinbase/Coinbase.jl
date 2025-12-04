module Coinbase

export CoinbaseCommonQuery,
    CoinbasePublicQuery,
    CoinbaseAccessQuery,
    CoinbasePrivateQuery,
    CoinbaseAPIError,
    CoinbaseConfig,
    CoinbaseClient,
    CoinbaseData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle, EasyCurl

using ..CryptoExchangeAPIs

import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError,
    AbstractAPIsData,
    AbstractAPIsQuery,
    AbstractAPIsClient,
    AbstractAPIsConfig,
    RequestOptions

abstract type CoinbaseData <: AbstractAPIsData end
abstract type CoinbaseCommonQuery  <: AbstractAPIsQuery end
abstract type CoinbasePublicQuery  <: CoinbaseCommonQuery end
abstract type CoinbaseAccessQuery  <: CoinbaseCommonQuery end
abstract type CoinbasePrivateQuery <: CoinbaseCommonQuery end

"""
    CoinbaseConfig <: AbstractAPIsConfig

Coinbase client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client.

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `passphrase::String`: Passphrase for authentication.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct CoinbaseConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    passphrase::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    CoinbaseClient <: AbstractAPIsClient

Client for interacting with Coinbase exchange API.

## Fields
- `config::CoinbaseConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct CoinbaseClient <: AbstractAPIsClient
    config::CoinbaseConfig
    curl_client::CurlClient

    function CoinbaseClient(config::CoinbaseConfig)
        new(config, CurlClient())
    end

    function CoinbaseClient(; kw...)
        return CoinbaseClient(CoinbaseConfig(; kw...))
    end
end

"""
    isopen(client::CoinbaseClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::CoinbaseClient) = isopen(c.curl_client)

"""
    close(client::CoinbaseClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::CoinbaseClient) = close(c.curl_client)

"""
    public_config = CoinbaseConfig(; base_url = "https://api.exchange.coinbase.com")
"""
const public_config = CoinbaseConfig(; base_url = "https://api.exchange.coinbase.com")

"""
    CoinbaseAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `msg::String`: Error message.
"""
struct CoinbaseAPIError{T} <: AbstractAPIsError
    message::String

    function CoinbaseAPIError(message::String, x...)
        return new{Symbol(message)}(message, x...)
    end
end

CryptoExchangeAPIs.error_type(::CoinbaseClient) = CoinbaseAPIError

function Base.show(io::IO, e::CoinbaseAPIError)
    return print(io, "message = ", "\"", e.message)
end

function CryptoExchangeAPIs.request_sign!(::CoinbaseClient, query::Q, ::String)::Q where {Q<:CoinbasePublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::CoinbaseClient, query::Q, endpoint::String)::Q where {Q<:CoinbasePrivateQuery}
    query.timestamp = string(round(Int64, datetime2unix(Dates.now(UTC))))
    query.signature = nothing
    str_query = isempty(Serde.to_query(query)) ? "" : "?" * Serde.to_query(query)
    endpoint = "/" * endpoint * str_query
    message = join([query.timestamp, "GET", endpoint, ""])
    query.signature = base64encode(digest("sha256", base64decode(client.config.secret_key), message))
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:CoinbaseCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:CoinbaseCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::CoinbaseClient, ::CoinbasePublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "User-Agent" => "CryptoExchangeAPIs.Coinbase",
    ]
end

function CryptoExchangeAPIs.request_headers(client::CoinbaseClient, query::CoinbasePrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "CB-ACCESS-KEY" => client.config.public_key,
        "CB-ACCESS-SIGN" => query.signature,
        "CB-ACCESS-TIMESTAMP" => query.timestamp,
        "CB-ACCESS-PASSPHRASE" => client.config.passphrase,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Currencies/Currencies.jl")
using .Currencies

include("Products/Products.jl")
using .Products

include("Withdrawals/Withdrawals.jl")
using .Withdrawals

end
