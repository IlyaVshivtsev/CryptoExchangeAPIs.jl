module Tickers

export TickersQuery,
    TickersData,
    tickers

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bitfinex
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickersQuery <: BitfinexPublicQuery
    symbols::String = "ALL"
end

struct TickersData <: BitfinexData
    symbol::String
    bid::Maybe{Float64}
    bidSize::Maybe{Float64}
    ask::Maybe{Float64}
    askSize::Maybe{Float64}
    dailyChange::Maybe{Float64}
    dailyChangeRelative::Maybe{Float64}
    lastPrice::Maybe{Float64}
    volume::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
end

"""
    tickers(client::BitfinexClient, query::TickersQuery)
    tickers(client::BitfinexClient = Bitfinex.BitfinexClient(Bitfinex.public_config); kw...)

The tickers endpoint provides a high level overview of the state of the market.
It shows the current best bid and ask, the last traded price, as well as information on the daily volume and price movement over the last day.
The endpoint can retrieve multiple tickers with a single query.

[`GET v2/tickers`](https://docs.bitfinex.com/reference/rest-public-tickers)

## Parameters:

| Parameter | Type   | Required | Description      |
|:----------|:-------|:---------|:-----------------|
| symbols   | String | false    | Default: `"ALL"` |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitfinex

result = Bitfinex.V2.tickers(;
    symbols = "tBTCUSD"
)
```
"""
function tickers(client::BitfinexClient, query::TickersQuery)
    return APIsRequest{Vector{TickersData}}("GET", "v2/tickers", query)(client)
end

function tickers(
    client::BitfinexClient = Bitfinex.BitfinexClient(Bitfinex.public_config);
    kw...,
)
    return tickers(client, TickersQuery(; kw...))
end

end
