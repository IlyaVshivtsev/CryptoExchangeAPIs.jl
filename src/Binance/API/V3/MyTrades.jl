module MyTrades

export MyTradesQuery,
    MyTradesData,
    my_trades

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct MyTradesQuery <: BinancePrivateQuery
    symbol::String
    orderId::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    fromId::Maybe{Int64} = nothing
    limit::Maybe{Int64} = 1000

    recvWindow::Maybe{Int64} = nothing
    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct MyTradesData <: BinanceData
    symbol::String
    id::Int64
    orderId::Int64
    orderListId::Int64
    price::Float64
    qty::Float64
    quoteQty::Float64
    commission::Float64
    commissionAsset::String
    time::NanoDate
    isBuyer::Bool
    isMaker::Bool
    isBestMatch::Bool
end

"""
    my_trades(client::BinanceClient, query::MyTradesQuery)
    my_trades(client::BinanceClient; kw...)

Get trades for a specific account and symbol.

[`GET api/v3/myTrades`](https://binance-docs.github.io/apidocs/spot/en/#account-trade-list-user_data)

## Parameters:

| Parameter  | Type     | Required | Description   |
|:-----------|:---------|:---------|:--------------|
| symbol     | String   | true     |               |
| orderId    | Int64    | false    |               |
| startTime  | DateTime | false    |               |
| endTime    | DateTime | false    |               |
| fromId     | Int64    | false    |               |
| limit      | Int64    | false    | Default: 1000 |
| recvWindow | Int64    | false    |               |
| signature  | String   | false    |               |
| timestamp  | DateTime | false    |               |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

binance_client = BinanceClient(;
    base_url = "https://api.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

result = Binance.API.V3.my_trades(
    binance_client;
    symbol = "BTCUSDT",
)
```
"""
function my_trades(client::BinanceClient, query::MyTradesQuery)
    return APIsRequest{Vector{MyTradesData}}("GET", "api/v3/myTrades", query)(client)
end

function my_trades(client::BinanceClient; kw...)
    return my_trades(client, MyTradesQuery(; kw...))
end

end
