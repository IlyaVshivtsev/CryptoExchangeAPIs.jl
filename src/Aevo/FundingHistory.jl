module FundingHistory

export FundingHistoryQuery,
    FundingHistoryData,
    funding_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Aevo
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingHistoryQuery <: AevoPublicQuery
    instrument_name::String
    start_time::Maybe{DateTime} = nothing
    end_time::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
end

struct FundingRecord <: AevoData
    instrument_name::String
    timestamp::NanoDate
    funding_rate::Float64
    mark_price::Float64
end 

struct FundingHistoryData <: AevoData
    funding_history::Vector{FundingRecord}
end

"""
    funding_history(client::AevoClient, query::FundingHistoryQuery)
    funding_history(client::AevoClient = Aevo.AevoClient(Aevo.public_config); kw...)

Returns the funding rate history for the instrument.

[`GET funding-history`](https://api-docs.aevo.xyz/reference/getfundinghistory)

## Code samples:

```julia
using CryptoExchangeAPIs.Aevo

result = Aevo.funding_history(; 
    instrument_name = "ETH-PERP",
)
```
"""
function funding_history(client::AevoClient, query::FundingHistoryQuery)
    return APIsRequest{FundingHistoryData}("GET", "funding-history", query)(client)
end

function funding_history(
    client::AevoClient = Aevo.AevoClient(Aevo.public_config);
    kw...,
)
    return funding_history(client, FundingHistoryQuery(; kw...))
end

end