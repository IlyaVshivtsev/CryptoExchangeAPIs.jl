module Tickers

export TickersQuery,
    TickersData,
    tickers

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickersQuery <: HuobiPublicQuery
    #__ empty
end

struct TickersData <: HuobiData
    symbol::String
    amount::Maybe{Float64}
    ask::Maybe{Float64}
    askSize::Maybe{Float64}
    bid::Maybe{Float64}
    bidSize::Maybe{Float64}
    close::Maybe{Float64}
    count::Maybe{Int64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    open::Maybe{Float64}
    vol::Maybe{Float64}
end

"""
    tickers(client::HuobiClient, query::TickersQuery)
    tickers(client::HuobiClient = Huobi.HuobiClient(Huobi.public_config); kw...)

This endpoint retrieves the latest tickers for all supported pairs.

[`GET market/tickers`](https://huobiapi.github.io/docs/spot/v1/en/#get-latest-tickers-for-all-pairs)

## Code samples:

```julia
using CryptoExchangeAPIs.Huobi

result = Huobi.Market.tickers()
```
"""
function tickers(client::HuobiClient, query::TickersQuery)
    return APIsRequest{Data{Vector{TickersData}}}("GET", "market/tickers", query)(client)
end

function tickers(client::HuobiClient = Huobi.HuobiClient(Huobi.public_config); kw...)
    return tickers(client, TickersQuery(; kw...))
end

end

