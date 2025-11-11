module Candlesticks

export CandlesticksQuery,
    CandlesticksData,
    candlesticks

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval s10 m1 m5 m15 m30 h1 h4 h8 d1 d7 d30

Base.@kwdef struct CandlesticksQuery <: GateioPublicQuery
    currency_pair::String
    from::Maybe{DateTime} = nothing
    interval::Maybe{TimeInterval.T} = nothing
    limit::Maybe{Int64} = nothing
    to::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:CandlesticksQuery}, x::TimeInterval.T)::String
    x == TimeInterval.s10 && return "10s"
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h4  && return "4h"
    x == TimeInterval.h8  && return "8h"
    x == TimeInterval.d1  && return "1d"
    x == TimeInterval.d7  && return "7d"
    x == TimeInterval.d30 && return "30d"
end

struct CandlesticksData <: GateioData
    timestamp::Maybe{NanoDate}
    quote_volume::Maybe{Float64}
    close_price::Maybe{Float64}
    high_price::Maybe{Float64}
    low_price::Maybe{Float64}
    open_price::Maybe{Float64}
    base_amount::Maybe{Float64}
end

"""
    candlesticks(client::GateioClient, query::CandlesticksQuery)
    candlesticks(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

Market candlesticks.

[`GET api/v4/spot/candlesticks`](https://www.gate.io/docs/developers/apiv4/#market-candlesticks)

## Parameters:

| Parameter     | Type         | Required | Description                          |
|:--------------|:-------------|:---------|:-------------------------------------|
| currency_pair | String       | true     |                                      |
| from          | DateTime     | false    |                                      |
| interval      | TimeInterval | false    | s10 m1 m5 m15 m30 h1 h4 h8 d1 d7 d30 |
| limit         | Int64        | false    |                                      |
| _end          | DateTime     | false    |                                      |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Spot.candlesticks(;
    currency_pair = "BTC_USDT",
    interval = Gateio.API.V4.Spot.Candlesticks.TimeInterval.d1,
)
```
"""
function candlesticks(client::GateioClient, query::CandlesticksQuery)
    return APIsRequest{Vector{CandlesticksData}}("GET", "api/v4/spot/candlesticks", query)(client)
end

function candlesticks(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return candlesticks(client, CandlesticksQuery(; kw...))
end

end
