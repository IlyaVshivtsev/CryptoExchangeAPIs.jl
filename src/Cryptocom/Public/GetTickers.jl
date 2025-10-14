module GetTickers

export GetTickersQuery,
    GetTickersData,
    get_tickers

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Cryptocom
using CryptoExchangeAPIs.Cryptocom: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct GetTickersQuery <: CryptocomPublicQuery
    instrument_name::Maybe{String} = nothing
end

struct TickerInfo <: CryptocomData
    i::String
    h::Float64
    l::Maybe{Float64}
    a::Maybe{Float64}
    v::Float64
    vv::Float64
    oi::Maybe{Float64}
    c::Maybe{Float64}
    b::Maybe{Float64}
    k::Maybe{Float64}
    t::NanoDate
end

function Serde.isempty(::Type{TickerInfo}, x)::Bool
    return x === ""
end

struct GetTickersData <: CryptocomData
    data::Vector{TickerInfo}
end

function Serde.isempty(::Type{GetTickersData}, x)::Bool
    return x == []
end

"""
    get_tickers(client::CryptocomClient, query::GetTickersQuery)
    get_tickers(client::CryptocomClient = Cryptocom.CryptocomClient(Cryptocom.public_config); kw...)

Fetches the public tickers for all or a particular instrument.

[`GET public/get-tickers`](https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#public-get-tickers)

## Parameters:

| Parameter       | Type     | Required | Description |
|:----------------|:---------|:---------|:------------|
| instrument_name | String   | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Cryptocom

result = Cryptocom.Public.get_tickers(;
    instrument_name = "BTCUSD-PERP"
)
```
"""
function get_tickers(client::CryptocomClient, query::GetTickersQuery)
    return APIsRequest{Data{GetTickersData}}("GET", "public/get-tickers", query)(client)
end

function get_tickers(
    client::CryptocomClient = Cryptocom.CryptocomClient(Cryptocom.public_config);
    kw...
)
    return get_tickers(client, GetTickersQuery(; kw...))
end

end

