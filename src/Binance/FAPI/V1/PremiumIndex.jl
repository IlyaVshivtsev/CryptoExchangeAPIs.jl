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
end

struct PremiumIndexData <: BinanceData
    symbol::String
    markPrice::Maybe{Float64}
    indexPrice::Maybe{Float64}
    estimatedSettlePrice::Maybe{Float64}
    lastFundingRate::Maybe{Float64}
    interestRate::Maybe{Float64}
    nextFundingTime::NanoDate
    time::NanoDate
end

"""
    premium_index(client::BinanceClient, query::PremiumIndexQuery)
    premium_index(client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config); kw...)

Get mark price and funding rate.

[`GET fapi/v1/premiumIndex`](https://binance-docs.github.io/apidocs/futures/en/#mark-price)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.FAPI.V1.premium_index(;
    symbol = "BTCUSDT",
)
```
"""
function premium_index(client::BinanceClient, query::PremiumIndexQuery)
    return if isnothing(query.symbol)
        APIsRequest{Vector{PremiumIndexData}}("GET", "fapi/v1/premiumIndex", query)(client)
    else
        APIsRequest{PremiumIndexData}("GET", "fapi/v1/premiumIndex", query)(client)
    end
end

function premium_index(
    client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config);
    kw...,
)
    return premium_index(client, PremiumIndexQuery(; kw...))
end

end

