module HistDeposits

export HistDepositsQuery,
    HistDepositsData,
    hist_deposits

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data, Page
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Status PROCESSING SUCCESS FAILURE

Base.@kwdef mutable struct HistDepositsQuery <: KucoinPrivateQuery
    currency::Maybe{String} = nothing
    endAt::Maybe{DateTime} = nothing
    startAt::Maybe{DateTime} = nothing
    status::Maybe{Status.T} = nothing

    passphrase::Maybe{String} = nothing
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct HistDepositsData <: KucoinData
    amount::Float64
    createAt::NanoDate
    currency::String
    isInner::Bool
    status::String
    walletTxId::String
end

"""
    hist_deposits(client::KucoinClient, query::HistDepositsQuery)
    hist_deposits(client::KucoinClient; kw...)

Request via this endpoint to get the V1 historical deposits list on KuCoin.

[`GET api/v1/hist-deposits`](https://www.kucoin.com/docs/rest/funding/deposit/get-v1-historical-deposits-list)

## Parameters:

| Parameter  | Type     | Required | Description                  |
|:-----------|:---------|:---------|:-----------------------------|
| currency   | String   | false    |                              |
| endAt      | DateTime | false    |                              |
| startAt    | DateTime | false    |                              |
| status     | Status   | false    | PROCESSING, SUCCESS, FAILURE |

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin

kucoin_client = KucoinClient(;
    base_url = "https://api.kucoin.com",
    public_key = ENV["KUCOIN_PUBLIC_KEY"],
    secret_key = ENV["KUCOIN_SECRET_KEY"],
    passphrase = ENV["KUCOIN_PASSPHRASE"],
)

result = Kucoin.API.V1.hist_deposits(
    kucoin_client;
    currency = "BTC",
)
```
"""
function hist_deposits(client::KucoinClient, query::HistDepositsQuery)
    return APIsRequest{Data{Page{HistDepositsData}}}("GET", "api/v1/hist-deposits", query)(client)
end

function hist_deposits(client::KucoinClient; kw...)
    return hist_deposits(client, HistDepositsQuery(; kw...))
end

end

