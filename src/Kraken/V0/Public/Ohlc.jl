module Ohlc

export OhlcQuery,
    OhlcData,
    ohlc

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest
import CryptoExchangeAPIs: prepare_json!

@enumx TimeInterval m1 m5 m15 m30 h1 h4 d1 w1 d15

Base.@kwdef struct OhlcQuery <: KrakenPublicQuery
    pair::String
    interval::Maybe{TimeInterval.T} = nothing
    since::Maybe{DateTime} = nothing
end

function Serde.SerQuery.ser_type(::Type{OhlcQuery}, x::DateTime)::Int64
    return round(Int64, datetime2unix(x))
end

function Serde.ser_type(::Type{OhlcQuery}, x::TimeInterval.T)::Int64
    x == TimeInterval.m1  && return 1
    x == TimeInterval.m5  && return 5
    x == TimeInterval.m15 && return 15
    x == TimeInterval.m30 && return 30
    x == TimeInterval.h1  && return 60
    x == TimeInterval.h4  && return 240
    x == TimeInterval.d1  && return 1440
    x == TimeInterval.w1  && return 10080
    x == TimeInterval.d15 && return 21600
end

struct OhlcData <: KrakenData
    time::NanoDate
    open::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    close::Maybe{Float64}
    vwap::Maybe{Float64}
    volume::Maybe{Float64}
    count::Maybe{Int64}
    last::Maybe{NanoDate}
end

function prepare_json!(::Type{T}, json::Dict{String,Any}) where {T<:Data{Dict{String,Vector{OhlcData}}}}
    for (_, item) in json["result"]
        if item isa Vector
            for i in item
                push!(i, json["result"]["last"])
            end
        end
    end
    delete!(json["result"], "last")
    return json
end

"""
    ohlc(client::KrakenClient, query::OhlcQuery)
    ohlc(client::KrakenClient = Kraken.KrakenClient(Kraken.public_config); kw...)

Get OHLC data for a given market.

[`GET 0/public/OHLC`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getOHLCData)

## Parameters:

| Parameter | Type           | Required | Description                   |
|:----------|:---------------|:---------|:------------------------------|
| pair      | String         | true     |                               |
| interval  | TimeInterval   | false    | m1 m5 m15 m30 h1 h4 d1 w1 d15 |
| since     | DateTime       | false    |                               |

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

result = Kraken.V0.Public.ohlc(;
    pair = "ACAUSD",
    interval = Kraken.V0.Public.Ohlc.TimeInterval.h1,
    since = now(UTC) - Hour(1),
)
```
"""
function ohlc(client::KrakenClient, query::OhlcQuery)
    return APIsRequest{Data{Dict{String,Vector{OhlcData}}}}("GET", "0/public/OHLC", query)(client)
end

function ohlc(client::KrakenClient = Kraken.KrakenClient(Kraken.public_config); kw...)
    return ohlc(client, OhlcQuery(; kw...))
end

end
