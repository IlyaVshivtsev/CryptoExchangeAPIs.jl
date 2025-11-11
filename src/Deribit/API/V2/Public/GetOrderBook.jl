module GetOrderBook

export GetOrderBookQuery,
    GetOrderBookData,
    get_order_book

export Depth

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Deribit
using CryptoExchangeAPIs.Deribit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Depth begin
    ONE = 1
    FIVE = 5
    TEN = 10
    TWENTY = 20
    FIFTY = 50
    ONE_HUNDRED = 100
    THOUSAND = 1000
    TEN_THOUSAND = 10000
end

Base.@kwdef struct GetOrderBookQuery <: DeribitPublicQuery
    instrument_name::String
    depth::Maybe{Depth.T} = nothing
end

function Serde.ser_type(::Type{GetOrderBookQuery}, x::Depth.T)::Int64
    return Int64(x)
end

struct Level <: DeribitData
    amount::Float64
    price::Float64
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

struct GetOrderBookData <: DeribitData
    ask_iv::Maybe{Float64}
    asks::Vector{Level}
    best_ask_amount::Float64
    best_ask_price::Float64
    best_bid_amount::Float64
    best_bid_price::Float64
    bid_iv::Maybe{Float64}
    bids::Vector{Level}
    change_id::Int64
    current_funding::Maybe{Float64}
    delivery_price::Maybe{Float64}
    estimated_delivery_price::Maybe{Float64}
    funding_8h::Maybe{Float64}
    greeks::Maybe{Greeks}
    index_price::Float64
    instrument_name::String
    interest_rate::Maybe{Float64}
    last_price::Maybe{Float64}
    mark_iv::Maybe{Float64}
    mark_price::Float64
    max_price::Float64
    min_price::Float64
    open_interest::Maybe{Float64}
    settlement_price::Maybe{Float64}
    state::String
    stats::Stats
    timestamp::NanoDate
    underlying_index::Maybe{String}
    underlying_price::Maybe{Float64}
end

"""
    get_order_book(client::DeribitClient, query::GetOrderBookQuery)
    get_order_book(client::DeribitClient = Deribit.DeribitClient(Deribit.public_config); kw...)

Retrieves the order book, along with other market values for a given instrument.

[`GET api/v2/public/get_order_book`](https://docs.deribit.com/#public-get_order_book)

## Parameters:

| Parameter       | Type   | Required | Description |
|:----------------|:-------|:---------|:------------|
| instrument_name | String | true     |             |
| depth           | Depth  | false    | `ONE` (1), `FIVE` (5), `TEN` (10), `TWENTY` (20), `FIFTY` (50), `ONE_HUNDRED` (100), `THOUSAND` (1000), `TEN_THOUSAND` (10000) |

## Code samples:

```julia
using CryptoExchangeAPIs.Deribit

result = Deribit.API.V2.Public.get_order_book(;
    instrument_name = "BTC-PERPETUAL",
    depth = Deribit.API.V2.Public.GetOrderBook.Depth.TEN,
)
```
"""
function get_order_book(client::DeribitClient, query::GetOrderBookQuery)
    return APIsRequest{Data{GetOrderBookData}}("GET", "api/v2/public/get_order_book", query)(client)
end

function get_order_book(
    client::DeribitClient = Deribit.DeribitClient(Deribit.public_config);
    kw...
)
    return get_order_book(client, GetOrderBookQuery(; kw...))
end

end

