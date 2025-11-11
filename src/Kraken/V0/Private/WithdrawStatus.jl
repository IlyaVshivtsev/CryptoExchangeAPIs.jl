module WithdrawStatus

export WithdrawStatusQuery,
    WithdrawStatusData,
    withdraw_status

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct WithdrawStatusQuery <: KrakenPrivateQuery
    asset::String
    method::Maybe{String} = nothing

    nonce::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

@enumx Status Initial Pending Settled Success Failure

struct WithdrawStatusData <: KrakenData
    aclass::String
    amount::Float64
    asset::String
    fee::Float64
    info::String
    method::String
    refid::String
    status::Status.T
    status_prop::Maybe{Status.T}
    time::NanoDate
    txid::String
end

"""
    withdraw_status(client::KrakenClient, query::WithdrawStatusQuery)
    withdraw_status(client::KrakenClient; kw...)

Retrieve information about recent withdrawals.

[`POST 0/private/WithdrawStatus`](https://docs.kraken.com/rest/#tag/Funding/operation/getStatusRecentWithdrawals)

## Parameters:

| Parameter | Type       | Required | Description |
|:----------|:-----------|:---------|:------------|
| asset     | String     | true     |             |
| method    | String     | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

result = Kraken.V0.Private.withdraw_status(
    client;
    asset = "XBT"
)
```
"""
function withdraw_status(client::KrakenClient, query::WithdrawStatusQuery)
    return APIsRequest{Data{Vector{WithdrawStatusData}}}("POST", "0/private/WithdrawStatus", query)(client)
end

function withdraw_status(client::KrakenClient; kw...)
    return withdraw_status(client, WithdrawStatusQuery(; kw...))
end

end

