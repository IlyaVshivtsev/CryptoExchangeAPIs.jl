module GetFundingRateHistory

export GetFundingRateHistoryQuery,
    GetFundingRateHistoryData,
    get_funding_rate_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Deribit
using CryptoExchangeAPIs.Deribit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct GetFundingRateHistoryQuery <: DeribitPublicQuery
    end_timestamp::DateTime
    instrument_name::String
    start_timestamp::DateTime
end

struct GetFundingRateHistoryData <: DeribitData
    index_price::Float64
    interest_1h::Float64
    interest_8h::Float64
    prev_index_price::Maybe{Float64}
    timestamp::NanoDate
end

"""
    get_funding_rate_history(client::DeribitClient, query::GetFundingRateHistoryQuery)
    get_funding_rate_history(client::DeribitClient = Deribit.DeribitClient(Deribit.public_config); kw...)

Retrieves hourly historical interest rate for requested PERPETUAL instrument.

[`GET api/v2/public/get_funding_rate_history`](https://docs.deribit.com/#public-get_funding_rate_history)

## Parameters:

| Parameter       | Type     | Required | Description |
|:----------------|:---------|:---------|:------------|
| end_timestamp   | DateTime | true     |             |
| instrument_name | String   | true     |             |
| start_timestamp | DateTime | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Deribit

result = Deribit.API.V2.Public.get_funding_rate_history(;
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = DateTime("2022-11-08"),
    end_timestamp = DateTime("2022-11-08") + Day(2),
)
```
"""
function get_funding_rate_history(client::DeribitClient, query::GetFundingRateHistoryQuery)
    return APIsRequest{Data{Vector{GetFundingRateHistoryData}}}("GET", "api/v2/public/get_funding_rate_history", query)(client)
end

function get_funding_rate_history(
    client::DeribitClient = Deribit.DeribitClient(Deribit.public_config);
    kw...
)
    return get_funding_rate_history(client, GetFundingRateHistoryQuery(; kw...))
end

end

