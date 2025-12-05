module Currencies

export CurrenciesQuery,
    CurrenciesData,
    currencies

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Okx
using CryptoExchangeAPIs.Okx: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct CurrenciesQuery <: OkxPrivateQuery
    ccy::Maybe{String} = nothing

    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct CurrenciesData <: OkxData
    canDep::Bool
    canInternal::Bool
    canWd::Bool
    ccy::String
    chain::Maybe{String}
    depQuotaFixed::Maybe{Float64}
    depQuoteDailyLayer2::Maybe{Int64}
    logoLink::Maybe{String}
    mainNet::Bool
    maxFee::Float64
    maxWd::Float64
    minDep::Float64
    minDepArrivalConfirm::Maybe{Int64}
    minFee::Float64
    minWd::Float64
    minWdUnlockConfirm::Maybe{Int64}
    name::Maybe{String}
    needTag::Bool
    usedDepQuotaFixed::Maybe{Float64}
    usedWdQuota::Maybe{Int64}
    wdQuota::Maybe{Int64}
    wdTickSz::Maybe{Int64}
end

function Serde.isempty(::Type{<:CurrenciesData}, x)::Bool
    return isempty(x)
end

"""
    currencies(client::OkxClient, query::CurrenciesQuery)
    currencies(client::OkxClient; kw...)

Get information of coins (available for deposit and withdraw) for user.

[`GET api/v5/asset/currencies`](https://www.okx.com/docs-v5/en/#rest-api-funding-get-currencies)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| ccy       | String | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Okx

okx_client = OkxClient(;
    base_url = "https://www.okx.com",
    public_key = ENV["OKX_PUBLIC_KEY"],
    secret_key = ENV["OKX_SECRET_KEY"],
    passphrase = ENV["OKX_PASSPHRASE"],
)

result = Okx.API.V5.Asset.currencies(
    okx_client;
    ccy = "BTC"
)
```
"""
function currencies(client::OkxClient, query::CurrenciesQuery)
    return APIsRequest{Data{CurrenciesData}}("GET", "api/v5/asset/currencies", query)(client)
end

function currencies(client::OkxClient; kw...)
    return currencies(client, CurrenciesQuery(; kw...))
end

end

