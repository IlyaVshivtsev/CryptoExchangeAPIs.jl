module Depth

export DepthQuery,
    DepthData,
    depth

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct DepthQuery <: KrakenPublicQuery
    pair::String
    count::Maybe{Int64} = nothing
end

struct DepthLevel <: KrakenData
    price::Float64
    volume::Float64
    timestamp::NanoDate
end

struct DepthData <: KrakenData
    asks::Vector{DepthLevel}
    bids::Vector{DepthLevel}
end

"""
    depth(client::KrakenClient, query::DepthQuery)
    depth(client::KrakenClient = Kraken.KrakenClient(Kraken.public_config); kw...)

Get current order book details.

[`GET 0/public/Depth`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getOrderBook)

## Parameters:

| Parameter | Type       | Required | Description |
|:----------|:-----------|:---------|:------------|
| pair      | String     | true     |             |
| count     | Int64      | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

result = Kraken.V0.Public.depth(;
    pair = "XBTUSD",
    count = 10,
)
```
"""
function depth(client::KrakenClient, query::DepthQuery)
    return APIsRequest{Data{Dict{String,DepthData}}}("GET", "0/public/Depth", query)(client)
end

function depth(client::KrakenClient = Kraken.KrakenClient(Kraken.public_config); kw...)
    return depth(client, DepthQuery(; kw...))
end

end

