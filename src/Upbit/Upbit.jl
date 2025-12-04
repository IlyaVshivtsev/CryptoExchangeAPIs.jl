module Upbit

export UpbitCommonQuery,
    UpbitPublicQuery,
    UpbitAccessQuery,
    UpbitPrivateQuery,
    UpbitAPIError,
    UpbitConfig,
    UpbitClient,
    UpbitData

using Serde
using Dates, NanoDates, Base64, Nettle, EasyCurl
using UUIDs, JSONWebTokens

using ..CryptoExchangeAPIs

import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError,
    AbstractAPIsData,
    AbstractAPIsQuery,
    AbstractAPIsClient,
    AbstractAPIsConfig,
    RequestOptions

abstract type UpbitData <: AbstractAPIsData end
abstract type UpbitCommonQuery <: AbstractAPIsQuery end
abstract type UpbitPublicQuery <: UpbitCommonQuery end
abstract type UpbitAccessQuery <: UpbitCommonQuery end
abstract type UpbitPrivateQuery <: UpbitCommonQuery end

"""
    UpbitConfig <: AbstractAPIsConfig

Upbit client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client.

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct UpbitConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    UpbitClient <: AbstractAPIsClient

Client for interacting with Upbit exchange API.

## Fields
- `config::UpbitConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct UpbitClient <: AbstractAPIsClient
    config::UpbitConfig
    curl_client::CurlClient

    function UpbitClient(config::UpbitConfig)
        new(config, CurlClient())
    end

    function UpbitClient(; kw...)
        return UpbitClient(UpbitConfig(; kw...))
    end
end

"""
    isopen(client::UpbitClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::UpbitClient) = isopen(c.curl_client)

"""
    close(client::UpbitClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::UpbitClient) = close(c.curl_client)

"""
    public_config = UpbitConfig(; base_url = "https://api.upbit.com")
"""
const public_config = UpbitConfig(; base_url = "https://api.upbit.com")

struct UpbitAPIsErrorMsg
    name::Int64
    message::String
end

"""
    UpbitAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields in UpbitAPIsErrorMsg
- `name::Int64`: Error code.
- `message::String`: Error message.

## Required fields
- `error::UpbitAPIsErrorMsg`: Error struct.
"""
struct UpbitAPIError{T} <: AbstractAPIsError
    error::UpbitAPIsErrorMsg

    function UpbitAPIError(error::UpbitAPIsErrorMsg)
        return new{error.name}(error)
    end
end

CryptoExchangeAPIs.error_type(::UpbitClient) = UpbitAPIError

function Base.show(io::IO, e::UpbitAPIError)
    return print(io, "name = ", "\"", e.error.name, "\"", ", ", "msg = ", "\"", e.error.message, "\"")
end

struct UpbitUndefError <: AbstractAPIsError
    e::Exception
    msg::String
end

function CryptoExchangeAPIs.request_sign!(::UpbitClient, query::Q, ::String)::Q where {Q<:UpbitPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::UpbitClient, query::Q, ::String)::Q where {Q<:UpbitPrivateQuery}
    query.signature = nothing
    body = Dict{String,String}(
        "access_key" => client.config.public_key,
        "nonce" => string(UUIDs.uuid1()),
    )
    qstr = Serde.to_query(query)
    if !isempty(qstr)
        merge!(body, Dict{String,String}(
            "query_hash" => hexdigest("sha512", qstr),
            "query_hash_alg" => "SHA512",
        ))
    end
    hs512 = JSONWebTokens.HS512(client.config.secret_key)
    token = JSONWebTokens.encode(hs512, body)
    query.signature = "Bearer $token"
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:UpbitCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:UpbitCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::UpbitClient, ::UpbitPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

function CryptoExchangeAPIs.request_headers(client::UpbitClient, query::UpbitPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Authorization" => query.signature,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("V1/V1.jl")

end
