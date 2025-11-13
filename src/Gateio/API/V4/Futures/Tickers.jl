module Tickers

export TickersQuery,
    TickersData,
    tickers

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Settle btc usdt

Base.@kwdef struct TickersQuery <: GateioPublicQuery
    settle::Settle.T
    contract::Maybe{String} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{TickersQuery}, ::Val{:settle}) = true

struct TickersData <: GateioData
    contract::String
    last::Maybe{Float64}
    low_24h::Maybe{Float64}
    high_24h::Maybe{Float64}
    change_percentage::Maybe{Float64}
    total_size::Maybe{Int64}
    volume_24h::Maybe{Int64}
    volume_24h_btc::Maybe{Int64}
    volume_24h_usd::Maybe{Int64}
    volume_24h_base::Maybe{Int64}
    volume_24h_quote::Maybe{Int64}
    volume_24h_settle::Maybe{Int64}
    mark_price::Maybe{Float64}
    funding_rate::Maybe{Float64}
    funding_rate_indicative::Maybe{Float64}
    index_price::Maybe{Float64}
    highest_bid::Maybe{Float64}
    lowest_ask::Maybe{Float64}
end

"""
    tickers(client::GateioClient, query::TickersQuery)
    tickers(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

List futures tickers.

[`GET api/v4/futures/{settle}/tickers`](https://www.gate.io/docs/developers/apiv4/en/#list-futures-tickers)

## Parameters:

| Parameter | Type     | Required | Description  |
|:----------|:---------|:---------|:-------------|
| settle    | Settle   | true     | btc usdt usd |
| contract  | String   | false    |              |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Futures.tickers(;
    settle = Gateio.API.V4.Futures.Tickers.Settle.btc,
)
```
"""
function tickers(client::GateioClient, query::TickersQuery)
    return APIsRequest{Vector{TickersData}}("GET", "api/v4/futures/$(query.settle)/tickers", query)(client)
end

function tickers(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return tickers(client, TickersQuery(; kw...))
end

end
