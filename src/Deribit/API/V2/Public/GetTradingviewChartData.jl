module GetTradingviewChartData

export GetTradingviewChartDataQuery,
    GetTradingviewChartDataData,
    get_tradingview_chart_data

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Deribit
using CryptoExchangeAPIs.Deribit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m3 m5 m10 m15 m30 h1 h2 h3 h6 h12 d1

Base.@kwdef struct GetTradingviewChartDataQuery <: DeribitPublicQuery
    end_timestamp::DateTime
    instrument_name::String
    resolution::TimeInterval.T
    start_timestamp::DateTime
end

function Serde.ser_type(::Type{<:GetTradingviewChartDataQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1"
    x == TimeInterval.m3  && return "3"
    x == TimeInterval.m5  && return "5"
    x == TimeInterval.m10 && return "10"
    x == TimeInterval.m15 && return "15"
    x == TimeInterval.m30 && return "30"
    x == TimeInterval.h1  && return "60"
    x == TimeInterval.h2  && return "120"
    x == TimeInterval.h3  && return "180"
    x == TimeInterval.h6  && return "360"
    x == TimeInterval.h12 && return "720"
    x == TimeInterval.d1  && return "1D"
end

struct GetTradingviewChartDataData <: DeribitData
    close::Vector{Float64}
    cost::Vector{Float64}
    high::Vector{Float64}
    low::Vector{Float64}
    open::Vector{Float64}
    status::String
    ticks::Vector{NanoDate}
    volume::Vector{Float64}
end

"""
    get_tradingview_chart_data(client::DeribitClient, query::GetTradingviewChartDataQuery)
    get_tradingview_chart_data(client::DeribitClient = Deribit.DeribitClient(Deribit.public_config); kw...)

Publicly available market data used to generate a TradingView get_tradingview_chart_data chart.

[`GET api/v2/public/get_tradingview_chart_data`](https://docs.deribit.com/#public-get_tradingview_chart_data)

## Parameters:

| Parameter       | Type         | Required | Description                             |
|:----------------|:-------------|:---------|:----------------------------------------|
| end_timestamp   | DateTime     | true     |                                         |
| instrument_name | String       | true     |                                         |
| resolution      | TimeInterval | true     | m1 m3 m5 m10 m15 m30 h1 h2 h3 h6 h12 d1 |
| start_timestamp | DateTime     | true     |                                         |

## Code samples:

```julia
using CryptoExchangeAPIs.Deribit

result = Deribit.API.V2.Public.get_tradingview_chart_data(;
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = now(UTC) - Minute(100),
    end_timestamp = now(UTC) - Hour(1),
    resolution = Deribit.API.V2.Public.GetTradingviewChartData.TimeInterval.m1,
)
```
"""
function get_tradingview_chart_data(client::DeribitClient, query::GetTradingviewChartDataQuery)
    return APIsRequest{Data{GetTradingviewChartDataData}}("GET", "api/v2/public/get_tradingview_chart_data", query)(client)
end

function get_tradingview_chart_data(
    client::DeribitClient = Deribit.DeribitClient(Deribit.public_config);
    kw...,
)
    return get_tradingview_chart_data(client, GetTradingviewChartDataQuery(; kw...))
end

end
