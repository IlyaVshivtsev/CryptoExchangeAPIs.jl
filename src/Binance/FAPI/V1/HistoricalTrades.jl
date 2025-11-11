module HistoricalTrades

export HistoricalTradesQuery,
    HistoricalTradesData,
    historical_trades

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct HistoricalTradesQuery <: BinancePrivateQuery
    symbol::String
    limit::Maybe{Int64} = nothing
    fromId::Maybe{Int64} = nothing

    recvWindow::Maybe{Int64} = nothing
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct HistoricalTradesData <: BinanceData
    id::Maybe{Int64}
    price::Maybe{Float64}
    qty::Maybe{Float64}
    quoteQty::Maybe{Float64}
    time::NanoDate
    isBuyerMaker::Bool
end

"""
    historical_trades(client::BinanceClient, query::HistoricalTradesQuery)
    historical_trades(client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config); kw...)

Get older market historical trades.

[`GET fapi/v1/historicalTrades`](https://binance-docs.github.io/apidocs/futures/en/#old-trades-lookup-market_data)

## Parameters:

| Parameter | Type   | Required | Description                                            |
|:----------|:-------|:---------|:-------------------------------------------------------|
| symbol    | String | true     |                                                        |
| limit     | Int64  | false    | Default: 500; Max: 1000                                |
| fromId    | Int64  | false    | TradeId to fetch from. Default gets most recent trades |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.FAPI.V1.historical_trades(;
    symbol = "BTCUSDT",
    limit = 100,
)
```
"""
function historical_trades(client::BinanceClient, query::HistoricalTradesQuery)
    return APIsRequest{Vector{HistoricalTradesData}}("GET", "fapi/v1/historicalTrades", query)(client)
end

function historical_trades(
    client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config);
    kw...,
)
    return historical_trades(client, HistoricalTradesQuery(; kw...))
end

end

