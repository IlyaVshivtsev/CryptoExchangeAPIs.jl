module GetInstruments

export GetInstrumentsQuery,
    GetInstrumentsData,
    get_instruments

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Cryptocom
using CryptoExchangeAPIs.Cryptocom: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct GetInstrumentsQuery <: CryptocomPublicQuery
    #__ empty
end

struct InstrumentInfo <: CryptocomData
    symbol::String
    base_ccy::String
    quote_ccy::String
    inst_type::String
    display_name::String
    quote_decimals::Int64
    quantity_decimals::Int64
    price_tick_size::Float64
    qty_tick_size::Float64
    max_leverage::Int64
    tradable::Bool
    expiry_timestamp_ms::Int64
    underlying_symbol::Maybe{String}
end

function Serde.isempty(::Type{InstrumentInfo}, x)::Bool
    return x === ""
end

struct GetInstrumentsData <: CryptocomData
    data::Vector{InstrumentInfo}
end

function Serde.isempty(::Type{GetInstrumentsData}, x)::Bool
    return x == []
end

"""
    get_instruments(client::CryptocomClient, query::GetInstrumentsQuery)
    get_instruments(client::CryptocomClient = Cryptocom.CryptocomClient(Cryptocom.public_config); kw...)

Provides information on all supported instruments.

[`GET public/get-instruments`](https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#public-get-instruments)

## Code samples:

```julia
using CryptoExchangeAPIs.Cryptocom

result = Cryptocom.Public.get_instruments()
```
"""
function get_instruments(client::CryptocomClient, query::GetInstrumentsQuery)
    return APIsRequest{Data{GetInstrumentsData}}("GET", "public/get-instruments", query)(client)
end

function get_instruments(
    client::CryptocomClient = Cryptocom.CryptocomClient(Cryptocom.public_config);
    kw...,
)
    return get_instruments(client, GetInstrumentsQuery(; kw...))
end

end
