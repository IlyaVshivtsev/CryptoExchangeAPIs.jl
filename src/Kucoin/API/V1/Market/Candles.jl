module Candles

export CandlesQuery,
    CandlesData,
    candles

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data, Page
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 w1

Base.@kwdef struct CandlesQuery <: KucoinPublicQuery
    symbol::String
    type::TimeInterval.T
    endAt::Maybe{DateTime} = nothing
    startAt::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:CandlesQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1min"
    x == TimeInterval.m3  && return "3min"
    x == TimeInterval.m5  && return "5min"
    x == TimeInterval.m15 && return "15min"
    x == TimeInterval.m30 && return "30min"
    x == TimeInterval.h1  && return "1hour"
    x == TimeInterval.h2  && return "2hour"
    x == TimeInterval.h4  && return "4hour"
    x == TimeInterval.h6  && return "6hour"
    x == TimeInterval.h8  && return "8hour"
    x == TimeInterval.h12 && return "12hour"
    x == TimeInterval.d1  && return "1day"
    x == TimeInterval.w1  && return "1week"
end

struct CandlesData <: KucoinData
    time::NanoDate
    open::Maybe{Float64}
    close::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    volume::Maybe{Float64}
    turnover::Maybe{Float64}
end

"""
    candles(client::KucoinClient, query::CandlesQuery)
    candles(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config); kw...)

Request via this endpoint to get the kline of the specified symbol.

[`GET api/v1/market/candles`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-klines)

## Parameters:

| Parameter | Type         | Required | Description                               |
|:----------|:-------------|:---------|:------------------------------------------|
| symbol    | String       | true     |                                           |
| type      | TimeInterval | true     | m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 w1 |
| endAt     | DateTime     | false    |                                           |
| startAt   | DateTime     | false    |                                           |

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin

result = Kucoin.API.V1.Market.candles(;
    symbol = "BTC-USDT",
    type = Kucoin.API.V1.Market.Candles.TimeInterval.m1,
)
```
"""
function candles(client::KucoinClient, query::CandlesQuery)
    return APIsRequest{Data{Vector{CandlesData}}}("GET", "api/v1/market/candles", query)(client)
end

function candles(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config); kw...)
    return candles(client, CandlesQuery(; kw...))
end

end
