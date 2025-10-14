module QueryRecord

export QueryRecordQuery,
    QueryRecordData,
    query_record

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct QueryRecordQuery <: BybitPrivateQuery
    coin::Maybe{String} = nothing
    cursor::Maybe{String} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Int64 = 50
    startTime::Maybe{DateTime} = nothing

    api_key::Maybe{String} = nothing
    recv_window::Int64 = 5000
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct QueryRecordData <: BybitData
    amount::Float64
    blockHash::Maybe{String}
    chain::String
    coin::String
    confirmations::Maybe{Int64}
    depositFee::Maybe{Float64}
    status::Maybe{Int64}
    successAt::NanoDate
    tag::Maybe{String}
    toAddress::Maybe{String}
    txID::Maybe{String}
    txIndex::Maybe{Int64}
    batchReleaseLimit::Maybe{String}
    depositType::Maybe{Int64}
end

function Serde.isempty(::Type{<:QueryRecordData}, x)::Bool
    return x === ""
end

"""
    query_record(client::BybitClient, query::QueryRecordQuery)
    query_record(client::BybitClient; kw...)

Query Deposit Records.

[`GET /v5/asset/deposit/query-record`](https://bybit-exchange.github.io/docs/v5/asset/deposit/deposit-record)

## Parameters:

| Parameter   | Type     | Required | Description          |
|:------------|:---------|:---------|:---------------------|
| coin        | String   | false    |                      |
| cursor      | String   | false    |                      |
| endTime     | DateTime | false    |                      |
| limit       | Int64    | false    | Default: 50, Max: 50 |
| startTime   | DateTime | false    |                      |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

client = BybitClient(;
    base_url = "https://api.bybit.com",
    public_key = ENV["BYBIT_PUBLIC_KEY"],
    secret_key = ENV["BYBIT_SECRET_KEY"],
)

result = Bybit.V5.Asset.Deposit.query_record(client)
```
"""
function query_record(client::BybitClient, query::QueryRecordQuery)
    return APIsRequest{Data{Rows{QueryRecordData}}}("GET", "/v5/asset/deposit/query-record", query)(client)
end

function query_record(client::BybitClient; kw...)
    return query_record(client, QueryRecordQuery(; kw...))
end

end

