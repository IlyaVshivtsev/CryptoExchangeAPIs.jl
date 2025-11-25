module Insurance

export InsuranceQuery,
    InsuranceData,
    insurance

using Serde
using Dates, NanoDates

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct InsuranceQuery <: BybitPublicQuery
    coin::Maybe{String} = nothing
end

struct InsuranceEntry <: BybitData
    coin::String
    symbols::Vector{String}
    balance::Float64
    value::Float64
end

Serde.deser(::Type{<:InsuranceEntry}, ::Type{Vector{String}}, x::String) = split(x, ",")

struct InsuranceData <: BybitData
    updatedTime::NanoDate
    list::Vector{InsuranceEntry}
end

"""
    insurance(client::BybitClient, query::InsuranceQuery)
    insurance(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)

Query for Bybit insurance pool data (BTC/USDT/USDC etc).

[`GET /v5/market/insurance`](https://bybit-exchange.github.io/docs/v5/market/insurance)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| coin      | String | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

result = Bybit.V5.Market.insurance()

result = Bybit.V5.Market.insurance(; coin = "BTC")
```
"""
function insurance(client::BybitClient, query::InsuranceQuery)
    return APIsRequest{Data{InsuranceData}}("GET", "v5/market/insurance", query)(client)
end

function insurance(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)
    return insurance(client, InsuranceQuery(; kw...))
end

end
