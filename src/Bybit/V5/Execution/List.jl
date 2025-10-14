module List

export ListQuery,
    ListData,
    list

using Serde
using Dates, NanoDates
using EnumX

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List as ListResult
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Category OPTION SPOT LINEAR INVERSE

Base.@kwdef mutable struct ListQuery <: BybitPrivateQuery
    category::Category.T
    symbol::Maybe{String} = nothing
    orderId::Maybe{String} = nothing
    orderLinkId::Maybe{String} = nothing
    baseCoin::Maybe{String} = nothing
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    execType::Maybe{String} = nothing
    limit::Int64 = 50
    cursor::Maybe{String} = nothing

    api_key::Maybe{String} = nothing
    recv_window::Int64 = 5000
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:ListQuery}, x::Category.T)::String
    x == Category.OPTION  && return "option"
    x == Category.SPOT    && return "spot"
    x == Category.LINEAR  && return "linear"
    x == Category.INVERSE && return "inverse"
end

@enumx Side Buy Sell

@enumx OrderType Market Limit

struct ListData <: BybitData
    symbol::String
    orderId::String
    orderLinkId::Maybe{String}
    side::Side.T
    orderPrice::Float64
    orderQty::Float64
    leavesQty::Maybe{Float64}
    createType::Maybe{String}
    orderType::OrderType.T
    stopOrderType::Maybe{String}
    execFee::Float64
    execId::String
    execPrice::Float64
    execQty::Float64
    execType::Maybe{String}
    execValue::Maybe{Float64}
    execTime::NanoDate
    feeCurrency::Maybe{String}
    isMaker::Bool
    feeRate::Maybe{Float64}
    tradeIv::Maybe{String}
    markIv::Maybe{String}
    markPrice::Maybe{Float64}
    indexPrice::Maybe{Float64}
    underlyingPrice::Maybe{Float64}
    blockTradeId::Maybe{String}
    closedSize::Maybe{Float64}
    seq::Maybe{Int64}
end

function Serde.isempty(::Type{<:ListData}, x)::Bool
    return x === ""
end

"""
    list(client::BybitClient, query::ListQuery)
    list(client::BybitClient; kw...)

Query users' execution records.

[`GET /v5/execution/list`](https://bybit-exchange.github.io/docs/v5/order/execution)

## Parameters:

| Parameter   | Type     | Required | Description           |
|:------------|:---------|:---------|:----------------------|
| category    | Category | true     | SPOT LINEAR INVERSE OPTION |
| symbol      | String   | false    |                       |
| orderId     | String   | false    |                       |
| orderLinkId | String   | false    |                       |
| baseCoin    | String   | false    |                       |
| startTime   | DateTime | false    |                       |
| endTime     | DateTime | false    |                       |
| execType    | String   | false    |                       |
| limit       | Int64    | false    | Default: 50, Max: 100 |
| cursor      | String   | false    |                       |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

client = BybitClient(;
    base_url = "https://api.bybit.com",
    public_key = ENV["BYBIT_PUBLIC_KEY"],
    secret_key = ENV["BYBIT_SECRET_KEY"],
)

result = Bybit.V5.Execution.list(
    client;
    category = Bybit.V5.Execution.List.Category.LINEAR,
    limit = 1,
)
```
"""
function list(client::BybitClient, query::ListQuery)
    return APIsRequest{Data{ListResult{ListData}}}("GET", "/v5/execution/list", query)(client)
end

function list(client::BybitClient; kw...)
    return list(client, ListQuery(; kw...))
end

end

