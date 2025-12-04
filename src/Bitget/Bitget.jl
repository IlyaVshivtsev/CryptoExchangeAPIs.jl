module Bitget

export BitgetCommonQuery,
       BitgetPublicQuery,
       BitgetAccessQuery,
       BitgetPrivateQuery,
       BitgetAPIError,
       BitgetClient,
       BitgetConfig,
       BitgetData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle, EasyCurl
using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery,
    AbstractAPIsClient, AbstractAPIsConfig, RequestOptions

# ---------------------------------------------------------------------------

abstract type BitgetData <: AbstractAPIsData end
abstract type BitgetCommonQuery  <: AbstractAPIsQuery end
abstract type BitgetPublicQuery  <: BitgetCommonQuery end
abstract type BitgetAccessQuery  <: BitgetCommonQuery end
abstract type BitgetPrivateQuery <: BitgetCommonQuery end

"""
    BitgetConfig <: AbstractAPIsConfig

Bitget client config. Transport options live in `request_options::RequestOptions`.

Required:
- `base_url::String`

Optional:
- `public_key::String`
- `secret_key::String`
- `account_name::String`
- `description::String`
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct BitgetConfig <: AbstractAPIsConfig
    base_url::String = "https://api.bitget.com"
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    passphrase::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

mutable struct BitgetClient <: AbstractAPIsClient
    config::BitgetConfig
    curl_client::CurlClient
    function BitgetClient(config::BitgetConfig)
        new(config, CurlClient())
    end
    function BitgetClient(; kw...)
        BitgetClient(BitgetConfig(; kw...))
    end
end

Base.isopen(c::BitgetClient) = isopen(c.curl_client)
Base.close(c::BitgetClient)  = close(c.curl_client)

const public_config = BitgetConfig(; base_url = "https://api.bitget.com")

# ---------------------------------------------------------------------------

struct Data{D} <: BitgetData
    code::Int64
    msg::String
    requestTime::NanoDate
    data::D
    function Data{D}(
        code::Int,
        msg::String,
        requestTime::NanoDate,
        data::D,
    ) where {D <: Union{BitgetData,Vector{<:BitgetData}}}
        code == 0 || throw(ArgumentError("API response code must be zero"))
        new{D}(code, msg, requestTime, data)
    end
end

struct BitgetAPIError{T} <: AbstractAPIsError
    code::Int
    msg::Maybe{String}
    requestTime::NanoDate
    function BitgetAPIError(code::Int, x...)
        iszero(code) && throw(ArgumentError("API responsecode must not be zero"))
        new{code}(code, x...)
    end
end

CryptoExchangeAPIs.error_type(::BitgetClient) = BitgetAPIError

function Base.show(io::IO, e::BitgetAPIError)
    print(io, "code=\"", e.code, "\", msg=\"", e.msg, "\"")
end

# --- signing ---------------------------------------------------------------

function CryptoExchangeAPIs.request_sign!(
    ::BitgetClient,
    query::BitgetPublicQuery,
    ::AbstractString
)
    query
end

function CryptoExchangeAPIs.request_sign!(
    client::BitgetClient,
    query::BitgetPrivateQuery,
    ::AbstractString
)
    if client.config.secret_key === nothing
        throw(ArgumentError("secret_key is required for Bitget private endpoints"))
    end
    query.timestamp = Dates.now(UTC)
    query.sign = nothing
    query_string = Serde.to_query(query)
    query_string = isempty(query_string) ? "" : "?" * query_string
    salt = string(time2unix(query.timestamp), "GET", "/", endpoint, query_string)
    query.sign = base64encode(hmac_sha256(collect(codeunits(client.config.secret_key)), salt))
    query
end

function CryptoExchangeAPIs.request_sign!(
    ::BitgetClient,
    query::BitgetAccessQuery,
    ::AbstractString
)
    query
end

# --- body/query ------------------------------------------------------------

CryptoExchangeAPIs.request_body(::Q) where {Q<:BitgetCommonQuery} = ""
CryptoExchangeAPIs.request_query(query::Q) where {Q<:BitgetCommonQuery} = Serde.to_query(query)

# --- headers ---------------------------------------------------------------

function CryptoExchangeAPIs.request_headers(
    ::BitgetClient,
    ::BitgetPublicQuery
)
    ["Content-Type" => "application/json"]
end

function CryptoExchangeAPIs.request_headers(
    client::BitgetClient,
    ::BitgetPrivateQuery
)
    [
        "ACCESS-KEY" => client.config.public_key,
        "ACCESS-SIGN" => query.sign,
        "ACCESS-TIMESTAMP" => string(time2unix(query.timestamp)),
        "ACCESS-PASSPHRASE" => client.config.passphrase,
        "Content-Type" => "application/json",
        "locale" => "en-US",
    ]
end

function CryptoExchangeAPIs.request_headers(
    client::BitgetClient,
    ::BitgetAccessQuery
)
    h = ["Content-Type" => "application/json"]
    if client.config.public_key !== nothing
        push!(h, "X-MBX-APIKEY" => client.config.public_key)
    end
    h
end

# --- rest ------------------------------------------------------------------

include("Errors.jl")
include("Utils.jl")

include("API/API.jl")
using .API

end
