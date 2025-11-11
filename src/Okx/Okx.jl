module Okx

export OkxCommonQuery,
    OkxPublicQuery,
    OkxAccessQuery,
    OkxPrivateQuery,
    OkxAPIError,
    OkxClient,
    OkxData

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

abstract type OkxData <: AbstractAPIsData end
abstract type OkxCommonQuery  <: AbstractAPIsQuery end
abstract type OkxPublicQuery  <: OkxCommonQuery end
abstract type OkxAccessQuery  <: OkxCommonQuery end
abstract type OkxPrivateQuery <: OkxCommonQuery end

"""
    Data{D} <: AbstractAPIsData

## Required fields
- `msg::String`: Return message.
- `code::Int64`: Return code.
- `data::Vector{D}`: Result values.
"""
struct Data{D<:AbstractAPIsData} <: AbstractAPIsData
    msg::String
    code::Int64
    data::Vector{D}

    function Data{D}(msg::String, code::Int64, data::Vector{D}) where {D <: AbstractAPIsData}
        @assert code == 0
        return new{D}(msg, code, data)
    end
end

"""
    OkxConfig <: AbstractAPIsConfig

Okx client config. Transport options live in `request_options::RequestOptions`.

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
Base.@kwdef struct OkxConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    passphrase::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    OkxClient <: AbstractAPIsClient

Client for interacting with Okx exchange API.

## Fields
- `config::OkxConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct OkxClient <: AbstractAPIsClient
    config::OkxConfig
    curl_client::CurlClient

    function OkxClient(config::OkxConfig)
        new(config, CurlClient())
    end

    function OkxClient(; kw...)
        return OkxClient(OkxConfig(; kw...))
    end
end

"""
    isopen(client::OkxClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::OkxClient) = isopen(c.curl_client)

"""
    close(client::OkxClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::OkxClient) = close(c.curl_client)

"""
    public_config = OkxConfig(; base_url = "https://www.okx.com")
"""
const public_config = OkxConfig(; base_url = "https://www.okx.com")

"""
    OkxAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `code::Int64`: Error code.
- `msg::String`: Error message.

## Optional fields
- `data::Vector{Any}`: Error result data.
"""
struct OkxAPIError{T} <: AbstractAPIsError
    code::Int64
    msg::String
    data::Maybe{Vector{Any}}

    function OkxAPIError(code::Int64, x...)
        iszero(code) && throw(ArgumentError("code must be nonzero"))
        return new{code}(code, x...)
    end
end

CryptoExchangeAPIs.error_type(::OkxClient) = OkxAPIError

function Base.show(io::IO, e::OkxAPIError)
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", e.msg, "\"")
end

function CryptoExchangeAPIs.request_sign!(::OkxClient, query::Q, ::String)::Q where {Q<:OkxPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::OkxClient, query::Q, endpoint::String)::Q where {Q<:OkxPrivateQuery}
    query.signature = nothing
    str_query = Serde.to_query(query)
    body::String = isempty(str_query) ? "" : "?" * str_query
    query.timestamp = Dates.now(UTC)
    salt = string(Dates.format(query.timestamp, "yyyy-mm-ddTHH:MM:SS.sss\\Z"), "GET", "/", endpoint, body)
    query.signature = Base64.base64encode(digest("sha256", client.config.secret_key, salt))
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:OkxCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:OkxCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::OkxClient, ::OkxPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json"
    ]
end

function CryptoExchangeAPIs.request_headers(client::OkxClient, query::OkxPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "OK-ACCESS-TIMESTAMP" => Dates.format(query.timestamp, "yyyy-mm-ddTHH:MM:SS.sss\\Z"),
        "Content-Type" => "application/json",
        "OK-ACCESS-KEY" => client.config.public_key,
        "OK-ACCESS-SIGN" => query.signature,
        "OK-ACCESS-PASSPHRASE" => client.config.passphrase,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("API/API.jl")

end
