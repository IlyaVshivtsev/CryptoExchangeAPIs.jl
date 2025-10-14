module GetInstruments

export GetInstrumentsQuery,
    GetInstrumentsData,
    get_instruments

export Currency,
    InstrumentKind

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Deribit
using CryptoExchangeAPIs.Deribit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Currency BTC ETH USDC USDT

@enumx InstrumentKind begin
    future
    option
    future_combo
    option_combo
    spot
end

Base.@kwdef struct GetInstrumentsQuery <: DeribitPublicQuery
    currency::Currency.T
    expired::Maybe{Bool} = nothing
    kind::Maybe{InstrumentKind.T} = nothing
end

@enum FutureType linear reversed

@enum OptionType put call

struct GetInstrumentsData <: DeribitData
    instrument_name::Maybe{String}
    base_currency::Maybe{String}
    quote_currency::Maybe{String}
    block_trade_commission::Maybe{Float64}
    block_trade_min_trade_amount::Maybe{Float64}
    block_trade_tick_size::Maybe{Float64}
    contract_size::Maybe{Float64}
    counter_currency::Maybe{String}
    creation_timestamp::NanoDate
    expiration_timestamp::NanoDate
    future_type::Maybe{FutureType}
    instrument_id::Int64
    instrument_type::Maybe{String}
    is_active::Bool
    kind::Maybe{InstrumentKind.T}
    maker_commission::Maybe{Float64}
    max_leverage::Maybe{Float64}
    max_liquidation_commission::Maybe{Float64}
    min_trade_amount::Maybe{Float64}
    option_type::Maybe{OptionType}
    price_index::Maybe{String}
    rfq::Maybe{Bool}
    settlement_currency::Maybe{String}
    settlement_period::Maybe{String}
    strike::Maybe{Float64}
    taker_commission::Maybe{Float64}
    tick_size::Maybe{Float64}
end

"""
    get_instruments(client::DeribitClient, query::InstrumentQuery)
    get_instruments(client::DeribitClient = Deribit.DeribitClient(Deribit.public_config); kw...)

Retrieves available trading instruments. This method can be used to see which instruments are available for trading, or which instruments have recently expired.

[`GET api/v2/public/get_instruments`](https://docs.deribit.com/#public-get_instruments)

## Parameters:

| Parameter | Type           | Required | Description               |
|:----------|:---------------|:---------|:--------------------------|
| currency  | Currency       | true     | `BTC` `ETH` `USDC` `USDT` |
| expired   | Bool           | false    |                           |
| kind      | InstrumentKind | false    | `option` `spot` `future` `future_combo` `option_combo` |


## Code samples:

```julia
using CryptoExchangeAPIs.Deribit

result = Deribit.API.V2.Public.get_instruments(;
    currency = Deribit.API.V2.Public.GetInstruments.Currency.BTC
)
```
"""
function get_instruments(client::DeribitClient, query::GetInstrumentsQuery)
    return APIsRequest{Data{Vector{GetInstrumentsData}}}("GET", "api/v2/public/get_instruments", query)(client)
end

function get_instruments(
    client::DeribitClient = Deribit.DeribitClient(Deribit.public_config);
    kw...,
)
    return get_instruments(client, GetInstrumentsQuery(; kw...))
end

end
