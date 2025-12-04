module Symbols

export SymbolsQuery,
    SymbolsData,
    symbols

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bitget
using CryptoExchangeAPIs.Bitget: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct SymbolsQuery <: BitgetPublicQuery
    symbol::Maybe{String} = nothing
end

@enumx SymbolStatus begin
    offline
    gray
    online
    halt
end

struct SymbolsData <: BitgetData
    symbol::String
    baseCoin::String
    quoteCoin::String
    minTradeAmount::Float64
    maxTradeAmount::Float64
    takerFeeRate::Float64
    makerFeeRate::Float64
    pricePrecision::Int
    quantityPrecision::Int
    quotePrecision::Int
    minTradeUSDT::Float64
    status::SymbolStatus.T
    buyLimitPriceRatio::Float64
    sellLimitPriceRatio::Float64
    orderQuantity::Int
    areaSymbol::String
    offTime::Maybe{NanoDate}
end

"""
    symbols(client::BitgetClient, query::SymbolsQuery)
    symbols(client::BitgetClient = Bitget.BitgetClient(Bitget.public_config); kw...)

Get spot trading pair information, supporting both individual and full queries.

[`GET api/v2/spot/public/symbols`](https://www.bitget.com/api-doc/spot/market/Get-Symbols)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | false    | Trading pair symbol (e.g., "BTCUSDT"). If not provided, returns all symbols. |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitget

# Get all symbols
result = Bitget.API.V2.Spot.Public.symbols()

# Get specific symbol
result = Bitget.API.V2.Spot.Public.symbols(; symbol = "BTCUSDT")
```
"""
function symbols(client::BitgetClient, query::SymbolsQuery)
    return APIsRequest{Data{Vector{SymbolsData}}}("GET", "api/v2/spot/public/symbols", query)(client)
end

function symbols(
    client::BitgetClient = Bitget.BitgetClient(Bitget.public_config);
    kw...,
)
    return symbols(client, SymbolsQuery(; kw...))
end

end
