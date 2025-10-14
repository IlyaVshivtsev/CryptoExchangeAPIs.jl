module Orderbook

export OrderbookQuery,
    OrderbookData,
    orderbook

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Category OPTION SPOT LINEAR INVERSE

Base.@kwdef struct OrderbookQuery <: BybitPublicQuery
    category::Category.T
    symbol::String
    limit::Maybe{Int64} = nothing
end

function Serde.ser_type(::Type{<:OrderbookQuery}, x::Category.T)::String
    x == Category.OPTION  && return "option"
    x == Category.SPOT    && return "spot"
    x == Category.LINEAR  && return "linear"
    x == Category.INVERSE && return "inverse"
end

struct Level <: BybitData
    price::Float64
    size::Float64
end

struct OrderbookData <: BybitData
    s::String
    a::Vector{Level}
    b::Vector{Level}
    ts::NanoDate
end

"""
    orderbook(client::BybitClient, query::OrderbookQuery)
    orderbook(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)

[`GET /v5/market/orderbook`](https://bybit-exchange.github.io/docs/v5/market/orderbook)

## Parameters:

| Parameter | Type     | Required | Description                |
|:----------|:---------|:---------|:---------------------------|
| category  | Category | true     | SPOT LINEAR INVERSE OPTION |
| symbol    | String   | true     |                            |
| limit     | Int64    | false    |                            |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

result = Bybit.V5.Market.orderbook(;
    category = Bybit.V5.Market.Orderbook.Category.SPOT,
    symbol = "ADAUSDT",
)
```
"""
function orderbook(client::BybitClient, query::OrderbookQuery)
    return APIsRequest{Data{OrderbookData}}("GET", "/v5/market/orderbook", query)(client)
end

function orderbook(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)
    return orderbook(client, OrderbookQuery(; kw...))
end

end

