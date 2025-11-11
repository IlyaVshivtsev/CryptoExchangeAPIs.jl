module Getall

export GetallQuery,
    GetallData,
    getall

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct GetallQuery <: BinancePrivateQuery
    recvWindow::Maybe{Int64} = nothing
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct Networklist <: BinanceData
    addressRegex::String
    addressRule::Maybe{String}
    busy::Bool
    coin::String
    country::Maybe{String}
    depositDesc::String
    depositDust::Maybe{Float64}
    depositEnable::Bool
    estimatedArrivalTime::NanoDate
    isDefault::Bool
    memoRegex::String
    minConfirm::Int64
    name::String
    network::String
    resetAddressStatus::Bool
    sameAddress::Bool
    specialTips::Maybe{String}
    specialWithdrawTips::Maybe{String}
    unLockConfirm::Int64
    withdrawDesc::String
    withdrawEnable::Bool
    withdrawFee::Float64
    withdrawIntegerMultiple::Float64
    withdrawMax::Float64
    withdrawMin::Float64
end

struct GetallData <: BinanceData
    coin::String
    depositAllEnable::Bool
    free::Float64
    freeze::Float64
    ipoable::Float64
    ipoing::Float64
    isLegalMoney::Bool
    locked::Float64
    name::String
    networkList::Vector{Networklist}
    storage::Float64
    trading::Bool
    withdrawAllEnable::Bool
    withdrawing::Float64
end

"""
    getall(client::BinanceClient, query::GetallQuery)
    getall(client::BinanceClient; kw...)

Get information of coins (available for deposit and withdraw) for user.

[`GET sapi/v1/capital/config/getall`](https://binance-docs.github.io/apidocs/spot/en/#all-coins-39-information-user_data)

## Parameters:

| Parameter  | Type      | Required | Description |
|:-----------|:----------|:---------|:------------|
| recvWindow | Int64     | false    |             |
| signature  | String    | false    |             |
| timestamp  | DateTime  | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

binance_client = BinanceClient(;
    base_url = "https://api.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

result = Binance.SAPI.V1.Capital.Config.getall(binance_client)
```
"""
function getall(client::BinanceClient, query::GetallQuery)
    return APIsRequest{Vector{GetallData}}("GET", "sapi/v1/capital/config/getall", query)(client)
end

function getall(client::BinanceClient; kw...)
    return getall(client, GetallQuery(; kw...))
end

end
