module Trades

export TradesQuery,
    TradesData,
    trades

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bitfinex
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TradesQuery <: BitfinexPublicQuery
    symbol::String
    _end::Maybe{DateTime} = nothing
    limit::Int64 = 125
    start::Maybe{DateTime} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{TradesQuery}, ::Val{:symbol}) = true

struct TradesData <: BitfinexData
    ID::Int64
    timestamp::NanoDate
    amount::Float64
    price::Float64
end

"""
    trades(client::BitfinexClient, query::TradesQuery)
    trades(client::BitfinexClient = Bitfinex.BitfinexClient(Bitfinex.public_config); kw...)

The trades endpoint allows the retrieval of past public trades and includes details such as price, size, and time.
Optional parameters can be used to limit the number of results; you can specify a start and end timestamp, a limit, and a sorting method.

[`GET v2/trades/{symbol}/hist`](https://docs.bitfinex.com/reference/rest-public-trades)

## Parameters:

| Parameter | Type     | Required | Description    |
|:----------|:---------|:---------|:---------------|
| symbol    | String   | true     |                |
| start     | DateTime | false    |                |
| _end      | DateTime | false    |                |
| limit     | Int64    | false    | Default: `125` |

## Code samples:

```julia
using Dates
using CryptoExchangeAPIs.Bitfinex

result = Bitfinex.V2.trades(;
    symbol = "tBTCUSD",
    start = DateTime("2024-03-17T12:00:00"),
)
```
"""
function trades(client::BitfinexClient, query::TradesQuery)
    return APIsRequest{Vector{TradesData}}("GET", "v2/trades/$(query.symbol)/hist", query)(client)
end

function trades(
    client::BitfinexClient = Bitfinex.BitfinexClient(Bitfinex.public_config);
    kw...,
)
    return trades(client, TradesQuery(; kw...))
end

end
