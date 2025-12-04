module GetAllCurrencies

export GetAllCurrenciesQuery,
    GetAllCurrenciesData,
    ChainData,
    get_all_currencies

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

struct GetAllCurrenciesQuery <: KucoinPublicQuery end

struct ChainData <: KucoinData
    chainName::String
    withdrawalMinSize::Float64
    depositMinSize::Maybe{Float64}
    withdrawFeeRate::Maybe{Float64}
    withdrawalMinFee::Float64
    isWithdrawEnabled::Bool
    isDepositEnabled::Bool
    confirms::Maybe{Int}
    preConfirms::Int
    contractAddress::Maybe{String}
    withdrawPrecision::Int
    maxWithdraw::Maybe{Float64}
    maxDeposit::Maybe{Float64}
    needTag::Bool
    chainId::String
    depositFeeRate::Maybe{Float64}
    withdrawMaxFee::Maybe{Float64}
    depositTierFee::Maybe{Float64}
end

struct GetAllCurrenciesData <: KucoinData
    currency::String
    name::String
    fullName::String
    precision::Int
    confirms::Maybe{Int}
    contractAddress::Maybe{String}
    isMarginEnabled::Bool
    isDebitEnabled::Bool
    chains::Maybe{Vector{ChainData}}
end

"""
    get_all_currencies(client::KucoinClient, query::GetAllCurrenciesQuery)
    get_all_currencies(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config))

Request a currency list via this endpoint. Not all currencies currently can be used for trading.

[`GET api/v3/currencies`](https://www.kucoin.com/docs-new/rest/spot-trading/market-data/get-all-currencies)

## Parameters:

None

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin

result = Kucoin.API.V3.Currencies.get_all_currencies()
```
"""
function get_all_currencies(client::KucoinClient, query::GetAllCurrenciesQuery)
    return APIsRequest{Data{Vector{GetAllCurrenciesData}}}("GET", "api/v3/currencies", query)(client)
end

function get_all_currencies(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config))
    return get_all_currencies(client, GetAllCurrenciesQuery())
end

end

