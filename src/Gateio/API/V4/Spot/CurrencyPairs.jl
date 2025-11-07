module CurrencyPairs

export CurrencyPairQuery,
    CurrencyPairsQuery,
    CurrencyPairData,
    currency_pair,
    currency_pairs

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct CurrencyPairQuery <: GateioPublicQuery
    currency_pair::String
end

Base.@kwdef struct CurrencyPairsQuery <: GateioPublicQuery
    #__ empty
end

struct CurrencyPairData <: GateioData
    id::String
    base::String
    var"quote"::String
    fee::Maybe{Float64}
    min_base_amount::Maybe{Float64}
    min_quote_amount::Maybe{Float64}
    max_base_amount::Maybe{Float64}
    max_quote_amount::Maybe{Float64}
    amount_precision::Maybe{Int64}
    precision::Maybe{Int64}
    trade_status::Maybe{String}
    sell_start::Maybe{NanoDate}
    buy_start::Maybe{NanoDate}
end

"""
    currency_pair(client::GateioClient, query::CurrencyPairQuery)
    currency_pair(client::GateioClient = Gateio.public_client; kw...)

Get details of a specifc currency pair.

[`GET /api/v4/spot/currency_pairs/{currency_pair}`](https://www.gate.io/docs/developers/apiv4/#get-details-of-a-specifc-currency-pair)

## Parameters:

| Parameter     | Type       | Required | Description |
|:--------------|:-----------|:---------|:------------|
| currency_pair | String     | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Spot.currency_pair(; 
    currency_pair = "ETH_BTC",
)
```
"""
function currency_pair(client::GateioClient, query::CurrencyPairQuery)
    end_piont = "api/v4/spot/currency_pairs/$(query.currency_pair)"
    return APIsRequest{CurrencyPairData}("GET", end_piont, query)(client)
end

function currency_pair(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return currency_pair(client, CurrencyPairQuery(; kw...))
end

"""
    currency_pairs(client::GateioClient, query::CurrencyPairsQuery)
    currency_pairs(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

List all currency pairs supported.

[`GET /api/v4/spot/currency_pairs/`](https://www.gate.io/docs/developers/apiv4/#list-all-currency-pairs-supported)

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Spot.currency_pairs()
```
"""
function currency_pairs(client::GateioClient, query::CurrencyPairsQuery)
    end_piont = "api/v4/spot/currency_pairs"
    return APIsRequest{Vector{CurrencyPairData}}("GET", end_piont, query)(client)
end

function currency_pairs(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return currency_pairs(client, CurrencyPairsQuery(; kw...))
end

end
