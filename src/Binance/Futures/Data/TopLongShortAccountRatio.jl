module TopLongShortAccountRatio

export TopLongShortAccountRatioQuery,
    TopLongShortAccountRatioData,
    top_long_short_account_ratio

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m5 m15 m30 h1 h2 h4 h6 h12 d1

Base.@kwdef struct TopLongShortAccountRatioQuery <: BinancePublicQuery
    symbol::String
    period::TimeInterval.T
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:TopLongShortAccountRatioQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h2  && return "2h"
    x == TimeInterval.h4  && return "4h"
    x == TimeInterval.h6  && return "6h"
    x == TimeInterval.h12 && return "12h"
    x == TimeInterval.d1  && return "1d"
end

struct TopLongShortAccountRatioData <: BinanceData
    symbol::String
    longShortRatio::Maybe{Float64}
    longAccount::Maybe{Float64}
    shortAccount::Maybe{Float64}
    timestamp::NanoDate
end

"""
    top_long_short_account_ratio(client::BinanceClient, query::TopLongShortAccountRatioQuery)
    top_long_short_account_ratio(client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config); kw...)

Top trader long/short ratio (accounts).

[`GET futures/data/topLongShortAccountRatio`](https://binance-docs.github.io/apidocs/futures/en/#top-trader-long-short-ratio-accounts)

## Parameters:

| Parameter | Type         | Required | Description                   |
|:----------|:-------------|:---------|:------------------------------|
| symbol    | String       | true     |                               |
| period    | TimeInterval | true     | m5 m15 m30 h1 h2 h4 h6 h12 d1 |
| endTime   | DateTime     | false    |                               |
| limit     | Int64        | false    | Default: 30, Max: 500         |
| startTime | DateTime     | false    |                               |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.Futures.Data.top_long_short_account_ratio(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.TopLongShortAccountRatio.TimeInterval.h1,
)
```
"""
function top_long_short_account_ratio(client::BinanceClient, query::TopLongShortAccountRatioQuery)
    return APIsRequest{Vector{TopLongShortAccountRatioData}}("GET", "futures/data/topLongShortAccountRatio", query)(client)
end

function top_long_short_account_ratio(
    client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config);
    kw...,
)
    return top_long_short_account_ratio(client, TopLongShortAccountRatioQuery(; kw...))
end

end

