module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Poloniex
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx OrderBookLimit FIVE=5 TEN=10 TWENTY=20 FIFTY=50 HUNDRED=100 HUNDRED_FIFTY=150

Base.@kwdef struct OrderBookQuery <: PoloniexPublicQuery
    symbol::String
    limit::Maybe{OrderBookLimit.T} = nothing
    scale::Maybe{Int64} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{OrderBookQuery}, ::Val{:symbol}) = true

function Serde.SerQuery.ser_type(::Type{OrderBookQuery}, x::OrderBookLimit.T)::Int64
    return Int64(x)
end

struct OrderBookData <: PoloniexData
    asks::Vector{Float64}
    bids::Vector{Float64}
    scale::Float64
    time::NanoDate
    ts::NanoDate
end

"""
    order_book(client::PoloniexClient, query::OrderBookQuery)
    order_book(client::PoloniexClient = Poloniex.PoloniexClient(Poloniex.public_config); kw...)

Get the order book for a given symbol.

[`GET markets/{symbol}/orderBook`](https://api-docs.poloniex.com/spot/api/public/market-data#order-book)

## Parameters:

| Parameter | Type           | Required | Description                                                                                 |
|:----------|:---------------|:---------|:--------------------------------------------------------------------------------------------|
| symbol    | String         | false    |                                                                                             |
| limit     | OrderBookLimit | false    | FIVE (5), TEN (10), TWENTY (20), FIFTY (50), HUNDRED (100), HUNDRED_FIFTY (150)            |
| scale     | Int64          | false    |                                                                                             |

## Code samples:

```julia
using CryptoExchangeAPIs.Poloniex

result = Poloniex.Markets.order_book(;
    symbol = "BTC_USDT",
    limit = Poloniex.Markets.OrderBook.OrderBookLimit.FIVE,
)
```
"""
function order_book(client::PoloniexClient, query::OrderBookQuery; kw...)
    endpoint = isnothing(query.symbol) ? "markets/orderBook" : "markets/$(query.symbol)/orderBook"
    return APIsRequest{OrderBookData}("GET", endpoint, query)(client)
end

function order_book(client::PoloniexClient = Poloniex.PoloniexClient(Poloniex.public_config); kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end

