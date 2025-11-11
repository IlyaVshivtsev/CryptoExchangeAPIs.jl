module Depth

export DepthQuery,
    DepthData,
    depth

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct DepthQuery <: BinancePublicQuery
    symbol::String
    limit::Maybe{Int64} = nothing
end

struct Level <: BinanceData
    price::Float64
    size::Float64
end

struct DepthData <: BinanceData
    E::NanoDate             # Message output time
    T::NanoDate             # Transaction time
    asks::Vector{Level}
    bids::Vector{Level}
    lastUpdateId::Int64
end

"""
    depth(client::BinanceClient, query::DepthQuery)
    depth(client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config); kw...)

[`GET fapi/v1/depth`](https://binance-docs.github.io/apidocs/futures/en/#order-book)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |
| limit     | Int64  | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.FAPI.V1.depth(;
    symbol = "ADAUSDT"
)
```
"""
function depth(client::BinanceClient, query::DepthQuery)
    return APIsRequest{DepthData}("GET", "fapi/v1/depth", query)(client)
end

function depth(
    client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config);
    kw...,
)
    return depth(client, DepthQuery(; kw...))
end

end
