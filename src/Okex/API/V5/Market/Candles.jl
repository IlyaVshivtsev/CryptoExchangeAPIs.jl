module Candles

export CandlesQuery,
    CandlesData,
    candles

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Okex
using CryptoExchangeAPIs.Okex: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h12 d1 d2 d3 w1 M1 M3

Base.@kwdef struct CandlesQuery <: OkexPublicQuery
    instId::String
    after::Maybe{DateTime} = nothing
    bar::Maybe{TimeInterval.T} = nothing
    before::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
end

function Serde.ser_type(::Type{<:CandlesQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m3  && return "3m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1H"
    x == TimeInterval.h2  && return "2H"
    x == TimeInterval.h4  && return "4H"
    x == TimeInterval.h6  && return "6Hutc"
    x == TimeInterval.h12 && return "12Hutc"
    x == TimeInterval.d1  && return "1Dutc"
    x == TimeInterval.d2  && return "2Dutc"
    x == TimeInterval.d3  && return "3Dutc"
    x == TimeInterval.w1  && return "1Wutc"
    x == TimeInterval.M1  && return "1Mutc"
    x == TimeInterval.M3  && return "3Mutc"
end

struct CandlesData <: OkexData
    openTime::Maybe{NanoDate}
    openPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    lowPrice::Maybe{Float64}
    closePrice::Maybe{Float64}
    vol::Maybe{Float64}
    volCcy::Maybe{Float64}
    volCcyQuote::Maybe{Float64}
    confirm::Maybe{Int64}
end

"""
    candles(client::OkexClient, query::CandlesQuery)
    candles(client::OkexClient = Okex.OkexClient(Okex.public_config); kw...)

Retrieve the candlestick charts.

[`GET api/v5/market/candles`](https://www.okx.com/docs-v5/en/#rest-api-market-data-get-candlesticks)

## Parameters:

| Parameter | Type         | Required | Description                                        |
|:----------|:-------------|:---------|:---------------------------------------------------|
| instId    | String       | true     |                                                    |
| after     | DateTime     | false    |                                                    |
| bar       | TimeInterval | false    | m1 m3 m5 m15 m30 h1 h2 h4 h6 h12 d1 d2 d3 w1 M1 M3 |
| before    | DateTime     | false    |                                                    |
| limit     | Int64        | false    |                                                    |

## Code samples:

```julia
using CryptoExchangeAPIs.Okex

result = Okex.API.V5.Market.candles(;
    instId = "BTC-USDT",
    bar = Okex.API.V5.Market.Candles.TimeInterval.d1,
)
```
"""
function candles(client::OkexClient, query::CandlesQuery)
    return APIsRequest{Data{CandlesData}}("GET", "api/v5/market/candles", query)(client)
end

function candles(client::OkexClient = Okex.OkexClient(Okex.public_config); kw...)
    return candles(client, CandlesQuery(; kw...))
end

end
