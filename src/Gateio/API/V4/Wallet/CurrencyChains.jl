module CurrencyChains

export CurrencyChainsQuery,
    CurrencyChainsData,
    currency_chains

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct CurrencyChainsQuery <: GateioPublicQuery
    currency::String
end

struct CurrencyChainsData <: GateioData
    chain::String
    name_cn::String
    name_en::String
    is_disabled::Bool
    is_deposit_disabled::Bool
    is_withdraw_disabled::Bool
    contract_address::Maybe{String}
    decimal::Maybe{Int}
    is_tag::Int
end

Serde.isempty(::Type{CurrencyChainsData}, x::AbstractString) = isempty(x)

"""
    currency_chains(client::GateioClient, query::CurrencyChainsQuery)
    currency_chains(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

Query chains supported for specified currency.

[`GET api/v4/wallet/currency_chains`](https://www.gate.com/docs/developers/apiv4/en/#query-chains-supported-for-specified-currency)

## Parameters:

| Parameter | Type   | Required | Description          |
|:----------|:-------|:---------|:---------------------|
| currency  | String | true     | Currency, uppercase  |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Wallet.currency_chains()
```
"""
function currency_chains(client::GateioClient, query::CurrencyChainsQuery)
    return APIsRequest{Vector{CurrencyChainsData}}("GET", "api/v4/wallet/currency_chains", query)(client)
end

function currency_chains(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return currency_chains(client, CurrencyChainsQuery(; kw...))
end

end
