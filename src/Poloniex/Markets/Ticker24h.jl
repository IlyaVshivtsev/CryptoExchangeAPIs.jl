module Ticker24h

export Ticker24hQuery,
    Ticker24hData,
    ticker24h

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Poloniex
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct Ticker24hQuery <: PoloniexPublicQuery
    symbol::Maybe{String} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{Ticker24hQuery}, ::Val{:symbol}) = true

struct Ticker24hData <: PoloniexData
    symbol::String
    displayName::Maybe{String}
    amount::Maybe{Float64}
    ask::Maybe{Float64}
    askQuantity::Maybe{Float64}
    bid::Maybe{Float64}
    bidQuantity::Maybe{Float64}
    close::Maybe{Float64}
    closeTime::Maybe{NanoDate}
    dailyChange::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    markPrice::Maybe{Float64}
    open::Maybe{Float64}
    quantity::Maybe{Float64}
    startTime::Maybe{NanoDate}
    tradeCount::Maybe{Int64}
    ts::NanoDate
end

function Serde.isempty(::Type{Ticker24hData}, x)::Bool
    return x === ""
end

"""
    ticker24h(client::PoloniexClient, query::Ticker24hQuery)
    ticker24h(client::PoloniexClient = Poloniex.PoloniexClient(Poloniex.public_config); kw...)

Retrieve ticker in last 24 hours for all symbols.

[`GET markets/{symbol}/ticker24h`](https://api-docs.poloniex.com/spot/api/public/market-data#ticker)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Poloniex

result = Poloniex.Markets.ticker24h(;
    symbol = "BTC_USDT",
)
```
"""
function ticker24h(client::PoloniexClient, query::Ticker24hQuery; kw...)
    return if isnothing(query.symbol)
        APIsRequest{Vector{Ticker24hData}}("GET", "markets/ticker24h", query)(client)
    else
        APIsRequest{Ticker24hData}("GET", "markets/$(query.symbol)/ticker24h", query)(client)
    end
end

function ticker24h(client::PoloniexClient = Poloniex.PoloniexClient(Poloniex.public_config); kw...)
    return ticker24h(client, Ticker24hQuery(; kw...))
end

end

