module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: KrakenPublicQuery
    pair::Maybe{String} = nothing
end

struct Level <: KrakenData
    price::Float64
    whole_lot_volume::Float64
    lot_volume::Float64
end

struct TickerData <: KrakenData
    a::Maybe{Level}
    b::Maybe{Level}
    c::Maybe{Vector{Float64}}
    v::Maybe{Vector{Float64}}
    p::Maybe{Vector{Float64}}
    t::Maybe{Vector{Int64}}
    l::Maybe{Vector{Float64}}
    h::Maybe{Vector{Float64}}
    o::Float64
end

"""
    ticker(client::KrakenClient, query::TickerQuery)
    ticker(client::KrakenClient = Kraken.KrakenClient(Kraken.public_config); kw...)

Get ticker information for all or requested markets.

[`GET 0/public/Ticker`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getTickerInformation)

## Parameters:

| Parameter | Type       | Required | Description |
|:----------|:-----------|:---------|:------------|
| pair      | String     | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

result = Kraken.V0.Public.ticker(;
    pair = "XBTUSD",
)
```
"""
function ticker(client::KrakenClient, query::TickerQuery)
    return APIsRequest{Data{Dict{String,TickerData}}}("GET", "0/public/Ticker", query)(client)
end

function ticker(client::KrakenClient = Kraken.KrakenClient(Kraken.public_config); kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
