module Coins

export CoinsQuery,
    Chain,
    CoinsData,
    coins

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bitget
using CryptoExchangeAPIs.Bitget: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct CoinsQuery <: BitgetPublicQuery
    coin::Maybe{String} = nothing
end

@enumx NetworkStatus begin
    normal
    congested
end

struct Chain <: BitgetData
    chain::String
    needTag::Bool
    withdrawable::Bool
    rechargeable::Bool
    withdrawFee::Float64
    extraWithdrawFee::Float64
    depositConfirm::Int
    withdrawConfirm::Int
    minDepositAmount::Float64
    minWithdrawAmount::Float64
    browserUrl::Maybe{String}
    contractAddress::Maybe{String}
    withdrawStep::Int
    withdrawMinScale::Int
    congestion::NetworkStatus.T
end

struct CoinsData <: BitgetData
    coinId::Int
    coin::String
    transfer::Bool
    chains::Vector{Chain}
end

"""
    coins(client::BitgetClient, query::CoinsQuery)
    coins(client::BitgetClient = Bitget.BitgetClient(Bitget.public_config); kw...)

Get spot coin information, supporting both individual and full queries.

[`GET api/v2/spot/public/coins`](https://www.bitget.com/api-doc/spot/market/Get-Coin-List)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| coin      | String | false    | Coin name (e.g., "BTC"). If not provided, returns all coins. |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitget

# Get all coins
result = Bitget.API.V2.Spot.Public.coins()

# Get specific coin
result = Bitget.API.V2.Spot.Public.coins(; coin = "BTC")
```
"""
function coins(client::BitgetClient, query::CoinsQuery)
    return APIsRequest{Data{Vector{CoinsData}}}("GET", "api/v2/spot/public/coins", query)(client)
end

function coins(
    client::BitgetClient = Bitget.BitgetClient(Bitget.public_config);
    kw...,
)
    return coins(client, CoinsQuery(; kw...))
end

end
