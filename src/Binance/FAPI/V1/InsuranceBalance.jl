module InsuranceBalance

export InsuranceBalanceQuery,
    InsuranceBalanceData,
    insurance_balance

using Serde
using Dates, NanoDates

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct InsuranceBalanceQuery <: BinancePublicQuery
    symbol::Maybe{String} = nothing
end

struct InsuranceBalanceAsset <: BinanceData
    asset::String
    marginBalance::Float64
    updateTime::NanoDate
end

struct InsuranceBalanceData <: BinanceData
    symbols::Vector{String}
    assets::Vector{InsuranceBalanceAsset}
end

"""
    insurance_balance(client::BinanceClient, query::InsuranceBalanceQuery)
    insurance_balance(client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config); kw...)

Query Insurance Fund Balance Snapshot.

[`GET fapi/v1/insuranceBalance`](https://developers.binance.com/docs/derivatives/usds-margined-futures/market-data/rest-api/Insurance-Fund-Balance#http-request)

## Parameters:

| Parameter  | Type            | Required | Description |
|:-----------|:----------------|:---------|:------------|
| symbol     | String          | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.FAPI.V1.insurance_balance()

result = Binance.FAPI.V1.insurance_balance(; symbol = "BTCUSDT")
```
"""
function insurance_balance(client::BinanceClient, query::InsuranceBalanceQuery)
    datatype = isnothing(query.symbol) ? Vector{InsuranceBalanceData} : InsuranceBalanceData
    return APIsRequest{datatype}("GET", "fapi/v1/insuranceBalance", query)(client)
end

function insurance_balance(
    client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config);
    kw...,
)
    return insurance_balance(client, InsuranceBalanceQuery(; kw...))
end

end
