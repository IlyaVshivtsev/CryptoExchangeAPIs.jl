module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bithumb
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: BithumbPublicQuery
    markets::Union{String,Vector{String}} # Comma-separated market codes (ex. KRW-BTC,BTC-ETH)
end

function Serde.SerQuery.ser_type(::Type{<:TickerQuery}, x::Vector{String})::String
    return join(x, ",")
end

struct TickerData <: BithumbData
    market::String
    trade_date::Maybe{Date}
    trade_time::Maybe{String}
    trade_date_kst::Maybe{String}
    trade_time_kst::Maybe{String}
    trade_timestamp::Maybe{NanoDate}
    opening_price::Maybe{Float64}
    high_price::Maybe{Float64}
    low_price::Maybe{Float64}
    trade_price::Maybe{Float64}
    prev_closing_price::Maybe{Float64}
    change::Maybe{String}  # EVEN, RISE, FALL
    change_price::Maybe{Float64}
    change_rate::Maybe{Float64}
    signed_change_price::Maybe{Float64}
    signed_change_rate::Maybe{Float64}
    trade_volume::Maybe{Float64}
    acc_trade_price::Maybe{Float64}
    acc_trade_price_24h::Maybe{Float64}
    acc_trade_volume::Maybe{Float64}
    acc_trade_volume_24h::Maybe{Float64}
    highest_52_week_price::Maybe{Float64}
    highest_52_week_date::Maybe{String}  # yyyy-MM-dd format
    lowest_52_week_price::Maybe{Float64}
    lowest_52_week_date::Maybe{String}  # yyyy-MM-dd format
    timestamp::Maybe{NanoDate}
end

function Serde.deser(::Type{<:TickerData}, ::Type{<:Date}, x::AbstractString)::Date
    return Date(x, dateformat"yyyymmdd")
end

"""
    ticker(client::BithumbClient, query::TickerQuery)
    ticker(client::BithumbClient = Bithumb.BithumbClient(Bithumb.public_config); kw...)

Provides snapshot information of symbols at the time of request.

[`GET /v1/ticker`](https://api.bithumb.com/v1/ticker)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| markets   | String | true     | Comma-separated market codes (ex. KRW-BTC,BTC-ETH) |

## Code samples:

```julia
using CryptoExchangeAPIs.Bithumb

result = Bithumb.V1.Ticker.ticker(;
    markets = "KRW-BTC,KRW-ETH",
)
```
"""
function ticker(client::BithumbClient, query::TickerQuery)
    return APIsRequest{Vector{TickerData}}("GET", "v1/ticker", query)(client)
end

function ticker(
    client::BithumbClient = Bithumb.BithumbClient(Bithumb.public_config);
    kw...,
)
    return ticker(client, TickerQuery(; kw...))
end

end
