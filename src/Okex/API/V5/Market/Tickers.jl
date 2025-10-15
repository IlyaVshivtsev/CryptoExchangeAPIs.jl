module Tickers

export TickersQuery,
    TickersData,
    tickers

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Okex
using CryptoExchangeAPIs.Okex: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx InstType SPOT SWAP FUTURES OPTION

Base.@kwdef struct TickersQuery <: OkexPublicQuery
    instFamily::Maybe{String} = nothing
    instType::InstType.T
    uly::Maybe{String} = nothing
end

struct TickersData <: OkexData
    instId::Maybe{String}
    askPx::Maybe{Float64}
    askSz::Maybe{Float64}
    bidPx::Maybe{Float64}
    bidSz::Maybe{Float64}
    high24h::Maybe{Float64}
    instType::Maybe{String}
    last::Maybe{Float64}
    lastSz::Maybe{Float64}
    low24h::Maybe{Float64}
    open24h::Maybe{Float64}
    sodUtc0::Maybe{Float64}
    sodUtc8::Maybe{Float64}
    ts::Maybe{NanoDate}
    vol24h::Maybe{Float64}
    volCcy24h::Maybe{Float64}
end

function Serde.isempty(::Type{TickersData}, x)
    return x === ""
end

"""
    tickers(client::OkexClient, query::TickersQuery)
    tickers(client::OkexClient = Okex.OkexClient(Okex.public_config); kw...)

Retrieve the latest price snapshot, best bid/ask price, and trading volume in the last 24 hours.

[`GET api/v5/market/tickers`](https://www.okx.com/docs-v5/en/#rest-api-market-data-get-tickers)

## Parameters:

| Parameter  | Type     | Required | Description                               |
|:-----------|:---------|:---------|:------------------------------------------|
| instFamily | String   | false    |                                           |
| instType   | InstType | false    | SPOT, SWAP, FUTURES, OPTION               |
| uly        | String   | false    |                                           |

## Code samples:

```julia
using CryptoExchangeAPIs.Okex

result = Okex.API.V5.Market.tickers(;
    instType = Okex.API.V5.Market.Tickers.InstType.SPOT,
)
```
"""
function tickers(client::OkexClient, query::TickersQuery)
    return APIsRequest{Data{TickersData}}("GET", "api/v5/market/tickers", query)(client)
end

function tickers(client::OkexClient = Okex.OkexClient(Okex.public_config); kw...)
    return tickers(client, TickersQuery(; kw...))
end

end

