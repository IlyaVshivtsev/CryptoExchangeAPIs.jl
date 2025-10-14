module Currencies

export CurrenciesQuery,
    CurrenciesData,
    currencies

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Poloniex
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct CurrenciesQuery <: PoloniexPublicQuery
    #__ empty
end

struct Network <: PoloniexData
    id::Int64
    coin::String
    name::Maybe{String}
    currencyType::String
    blockchain::Maybe{String}
    withdrawalEnable::Bool
    depositEnable::Bool
    depositAddress::Maybe{String}
    withdrawMin::Float64
    decimals::Float64
    withdrawFee::Float64
    minConfirm::Int64
end

struct CurrenciesData <: PoloniexData
    id::Int64
    coin::String
    delisted::Bool
    tradeEnable::Bool
    name::String
    networkList::Vector{Network}
    supportCollateral::Maybe{Bool}
    supportBorrow::Maybe{Bool}
end

"""
    currencies(client::PoloniexClient, query::CurrenciesQuery)
    currencies(client::PoloniexClient = Poloniex.PoloniexClient(Poloniex.public_config); kw...)

Get all supported currencies.

[`GET v2/currencies`](https://api-docs.poloniex.com/spot/api/public/reference-data#currencyv2-information)

## Code samples:

```julia
using CryptoExchangeAPIs.Poloniex

result = Poloniex.V2.currencies()
```
"""
function currencies(client::PoloniexClient, query::CurrenciesQuery)
    return APIsRequest{Vector{CurrenciesData}}("GET", "v2/currencies", query)(client)
end

function currencies(client::PoloniexClient = Poloniex.PoloniexClient(Poloniex.public_config); kw...)
    return currencies(client, CurrenciesQuery(; kw...))
end

end

