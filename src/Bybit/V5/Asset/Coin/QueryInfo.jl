module QueryInfo

export QueryInfoQuery,
    QueryInfoData,
    query_info

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx ChainStatus begin
    SUSPEND = 0
    NORMAL = 1
end

Base.@kwdef mutable struct QueryInfoQuery <: BybitPrivateQuery
    coin::Maybe{String} = nothing

    api_key::Maybe{String} = nothing
    recv_window::Int64 = 5000
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct Chain <: BybitData
    chain::String
    chainType::String
    confirmation::Int64
    withdrawFee::Float64
    depositMin::Float64
    withdrawMin::Float64
    minAccuracy::Int64
    chainDeposit::ChainStatus.T
    chainWithdraw::ChainStatus.T
    withdrawPercentageFee::Float64
    contractAddress::String
    safeConfirmNumber::Int64
end

struct CoinInfo <: BybitData
    name::String
    coin::String
    remainAmount::Float64
    chains::Vector{Chain}
end

struct QueryInfoData <: BybitData
    rows::Vector{CoinInfo}
end

function Serde.deser(::Type{Chain}, ::Type{ChainStatus.T}, x::String)
    return ChainStatus.T(parse(Int64, x))
end

function Serde.deser(::Type{Chain}, ::Type{ChainStatus.T}, x::Int64)
    return ChainStatus.T(x)
end

"""
    query_info(client::BybitClient, query::QueryInfoQuery)
    query_info(client::BybitClient; kw...)

Query coin information, including chain information, withdraw and deposit status.

[`GET /v5/asset/coin/query-info`](https://bybit-exchange.github.io/docs/v5/asset/coin-info)

## Parameters:

| Parameter | Type   | Required | Description          |
|:----------|:-------|:---------|:---------------------|
| coin      | String | false    | Coin, uppercase only |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

client = BybitClient(;
    base_url = "https://api.bybit.com",
    public_key = ENV["BYBIT_PUBLIC_KEY"],
    secret_key = ENV["BYBIT_SECRET_KEY"],
)

result = Bybit.V5.Asset.Coin.query_info(client; coin = "MNT")
```
"""
function query_info(client::BybitClient, query::QueryInfoQuery)
    return APIsRequest{Data{QueryInfoData}}("GET", "/v5/asset/coin/query-info", query)(client)
end

function query_info(client::BybitClient; kw...)
    return query_info(client, QueryInfoQuery(; kw...))
end

end

