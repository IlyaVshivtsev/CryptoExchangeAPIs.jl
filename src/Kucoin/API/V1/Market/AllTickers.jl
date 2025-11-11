module AllTickers

export AllTickersQuery,
    AllTickersData,
    all_tickers

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct AllTickersQuery <: KucoinPublicQuery
    #__ empty
end

struct TickerData <: KucoinData
    symbol::String
    averagePrice::Maybe{Float64}
    buy::Maybe{Float64}
    changePrice::Maybe{Float64}
    changeRate::Maybe{Float64}
    high::Maybe{Float64}
    last::Maybe{Float64}
    low::Maybe{Float64}
    makerCoefficient::Maybe{Float64}
    makerFeeRate::Maybe{Float64}
    sell::Maybe{Float64}
    takerCoefficient::Maybe{Float64}
    takerFeeRate::Maybe{Float64}
    time::Maybe{NanoDate}
    vol::Maybe{Float64}
    volValue::Maybe{Float64}
end

struct AllTickersData <: KucoinData
    time::Maybe{NanoDate}
    ticker::Vector{TickerData}
end

"""
    all_tickers(client::KucoinClient, query::AllTickersQuery)
    all_tickers(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config); kw...)

Request market tickers for all the trading pairs in the market (including 24h volume).

[`GET api/v1/market/allTickers`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-all-tickers)

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin

result = Kucoin.API.V1.Market.all_tickers()
```
"""
function all_tickers(client::KucoinClient, query::AllTickersQuery)
    return APIsRequest{Data{AllTickersData}}("GET", "api/v1/market/allTickers", query)(client)
end

function all_tickers(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config); kw...)
    return all_tickers(client, AllTickersQuery(; kw...))
end

end

