module FundingRates

export FundingRatesQuery,
    FundingRatesData,
    funding_rates

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingRatesQuery <: KucoinPublicQuery
    symbol::String
    from::NanoDate
    to::NanoDate
end

struct FundingRatesData <: KucoinData
    symbol::String
    timepoint::Maybe{NanoDate}
    fundingRate::Maybe{Float64}
end

"""
    funding_rates(client::KucoinClient, query::FundingRatesQuery)
    funding_rates(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_futures_config); kw...)

Query the funding rate at each settlement time point within a certain time range of the corresponding contract.

[`GET api/v1/contract/funding-rates`](https://www.kucoin.com/docs/rest/futures-trading/funding-fees/get-public-funding-history)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | true     |             |
| from      | NanoDate | true     |             |
| to        | NanoDate | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin
using NanoDates

result = Kucoin.API.V1.Contract.funding_rates(;
    symbol = "XBTUSDTM",
    from = NanoDate("2023-11-18T12:31:40"),
    to = NanoDate("2023-12-11T16:05:00"),
)
```
"""
function funding_rates(client::KucoinClient, query::FundingRatesQuery)
    return APIsRequest{Data{Vector{FundingRatesData}}}("GET", "api/v1/contract/funding-rates", query)(client)
end

function funding_rates(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_futures_config); kw...)
    return funding_rates(client, FundingRatesQuery(; kw...))
end

end

