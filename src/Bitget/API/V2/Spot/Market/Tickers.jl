module Tickers

export TickersQuery,
    TickersData,
    tickers

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bitget
using CryptoExchangeAPIs.Bitget: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickersQuery <: BitgetPublicQuery
    symbol::Maybe{String} = nothing
end

struct TickersData <: BitgetData
    symbol::String
    high24h::Float64
    open::Float64
    lastPr::Float64
    low24h::Float64
    quoteVolume::Float64
    baseVolume::Float64
    usdtVolume::Float64
    bidPr::Float64
    askPr::Float64
    bidSz::Maybe{Float64}
    askSz::Maybe{Float64}
    openUtc::Float64
    ts::NanoDate
    changeUtc24h::Float64
    change24h::Float64
end

"""
    tickers(client::BitgetClient, query::TickersQuery)
    tickers(client::BitgetClient = Bitget.BitgetClient(Bitget.public_config); kw...)

Get ticker information, supporting both single and batch queries.

[`GET api/v2/spot/market/tickers`](https://www.bitget.com/api-doc/spot/market/Get-Tickers)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | false    | Trading pair symbol (e.g., "BTCUSDT"). If not provided, returns all tickers. |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitget

# Get all tickers
result = Bitget.API.V2.Spot.Market.tickers()

# Get specific ticker
result = Bitget.API.V2.Spot.Market.tickers(; symbol = "BTCUSDT")
```
"""
function tickers(client::BitgetClient, query::TickersQuery)
    return APIsRequest{Data{Vector{TickersData}}}("GET", "api/v2/spot/market/tickers", query)(client)
end

function tickers(
    client::BitgetClient = Bitget.BitgetClient(Bitget.public_config);
    kw...,
)
    return tickers(client, TickersQuery(; kw...))
end

end
