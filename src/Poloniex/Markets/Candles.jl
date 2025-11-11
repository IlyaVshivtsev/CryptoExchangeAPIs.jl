module Candles

export CandlesQuery,
    CandlesData,
    candles

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Poloniex
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m5 m10 m15 m30 h1 h2 h4 h6 h12 d1 d3 w1 M1

Base.@kwdef struct CandlesQuery <: PoloniexPublicQuery
    interval::TimeInterval.T
    symbol::Maybe{String} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{CandlesQuery}, ::Val{:symbol}) = true

function Serde.ser_type(::Type{<:CandlesQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "MINUTE_1"
    x == TimeInterval.m5  && return "MINUTE_5"
    x == TimeInterval.m10 && return "MINUTE_10"
    x == TimeInterval.m15 && return "MINUTE_15"
    x == TimeInterval.m30 && return "MINUTE_30"
    x == TimeInterval.h1  && return "HOUR_1"
    x == TimeInterval.h2  && return "HOUR_2"
    x == TimeInterval.h4  && return "HOUR_4"
    x == TimeInterval.h6  && return "HOUR_6"
    x == TimeInterval.h12 && return "HOUR_12"
    x == TimeInterval.d1  && return "DAY_1"
    x == TimeInterval.d3  && return "DAY_3"
    x == TimeInterval.w1  && return "WEEK_1"
    x == TimeInterval.M1  && return "MONTH_1"
end

struct CandlesData <: PoloniexData
    low::Maybe{Float64}
    high::Maybe{Float64}
    open::Maybe{Float64}
    close::Maybe{Float64}
    amount::Maybe{Float64}
    quantity::Maybe{Float64}
    buyTakerAmount::Maybe{Float64}
    buyTakerQuantity::Maybe{Float64}
    tradeCount::Maybe{Int64}
    ts::Maybe{Int64}
    weightedAverage::Maybe{Float64}
    interval::Maybe{String}
    startTime::NanoDate
    closeTime::Maybe{NanoDate}
end

"""
    candles(client::PoloniexClient, query::CandlesQuery)
    candles(client::PoloniexClient = Poloniex.PoloniexClient(Poloniex.public_config); kw...)

Get latest trade price for all symbols.

[`GET markets/{symbol}/price`](https://api-docs.poloniex.com/spot/api/public/market-data)

## Parameters:

| Parameter | Type         | Required | Description                                                               |
|:----------|:-------------|:---------|:--------------------------------------------------------------------------|
| interval  | TimeInterval | true     | `m1` `m5` `m10` `m15` `m30` `h1` `h2` `h4` `h6` `h12` `d1` `d3` `w1` `M1` |
| symbol    | String       | false    |                                                                           |
| startTime | DateTime     | false    |                                                                           |
| endTime   | DateTime     | false    |                                                                           |
| limit     | Int64        | false    |                                                                           |

## Code samples:

```julia
using CryptoExchangeAPIs.Poloniex

result = Poloniex.Markets.Candles.candles(;
    symbol = "BTC_USDT",
    interval = Poloniex.Markets.Candles.TimeInterval.m5,
    startTime = now(UTC) - Minute(100),
    endTime = now(UTC) - Hour(1),
)
```
"""
function candles(client::PoloniexClient, query::CandlesQuery; kw...)
    endpoint = isnothing(query.symbol) ? "markets/candles" : "markets/$(query.symbol)/candles"
    return APIsRequest{Vector{CandlesData}}("GET", endpoint, query)(client)
end

function candles(
    client::PoloniexClient = Poloniex.PoloniexClient(Poloniex.public_config);
    kw...,
)
    return candles(client, CandlesQuery(; kw...))
end

end
