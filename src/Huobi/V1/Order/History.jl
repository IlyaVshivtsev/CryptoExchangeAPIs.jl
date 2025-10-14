module History

export HistoryQuery,
    HistoryData,
    history

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx DirectQuery prev next

Base.@kwdef mutable struct HistoryQuery <: HuobiPrivateQuery
    AccessKeyId::Maybe{String} = nothing
    Signature::Maybe{String} = nothing
    SignatureMethod::Maybe{String} = nothing
    SignatureVersion::Maybe{String} = nothing
    Timestamp::Maybe{DateTime} = nothing

    direct::Maybe{DirectQuery.T} = nothing
    end_time::Maybe{DateTime} = nothing
    size::Maybe{Int64} = nothing
    start_time::Maybe{DateTime} = nothing
    symbol::Maybe{String} = nothing
end

struct HistoryData <: HuobiData
    field_fees::Maybe{Float64}
    price::Float64
    state::String
    canceled_at::Maybe{Int64}
    client_order_id::Maybe{Int64}
    amount::Float64
    field_amount::Maybe{Float64}
    created_at::Maybe{NanoDate}
    account_id::Maybe{Int64}
    field_cash_amount::Maybe{Float64}
    finished_at::Maybe{Int64}
    symbol::String
    id::Int64
    type::String
    source::String
end

"""
    history(client::HuobiClient, query::HistoryQuery)
    history(client::HuobiClient; kw...)

This endpoint returns orders based on a specific searching criteria. The orders created via API will no longer be queryable after being cancelled for more than 2 hours.

[`GET v1/order/history`](https://huobiapi.github.io/docs/spot/v1/en/#search-past-orders)

## Parameters:

| Parameter        | Type        | Required | Description   |
|:-----------------|:------------|:---------|:--------------|
| direct           | DirectQuery | false    | `prev` `next` |
| end_time         | DateTime    | false    |               |
| size             | Int64       | false    |               |
| start_time       | DateTime    | false    |               |
| symbol           | String      | false    |               |

## Code samples:

```julia
using CryptoExchangeAPIs.Huobi

client = HuobiClient(;
    base_url = "https://api.huobi.pro",
    public_key = ENV["HUOBI_PUBLIC_KEY"],
    secret_key = ENV["HUOBI_SECRET_KEY"],
)

result = Huobi.V1.Order.history(
    client;
    start_time = now(UTC) - Day(1),
    end_time = now(UTC) - Hour(1),
    size = 1000,
)
```
"""
function history(client::HuobiClient, query::HistoryQuery)
    return APIsRequest{Data{Vector{HistoryData}}}("GET", "v1/order/history", query)(client)
end

function history(client::HuobiClient; kw...)
    return history(client, HistoryQuery(; kw...))
end

end

