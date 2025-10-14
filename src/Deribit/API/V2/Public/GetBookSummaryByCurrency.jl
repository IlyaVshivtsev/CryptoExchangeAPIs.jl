module GetBookSummaryByCurrency

export GetBookSummaryByCurrencyQuery,
    GetBookSummaryByCurrencyData,
    get_book_summary_by_currency

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

Base.@kwdef struct GetBookSummaryByCurrencyQuery <: DeribitPublicQuery
    currency::Currency.T
    kind::Maybe{InstrumentKind.T} = nothing
end

struct GetBookSummaryByCurrencyData <: DeribitData
    instrument_name::String
    base_currency::String
    quote_currency::String
    ask_price::Maybe{Float64}
    bid_price::Maybe{Float64}
    mid_price::Maybe{Float64}
    mark_price::Maybe{Float64}
    estimated_delivery_price::Maybe{Float64}
    price_change::Maybe{Float64}
    volume::Maybe{Float64}
    volume_notional::Maybe{Float64}
    volume_usd::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    last::Maybe{Float64}
    current_funding::Maybe{Float64}
    funding_8h::Maybe{Float64}
    interest_rate::Maybe{Float64}
    open_interest::Maybe{Float64}
    underlying_index::Maybe{String}
    underlying_price::Maybe{Float64}
    creation_timestamp::NanoDate
end

"""
    get_book_summary_by_currency(client::DeribitClient, query::GetBookSummaryByCurrencyQuery)
    get_book_summary_by_currency(client::DeribitClient = Deribit.DeribitClient(Deribit.public_config); kw...)

Retrieves the summary information such as open interest, 24h volume, etc. for all instruments for the currency (optionally filtered by kind).

[`GET api/v2/public/get_book_summary_by_currency`](https://docs.deribit.com/#public-get_book_summary_by_currency)

## Parameters:

| Parameter | Type           | Required | Description               |
|:----------|:---------------|:---------|:--------------------------|
| currency  | Currency       | true     | `BTC` `ETH` `USDC` `USDT` |
| kind      | InstrumentKind | false    | `option` `spot` `future` `future_combo` `option_combo` |

## Code samples:

```julia
using CryptoExchangeAPIs.Deribit

result = Deribit.API.V2.Public.get_book_summary_by_currency(;
    currency = Deribit.API.V2.Public.GetBookSummaryByCurrency.Currency.BTC
)
```
"""
function get_book_summary_by_currency(client::DeribitClient, query::GetBookSummaryByCurrencyQuery)
    return APIsRequest{Data{Vector{GetBookSummaryByCurrencyData}}}("GET", "api/v2/public/get_book_summary_by_currency", query)(client)
end

function get_book_summary_by_currency(
    client::DeribitClient = Deribit.DeribitClient(Deribit.public_config);
    kw...
)
    return get_book_summary_by_currency(client, GetBookSummaryByCurrencyQuery(; kw...))
end

end

