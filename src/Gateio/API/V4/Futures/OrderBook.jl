module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Settle btc usdt usd

Base.@kwdef struct OrderBookQuery <: GateioPublicQuery
    contract::String
    settle::Settle.T
    interval::Maybe{String} = nothing
    limit::Maybe{Int64} = nothing
    with_id::Maybe{Bool} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{OrderBookQuery}, ::Val{:settle}) = true

struct Order <: GateioData
    p::String
    s::Int64
end

struct OrderBookData <: GateioData
    id::Maybe{Int64}
    current::NanoDate
    update::NanoDate
    asks::Vector{Order}
    bids::Vector{Order}
end

function Serde.deser(::Type{OrderBookData}, ::Type{<:Maybe{NanoDate}}, x::Float64)::NanoDate
  return unixmillis2nanodate(x * 1000)
end

"""
    order_book(client::GateioClient, query::OrderBookQuery)
    order_book(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

Futures order book.

[`GET api/v4/futures/{settle}/order_book`](https://www.gate.io/docs/developers/apiv4/en/#futures-order-book)

## Parameters:

| Parameter | Type     | Required | Description  |
|:----------|:---------|:---------|:-------------|
| contract  | String   | true     |              |
| settle    | Settle   | true     | btc usdt usd |
| interval  | String   | false    |              |
| limit     | Int64    | false    |              |
| with_id   | Bool     | false    |              |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Futures.order_book(; 
    settle = Gateio.API.V4.Futures.OrderBook.Settle.usdt,
    contract = "BTC_USDT",
)
```
"""
function order_book(client::GateioClient, query::OrderBookQuery)
    return APIsRequest{OrderBookData}("GET", "api/v4/futures/$(query.settle)/order_book", query)(client)
end

function order_book(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return order_book(client, OrderBookQuery(; kw...))
end

end
