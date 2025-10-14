module Currencies

export CurrenciesQuery,
    CurrenciesData,
    currencies

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct CurrenciesQuery <: HuobiPrivateQuery
    AccessKeyId::Maybe{String} = nothing
    Signature::Maybe{String} = nothing
    SignatureMethod::Maybe{String} = nothing
    SignatureVersion::Maybe{String} = nothing
    Timestamp::Maybe{DateTime} = nothing

    authorizedUser::Maybe{Bool} = nothing
    currency::Maybe{String} = nothing
end

@enumx WithdrawDepositStatus allowed prohibited

@enumx WithdrawFeeType fixed circulated ratio

struct Chain <: HuobiData
    baseChain::Maybe{String}
    baseChainProtocol::Maybe{String}
    chain::Maybe{String}
    depositStatus::Maybe{WithdrawDepositStatus.T}
    displayName::Maybe{String}
    isDynamic::Maybe{Bool}
    maxTransactFeeWithdraw::Maybe{Float64}
    maxWithdrawAmt::Maybe{Float64}
    minDepositAmt::Maybe{Float64}
    minTransactFeeWithdraw::Maybe{Float64}
    minWithdrawAmt::Maybe{Float64}
    numOfConfirmations::Maybe{Int64}
    numOfFastConfirmations::Maybe{Int64}
    transactFeeRateWithdraw::Maybe{Float64}
    transactFeeWithdraw::Maybe{Float64}
    withdrawFeeType::Maybe{WithdrawFeeType.T}
    withdrawPrecision::Maybe{Int64}
    withdrawQuotaPerDay::Maybe{Float64}
    withdrawQuotaPerYear::Maybe{Float64}
    withdrawQuotaTotal::Maybe{Float64}
    withdrawStatus::Maybe{WithdrawDepositStatus.T}
end

struct CurrenciesData <: HuobiData
    chains::Vector{Chain}
    currency::String
    instStatus::String
end

"""
    currencies(client::HuobiClient, query::CurrenciesQuery)
    currencies(client::HuobiClient; kw...)

API user could query static reference information for each currency, as well as its corresponding chain(s).

[`GET v2/reference/currencies`](https://www.htx.com/en-in/opend/newApiPages/?id=7ec516fc-7773-11ed-9966-0242ac110003)

## Parameters:

| Parameter        | Type     | Required | Description |
|:-----------------|:---------|:---------|:------------|
| authorizedUser   | Bool     | false    |             |
| currency         | String   | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Huobi

client = HuobiClient(;
    base_url = "https://api.huobi.pro",
    public_key = ENV["HUOBI_PUBLIC_KEY"],
    secret_key = ENV["HUOBI_SECRET_KEY"],
)

result = Huobi.V2.Reference.currencies(
    client;
    currency = "usdt",
    authorizedUser = true,
)
```
"""
function currencies(client::HuobiClient, query::CurrenciesQuery)
    return APIsRequest{Data{Vector{CurrenciesData}}}("GET", "v2/reference/currencies", query)(client)
end

function currencies(client::HuobiClient; kw...)
    return currencies(client, CurrenciesQuery(; kw...))
end

end

