module FundingHistory

export FundingHistoryQuery,
    FundingHistoryData,
    funding_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct FundingHistoryQuery <: KucoinPrivateQuery
    symbol::String
    startAt::Maybe{NanoDate} = nothing
    endAt::Maybe{NanoDate} = nothing
    reverse::Maybe{Bool} = nothing
    offset::Maybe{Int64} = nothing
    forward::Maybe{Bool} = nothing
    maxCount::Maybe{Int64} = nothing

    passphrase::Maybe{String} = nothing
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct DataList <: KucoinData
    id::Int64
    symbol::String
    timePoint::NanoDate
    fundingRate::Float64
    markPrice::Float64
    positionQty::Int64
    positionCost::Float64
    funding::Float64
    settleCurrency::String
end

function Serde.isempty(::Type{DataList}, x)::Bool
    return x === ""
end

struct FundingHistoryData <: KucoinData
    dataList::Vector{DataList}
    hasMore::Bool
end

"""
    funding_history(client::KucoinClient, query::FundingHistoryQuery)
    funding_history(client::KucoinClient; kw...)

Submit request to get the funding history.

[`GET api/v1/funding-history`](https://www.kucoin.com/docs/rest/futures-trading/funding-fees/get-private-funding-history)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | true     |             |
| startAt   | NanoDate | false    |             |
| endAt     | NanoDate | false    |             |
| reverse   | Bool     | false    |             |
| offset    | Int64    | false    |             |
| forward   | Bool     | false    |             |
| maxCount  | Int64    | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin

kucoin_client = KucoinClient(;
    base_url = "https://api-futures.kucoin.com",
    public_key = ENV["KUCOIN_PUBLIC_KEY"],
    secret_key = ENV["KUCOIN_SECRET_KEY"],
    passphrase = ENV["KUCOIN_PASSPHRASE"],
)

result = Kucoin.API.V1.funding_history(
    kucoin_client;
    symbol = "XBTUSDM",
)
```
"""
function funding_history(client::KucoinClient, query::FundingHistoryQuery)
    return APIsRequest{Data{FundingHistoryData}}("GET", "api/v1/funding-history", query)(client)
end

function funding_history(client::KucoinClient; kw...)
    return funding_history(client, FundingHistoryQuery(; kw...))
end

end

