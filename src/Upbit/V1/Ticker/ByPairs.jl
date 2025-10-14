module ByPairs

export ByPairsQuery,
    ByPairsData,
    by_pairs

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Upbit
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ByPairsQuery <: UpbitPublicQuery
    markets::Union{Vector{String},String}
end

struct ByPairsData <: UpbitData
    market::String
    acc_trade_price::Maybe{Float64}
    acc_trade_price_24h::Maybe{Float64}
    acc_trade_volume::Maybe{Float64}
    acc_trade_volume_24h::Maybe{Float64}
    change::Maybe{String}
    change_price::Maybe{Float64}
    change_rate::Maybe{Float64}
    high_price::Maybe{Float64}
    highest_52_week_date::Maybe{Date}
    highest_52_week_price::Maybe{Float64}
    low_price::Maybe{Float64}
    lowest_52_week_date::Maybe{Date}
    lowest_52_week_price::Maybe{Float64}
    opening_price::Maybe{Float64}
    prev_closing_price::Maybe{Float64}
    signed_change_price::Maybe{Float64}
    signed_change_rate::Maybe{Float64}
    timestamp::Maybe{NanoDate}
    trade_date::Maybe{Date}
    trade_date_kst::Maybe{Date}
    trade_price::Maybe{Float64}
    trade_time::Maybe{Time}
    trade_time_kst::Maybe{Time}
    trade_timestamp::Maybe{NanoDate}
    trade_volume::Maybe{Float64}
end

"""
    by_pairs(client::UpbitClient, query::ByPairsQuery)
    by_pairs(client::UpbitClient = Upbit.UpbitClient(Upbit.public_config); kw...)

Returns a snapshot of the stock at the time of the request

[`GET v1/ticker`](https://docs.upbit.com/reference/ticker현재가-정보)

## Parameters:

| Parameter | Type                     | Required | Description |
|:----------|:-------------------------|:---------|:------------|
| markets   | String OR Vector{String} | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Upbit

result = Upbit.V1.Ticker.by_pairs(;
    markets = "KRW-BTC"
)
```
"""
function by_pairs(client::UpbitClient, query::ByPairsQuery)
    return APIsRequest{Vector{ByPairsData}}("GET", "v1/ticker", query)(client)
end

function by_pairs(client::UpbitClient = Upbit.UpbitClient(Upbit.public_config); kw...)
    return by_pairs(client, ByPairsQuery(; kw...))
end

end

