module Deribit

export DeribitCommonQuery,
    DeribitPublicQuery,
    DeribitAccessQuery,
    DeribitPrivateQuery,
    DeribitAPIError,
    DeribitClient,
    DeribitData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle, EasyCurl

using ..CryptoExchangeAPIs

import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError,
    AbstractAPIsData,
    AbstractAPIsQuery,
    AbstractAPIsClient,
    AbstractAPIsConfig

abstract type DeribitData <: AbstractAPIsData end
abstract type DeribitCommonQuery  <: AbstractAPIsQuery end
abstract type DeribitPublicQuery  <: DeribitCommonQuery end
abstract type DeribitAccessQuery  <: DeribitCommonQuery end
abstract type DeribitPrivateQuery <: DeribitCommonQuery end

"""
    Data{D<:Union{Vector{A},A} where {A<:AbstractAPIsData}} <: AbstractAPIsData

## Required fields
- `jsonrpc::String`: The version of the JSON-RPC spec.
- `result::D`: If successful, the result of the API call.

## Optional fields
- `id::Maybe{Int64}`: This is the same id that was sent in the request.
- `testnet::Maybe{Bool}`: Indicates whether the API in use is actually the test API.
- `usDiff::Maybe{Int64}`: The number of microseconds that was spent handling the request.
- `usOut::Maybe{NanoDate}`: The timestamp when the response was sent (microseconds since the Unix epoch).
- `usIn::Maybe{NanoDate}`: The timestamp when the requests was received (microseconds since the Unix epoch).
"""
struct Data{D<:Union{Vector{A},A} where {A<:AbstractAPIsData}} <: AbstractAPIsData
    id::Maybe{Int64}
    jsonrpc::String
    testnet::Maybe{Bool}
    usDiff::Maybe{Int64}
    usOut::Maybe{NanoDate}
    usIn::Maybe{NanoDate}
    result::D
end

"""
    DeribitConfig <: AbstractAPIsConfig

Deribit client config.

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
Base.@kwdef struct DeribitConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    DeribitClient <: AbstractAPIsClient

Client for interacting with Deribit exchange API.

## Fields
- `config::DeribitConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct DeribitClient <: AbstractAPIsClient
    config::DeribitConfig
    curl_client::CurlClient

    function DeribitClient(config::DeribitConfig)
        new(config, CurlClient())
    end

    function DeribitClient(; kw...)
        return DeribitClient(DeribitConfig(; kw...))
    end
end

"""
    isopen(client::DeribitClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::DeribitClient) = isopen(c.curl_client)

"""
    close(client::DeribitClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::DeribitClient) = close(c.curl_client)

"""
    public_config = DeribitConfig(; base_url = "https://www.deribit.com")
"""
const public_config = DeribitConfig(; base_url = "https://www.deribit.com")

"""
    DeribitAPIsErrorMsg <: AbstractAPIsError

## Required fields
- `data::Dict{String,String}`: Additional data about the error.
- `message::String`: A short description that indicates the kind of error.
- `code::Int64`: A number that indicates the kind of error.
"""
struct DeribitAPIsErrorMsg <: AbstractAPIsError
    data::Dict{String,String}
    message::String
    code::Int64
end

"""
    DeribitAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `jsonrpc::String`: The version of the JSON-RPC spec.
- `error::DeribitAPIsErrorMsg`: Only present if there was an error invoking the method.

## Optional fields
- `id::Maybe{Int64}`: This is the same id that was sent in the request.
- `testnet::Maybe{Bool}`: Indicates whether the API in use is actually the test API.
- `usDiff::Maybe{Int64}`: The number of microseconds that was spent handling the request.
- `usOut::Maybe{NanoDate}`: The timestamp when the response was sent (microseconds since the Unix epoch).
- `usIn::Maybe{NanoDate}`: The timestamp when the requests was received (microseconds since the Unix epoch).
"""
struct DeribitAPIError{T} <: AbstractAPIsError
    error::DeribitAPIsErrorMsg
    id::Maybe{Int64}
    jsonrpc::String
    testnet::Maybe{Bool}
    usDiff::Maybe{Int64}
    usOut::Maybe{NanoDate}
    usIn::Maybe{NanoDate}

    function DeribitAPIError(error::DeribitAPIsErrorMsg, x...)
        return new{error.code}(error, x...)
    end
end

function Base.show(io::IO, e::DeribitAPIError)
    return print(io, "code = ", "\"", e.error.code, "\"", ", ", "msg = ", "\"", e.error.message, "\"")
end

CryptoExchangeAPIs.error_type(::DeribitClient) = DeribitAPIError

function CryptoExchangeAPIs.request_sign!(::DeribitClient, query::Q, ::String)::Q where {Q<:DeribitPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:DeribitPublicQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:DeribitPublicQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::DeribitClient, ::DeribitPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("API/API.jl")

end
