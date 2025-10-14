module Depth

export DepthQuery,
    DepthData,
    depth

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: DataTick
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx StepType begin
    step0  # No market depth aggregation
    step1  # Aggregation level = precision*10
    step2  # Aggregation level = precision*100
    step3  # Aggregation level = precision*1000
    step4  # Aggregation level = precision*10000
    step5  # Aggregation level = precision*100000
end

Base.@kwdef struct DepthQuery <: HuobiPublicQuery
    symbol::String
    depth::Maybe{Int64} = nothing
    type::StepType.T = StepType.step0
end

struct Level
    price::Float64
    size::Float64
end

struct DepthData <: HuobiData
    asks::Vector{Level}
    bids::Vector{Level}
    ts::NanoDate
    version::Int64
end

"""
    depth(client::HuobiClient, query::DepthQuery)
    depth(client::HuobiClient = Huobi.HuobiClient(Huobi.public_config); kw...)

This endpoint retrieves the current order book of a specific pair.

[`GET market/depth`](https://huobiapi.github.io/docs/spot/v1/en/#get-market-depth)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | true     |             |
| depth     | Int64    | false    |             |
| type      | StepType | false    | Default: `step0`, Available: `step1`, `step2`, `step3`, `step4`, `step5` |

## Code samples:

```julia
using CryptoExchangeAPIs.Huobi

result = Huobi.Market.depth(;
    symbol = "btcusdt",
)
```
"""
function depth(client::HuobiClient, query::DepthQuery)
    return APIsRequest{DataTick{DepthData}}("GET", "market/depth", query)(client)
end

function depth(client::HuobiClient = Huobi.HuobiClient(Huobi.public_config); kw...)
    return depth(client, DepthQuery(; kw...))
end

end

