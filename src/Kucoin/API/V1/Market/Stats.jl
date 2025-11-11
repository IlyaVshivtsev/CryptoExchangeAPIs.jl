module Stats

export StatsQuery,
    StatsData,
    stats

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct StatsQuery <: KucoinPublicQuery
    symbol::String
end

struct StatsData <: KucoinData
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

"""
    stats(client::KucoinClient, query::StatsQuery)
    stats(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config); kw...)

Request via this endpoint to get the statistics of the specified ticker in the last 24 hours.

[`GET api/v1/market/stats`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-24hr-stats)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin

result = Kucoin.API.V1.Market.stats(;
    symbol = "BTC-USDT"
)
```
"""
function stats(client::KucoinClient, query::StatsQuery)
    return APIsRequest{Data{StatsData}}("GET", "api/v1/market/stats", query)(client)
end

function stats(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config); kw...)
    return stats(client, StatsQuery(; kw...))
end

end

