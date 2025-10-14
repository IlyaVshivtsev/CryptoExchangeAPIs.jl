module All

export AllQuery,
    AllData

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Upbit
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct AllQuery <: UpbitPublicQuery
    quoteCurrencies::String
end

struct AllData <: UpbitData
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
    all(client::UpbitClient, query::AllQuery)
    all(client::UpbitClient = Upbit.UpbitClient(Upbit.public_config); kw...)

Returns a snapshot of all tickers at the time of the request

[`GET v1/ticker/all`](https://docs.upbit.com/reference/tickers_by_quote)

## Parameters:

| Parameter       | Type   | Required | Description |
|:----------------|:-------|:---------|:------------|
| quoteCurrencies | String | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Upbit

result = Upbit.V1.Ticker.all(;
    quoteCurrencies = "BTC"
)
```
"""
function all(client::UpbitClient, query::AllQuery)
    return APIsRequest{Vector{AllData}}("GET", "v1/ticker/all", query)(client)
end

function all(client::UpbitClient = Upbit.UpbitClient(Upbit.public_config); kw...)
    return all(client, AllQuery(; kw...))
end

end

