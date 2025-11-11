module ContinuousKlines

export ContinuousKlinesQuery,
    ContinuousKlinesData,
    continuous_klines

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1

@enumx ContractType PERPETUAL CURRENT_QUARTER NEXT_QUARTER

Base.@kwdef struct ContinuousKlinesQuery <: BinancePublicQuery
    pair::String
    contractType::ContractType.T
    interval::TimeInterval.T
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:ContinuousKlinesQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m3  && return "3m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h2  && return "2h"
    x == TimeInterval.h4  && return "4h"
    x == TimeInterval.h6  && return "6h"
    x == TimeInterval.h8  && return "8h"
    x == TimeInterval.h12 && return "12h"
    x == TimeInterval.d1  && return "1d"
    x == TimeInterval.d3  && return "3d"
    x == TimeInterval.w1  && return "1w"
    x == TimeInterval.M1  && return "1M"
end

struct ContinuousKlinesData <: BinanceData
    openTime::NanoDate
    openPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    lowPrice::Maybe{Float64}
    closePrice::Maybe{Float64}
    volume::Maybe{Float64}
    closeTime::NanoDate
    quoteAssetVolume::Maybe{Float64}
    tradesNumber::Maybe{Int64}
    takerBuyVolume::Maybe{Float64}
    takerBuyQuoteAssetVolume::Maybe{Float64}
end

"""
    continuous_klines(client::BinanceClient, query::ContinuousKlinesQuery)
    continuous_klines(client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config); kw...)

Kline/candlestick bars for a specific contract type. Klines are uniquely identified by their open time.

[`GET fapi/v1/continuousKlines`](https://binance-docs.github.io/apidocs/futures/en/#continuous-contract-kline-candlestick-data)

## Parameters:

| Parameter    | Type         | Required | Description                                |
|:-------------|:-------------|:---------|:-------------------------------------------|
| pair         | String       | true     |                                            |
| contractType | ContractType | true     | PERPETUAL CURRENT\\_QUARTER NEXT\\_QUARTER |
| interval     | TimeInterval | true     | m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1 |
| endTime      | DateTime     | false    |                                            |
| limit        | Int64        | false    | Default: 500; Max: 1500                    |
| startTime    | DateTime     | false    |                                            |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.FAPI.V1.continuous_klines(;
    pair = "BTCUSDT",
    contractType = Binance.FAPI.V1.ContinuousKlines.ContractType.PERPETUAL,
    interval = Binance.FAPI.V1.ContinuousKlines.TimeInterval.h1,
    limit = 10,
)
```
"""
function continuous_klines(client::BinanceClient, query::ContinuousKlinesQuery)
    return APIsRequest{Vector{ContinuousKlinesData}}("GET", "fapi/v1/continuousKlines", query)(client)
end

function continuous_klines(
    client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config);
    kw...,
)
    return continuous_klines(client, ContinuousKlinesQuery(; kw...))
end

end

