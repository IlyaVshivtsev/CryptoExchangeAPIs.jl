module PremiumIndex

export PremiumIndexQuery,
    PremiumIndexData,
    premium_index

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct PremiumIndexQuery <: BinancePublicQuery
    symbol::Maybe{String} = nothing
    pair::Maybe{String} = nothing
end

struct PremiumIndexData <: BinanceData
    symbol::String
    pair::String
    markPrice::Maybe{Float64}
    indexPrice::Maybe{Float64}
    estimatedSettlePrice::Maybe{Float64}
    lastFundingRate::Maybe{String}
    interestRate::Maybe{String}
    nextFundingTime::NanoDate
    time::NanoDate
end

"""
    premium_index(client::BinanceClient, query::PremiumIndexQuery)
    premium_index(client::BinanceClient = Binance.BinanceClient(Binance.public_dapi_config); kw...)

Get index price and mark price.

[`GET dapi/v1/premiumIndex`](https://binance-docs.github.io/apidocs/delivery/en/#index-price-and-mark-price)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | false    |             |
| pair      | String | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.DAPI.V1.premium_index(;
    pair = "BTCUSD",
)
```
"""
function premium_index(client::BinanceClient, query::PremiumIndexQuery)
    return APIsRequest{Vector{PremiumIndexData}}("GET", "dapi/v1/premiumIndex", query)(client)
end

function premium_index(
    client::BinanceClient = Binance.BinanceClient(Binance.public_dapi_config);
    kw...,
)
    return premium_index(client, PremiumIndexQuery(; kw...))
end

end

