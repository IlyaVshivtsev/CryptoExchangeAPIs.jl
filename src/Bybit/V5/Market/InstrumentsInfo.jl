module InstrumentsInfo

export InstrumentsInfoQuery,
    InstrumentsInfoData,
    instruments_info

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Category OPTION SPOT LINEAR INVERSE

Base.@kwdef struct InstrumentsInfoQuery <: BybitPublicQuery
    category::Category.T
    symbol::Maybe{String} = nothing
    status::Maybe{String} = nothing
    baseCoin::Maybe{String} = nothing
    limit::Maybe{Int64} = nothing
    cursor::Maybe{String} = nothing
end

function Serde.ser_type(::Type{<:InstrumentsInfoQuery}, x::Category.T)::String
  x == Category.OPTION  && return "option"
  x == Category.SPOT    && return "spot"
  x == Category.LINEAR  && return "linear"
  x == Category.INVERSE && return "inverse"
end

struct LotSizeFilter <: BybitData
  basePrecision::Maybe{Float64}
  quotePrecision::Maybe{Float64}
  minOrderQty::Float64
  maxOrderQty::Float64
  minOrderAmt::Maybe{Float64}
  maxOrderAmt::Maybe{Float64}
end

struct PriceFilter <: BybitData
  tickSize::Float64
end

struct RiskParameters <: BybitData
  limitParameter::Maybe{Float64}
  marketParameter::Maybe{Float64}
end

struct InstrumentsInfoData <: BybitData
  symbol::String
  baseCoin::String
  quoteCoin::String
  innovation::Maybe{Int64}
  status::String
  lotSizeFilter::LotSizeFilter
  priceFilter::PriceFilter
  riskParameters::Maybe{RiskParameters}
end

"""
    instruments_info(client::BybitClient, query::InstrumentsInfoQuery)
    instruments_info(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)

Query for the instrument specification of online trading pairs.

[`GET /v5/market/instruments-info`](https://bybit-exchange.github.io/docs/v5/market/instrument)

## Parameters:

| Parameter | Type     | Required | Description                |
|:----------|:---------|:---------|:-------------------------- |
| category  | Category | true     | SPOT LINEAR INVERSE OPTION |
| symbol    | String   | true     |                            |
| status    | String   | true     |                            |
| baseCoin  | String   | true     |                            |
| limit     | Int64    | false    |                            |
| cursor    | String   | true     |                            |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

result = Bybit.V5.Market.instruments_info(;
    category = Bybit.V5.Market.InstrumentsInfo.Category.SPOT,
    symbol = "BTCUSDT",
)
```
"""
function instruments_info(client::BybitClient, query::InstrumentsInfoQuery)
    return APIsRequest{Data{List{InstrumentsInfoData}}}("GET", "/v5/market/instruments-info", query)(client)
end

function instruments_info(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)
    return instruments_info(client, InstrumentsInfoQuery(; kw...))
end

end
