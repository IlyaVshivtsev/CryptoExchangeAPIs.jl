module Days

export DaysQuery,
    DaysData,
    days

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Upbit
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct DaysQuery <: UpbitPublicQuery
    market::String
    convertingPriceUnit::Maybe{String} = nothing
    count::Maybe{Int64} = nothing                  # Count of candles (LIMIT : 200)
    to::Maybe{DateTime} = nothing
end

struct DaysData <: UpbitData
    market::Maybe{String}
    candle_acc_trade_price::Maybe{Float64}
    candle_acc_trade_volume::Maybe{Float64}
    candle_date_time_kst::Maybe{NanoDate}
    candle_date_time_utc::Maybe{NanoDate}
    change_price::Maybe{Float64}
    change_rate::Maybe{Float64}
    high_price::Maybe{Float64}
    low_price::Maybe{Float64}
    opening_price::Maybe{Float64}
    prev_closing_price::Maybe{Float64}
    timestamp::Maybe{NanoDate}
    trade_price::Maybe{Float64}
end

"""
    days(client::UpbitClient, query::DaysQuery)
    days(client::UpbitClient = Upbit.UpbitClient(Upbit.public_config); kw...)

Daily candle data.

[`GET v1/candles/days`](https://docs.upbit.com/reference/일day-캔들-1)

## Parameters:

| Parameter           | Type     | Required | Description |
|:--------------------|:---------|:---------|:------------|
| market              | String   | true     |             |
| convertingPriceUnit | String   | false    |             |
| count               | Int64    | false    | Max: 200    |
| to                  | DateTime | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Upbit

result = Upbit.V1.Candles.days(;
    market = "KRW-BTC"
)
```
"""
function days(client::UpbitClient, query::DaysQuery)
    return APIsRequest{Vector{DaysData}}("GET", "v1/candles/days", query)(client)
end

function days(
    client::UpbitClient = Upbit.UpbitClient(Upbit.public_config);
    kw...,
)
    return days(client, DaysQuery(; kw...))
end

end

