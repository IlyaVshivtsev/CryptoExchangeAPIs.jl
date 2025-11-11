module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Deribit
using CryptoExchangeAPIs.Deribit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: DeribitPublicQuery
    instrument_name::String
end

struct Greeks <: DeribitData
    delta::Float64
    gamma::Float64
    rho::Float64
    theta::Float64
    vega::Float64
end

struct Stats <: DeribitData
    high::Maybe{Float64}
    low::Maybe{Float64}
    price_change::Maybe{Float64}
    volume::Float64
    volume_usd::Float64
end

struct TickerData <: DeribitData
    instrument_name::String
    ask_iv::Maybe{Float64}
    best_ask_amount::Maybe{Float64}
    best_ask_price::Maybe{Float64}
    best_bid_amount::Maybe{Float64}
    best_bid_price::Maybe{Float64}
    bid_iv::Maybe{Float64}
    current_funding::Maybe{Float64}
    delivery_price::Maybe{Float64}
    estimated_delivery_price::Maybe{Float64}
    funding_8h::Maybe{Float64}
    greeks::Maybe{Greeks}
    index_price::Maybe{Float64}
    interest_rate::Maybe{Float64}
    interest_value::Maybe{Float64}
    last_price::Maybe{Float64}
    mark_iv::Maybe{Float64}
    mark_price::Maybe{Float64}
    max_price::Maybe{Float64}
    min_price::Maybe{Float64}
    open_interest::Maybe{Float64}
    settlement_price::Maybe{Float64}
    state::Maybe{String}
    stats::Maybe{Stats}
    timestamp::NanoDate
    underlying_index::Maybe{String}
    underlying_price::Maybe{Float64}
end

function Serde.deser(::Type{TickerData}, ::Type{Maybe{Float64}}, x::String)
    return x == "expired" ? NaN : parse(Float64, x)
end

"""
    ticker(client::DeribitClient, query::TickerQuery)
    ticker(client::DeribitClient = Deribit.DeribitClient(Deribit.public_config); kw...)

Get ticker for an instrument.

[`GET api/v2/public/ticker`](https://docs.deribit.com/#public-ticker)

## Parameters:

| Parameter       | Type   | Required | Description |
|:----------------|:-------|:---------|:------------|
| instrument_name | String | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Deribit

result = Deribit.API.V2.Public.ticker(;
    instrument_name = "BTC-PERPETUAL",
)
```
"""
function ticker(client::DeribitClient, query::TickerQuery)
    return APIsRequest{Data{TickerData}}("GET", "api/v2/public/ticker", query)(client)
end

function ticker(
    client::DeribitClient = Deribit.DeribitClient(Deribit.public_config);
    kw...
)
    return ticker(client, TickerQuery(; kw...))
end

end

