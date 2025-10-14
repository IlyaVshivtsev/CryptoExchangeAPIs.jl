module Orderbook

export OrderbookQuery,
    OrderbookData,
    orderbook

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Upbit
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct OrderbookQuery <: UpbitPublicQuery
    markets::String
end

struct OrderbookUnit <: UpbitData
    ask_price::Float64
    ask_size::Float64
    bid_price::Float64
    bid_size::Float64
end

struct OrderbookData <: UpbitData
    market::String
    orderbook_units::Vector{OrderbookUnit}
    timestamp::NanoDate
    total_ask_size::Float64
    total_bid_size::Float64
end

"""
    orderbook(client::UpbitClient, query::OrderbookQuery)
    orderbook(client::UpbitClient = Upbit.UpbitClient(Upbit.public_config); kw...)

Order book data

[`GET v1/orderbook`](https://docs.upbit.com/reference/호가-정보-조회)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| markets   | String | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Upbit

result = Upbit.V1.orderbook(;
    markets = "KRW-BTC"
)
```
"""
function orderbook(client::UpbitClient, query::OrderbookQuery)
    return APIsRequest{Vector{OrderbookData}}("GET", "v1/orderbook", query)(client)
end

function orderbook(client::UpbitClient = Upbit.UpbitClient(Upbit.public_config); kw...)
    return orderbook(client, OrderbookQuery(; kw...))
end

end

