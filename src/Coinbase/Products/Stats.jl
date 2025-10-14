module Stats

export StatsQuery,
    StatsData,
    stats

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Coinbase
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct StatsQuery <: CoinbasePublicQuery
    product_id::String
end

Serde.SerQuery.ser_ignore_field(::Type{StatsQuery}, ::Val{:product_id}) = true

struct StatsData <: CoinbaseData
    open::Float64
    high::Float64
    low::Float64
    last::Float64
    volume::Float64
    volume_30day::Maybe{Float64}
    rfq_volume_24hour::Maybe{Float64}
    rfq_volume_30day::Maybe{Float64}
    conversions_volume_24hour::Maybe{Float64}
    conversions_volume_30day::Maybe{Float64}
end

"""
    stats(client::CoinbaseClient, query::StatsQuery)
    stats(client::CoinbaseClient = Coinbase.CoinbaseClient(Coinbase.public_config); kw...)

Get 24 hour stats for the product. Volume is in base currency units. Open, high, low are in quote currency units.

[`GET products/{product_id}/stats`](https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getproductstats)

## Parameters:

| Parameter  | Type     | Required | Description |
|:-----------|:---------|:---------|:------------|
| product_id | String   | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Coinbase

result = Coinbase.Products.stats(;
    product_id = "BTC-USD",
)
```
"""
function stats(client::CoinbaseClient, query::StatsQuery)
    return APIsRequest{StatsData}("GET", "products/$(query.product_id)/stats", query)(client)
end

function stats(
    client::CoinbaseClient = Coinbase.CoinbaseClient(Coinbase.public_config);
    kw...
)
    return stats(client, StatsQuery(; kw...))
end

end

