module Ticker24hr

export Ticker24hrQuery,
    Ticker24hrData,
    ticker_24hr

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct Ticker24hrQuery <: BinancePublicQuery
    symbol::Maybe{String} = nothing
    pair::Maybe{String} = nothing
end

struct Ticker24hrData <: BinanceData
    symbol::String
    pair::String
    pricechange::Maybe{Float64}
    pricechangePercent::Maybe{Float64}
    weightedAvgPrice::Maybe{Float64}
    lastPrice::Maybe{Float64}
    lastQty::Maybe{Int64}
    openPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    lowPrice::Maybe{Float64}
    volume::Maybe{Int64}
    baseVolume::Maybe{Float64}
    openTime::NanoDate
    closeTime::NanoDate
    firstId::Maybe{Int64}
    lastId::Maybe{Int64}
    count::Maybe{Int64}
end

"""
    ticker_24hr(client::BinanceClient, query::Ticker24hrQuery)
    ticker_24hr(client::BinanceClient = Binance.BinanceClient(Binance.public_dapi_config); kw...)

24 hour rolling window price change statistics.

[`GET dapi/v1/ticker/24hr`](https://binance-docs.github.io/apidocs/delivery/en/#24hr-ticker-price-change-statistics)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | false    |             |
| pair      | String | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.DAPI.V1.ticker_24hr(;
    pair = "BTCUSD",
)
```
"""
function ticker_24hr(client::BinanceClient, query::Ticker24hrQuery)
    return APIsRequest{Vector{Ticker24hrData}}("GET", "dapi/v1/ticker/24hr", query)(client)
end

function ticker_24hr(
    client::BinanceClient = Binance.BinanceClient(Binance.public_dapi_config);
    kw...,
)
    return ticker_24hr(client, Ticker24hrQuery(; kw...))
end

end

