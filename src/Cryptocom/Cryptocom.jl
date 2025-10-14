module Cryptocom

export CryptocomCommonQuery,
    CryptocomPublicQuery,
    CryptocomAccessQuery,
    CryptocomPrivateQuery,
    CryptocomAPIError,
    CryptocomClient,
    CryptocomData

using Serde
using Dates, NanoDates, Base64, Nettle, EasyCurl

using ..CryptoExchangeAPIs

import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError,
    AbstractAPIsData,
    AbstractAPIsQuery,
    AbstractAPIsClient,
    AbstractAPIsConfig

abstract type CryptocomData <: AbstractAPIsData end
abstract type CryptocomCommonQuery <: AbstractAPIsQuery end
abstract type CryptocomPublicQuery <: CryptocomCommonQuery end
abstract type CryptocomAccessQuery <: CryptocomCommonQuery end
abstract type CryptocomPrivateQuery <: CryptocomCommonQuery end

"""
    Data{D} <: AbstractAPIsData

## Required fields
- `id::Int64`: Return id.
- `method::String`: Return method endpoint.
- `code::String`: Return code.
- `result::D`: Request result data.
"""
struct Data{D<:AbstractAPIsData} <: AbstractAPIsData
    id::Int64
    method::String
    code::String
    result::D
end

"""
    CryptocomConfig <: AbstractAPIsConfig

Crypto.com client config.

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
Base.@kwdef struct CryptocomConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    CryptocomClient <: AbstractAPIsClient

Client for interacting with Crypto.com exchange API.

## Fields
- `config::CryptocomConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct CryptocomClient <: AbstractAPIsClient
    config::CryptocomConfig
    curl_client::CurlClient

    function CryptocomClient(config::CryptocomConfig)
        new(config, CurlClient())
    end

    function CryptocomClient(; kw...)
        return CryptocomClient(CryptocomConfig(; kw...))
    end
end

"""
    isopen(client::CryptocomClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::CryptocomClient) = isopen(c.curl_client)

"""
    close(client::CryptocomClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::CryptocomClient) = close(c.curl_client)

"""
    public_config = CryptocomConfig(; base_url = "https://api.crypto.com/exchange/v1")
"""
const public_config = CryptocomConfig(; base_url = "https://api.crypto.com/exchange/v1")

"""
    CryptocomAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `code::Int64`: Error code.

## Optional fields
- `message::String`: Error message.
- `description::String`: Error description.
"""
struct CryptocomAPIError{T} <: AbstractAPIsError
    code::Int64
    message::Maybe{String}
    description::Maybe{String}

    function CryptocomAPIError(code::Int64, x...)
        return new{code}(code, x...)
    end
end

CryptoExchangeAPIs.error_type(::CryptocomClient) = CryptocomAPIError

function Base.show(io::IO, e::CryptocomAPIError)
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", e.message, "\"", ", ", "desc = ", "\"", e.description, "\"")
end

struct CryptocomUndefError <: AbstractAPIsError
    e::Exception
    msg::String
end

function CryptoExchangeAPIs.request_sign!(::CryptocomClient, query::Q, ::String)::Q where {Q<:CryptocomPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:CryptocomCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:CryptocomCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::CryptocomClient, ::CryptocomPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

include("Utils.jl")

include("Public/Public.jl")

end
