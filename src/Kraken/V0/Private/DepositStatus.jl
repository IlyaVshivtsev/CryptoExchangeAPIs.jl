module DepositStatus

export DepositStatusQuery,
    DepositStatusData,
    deposit_status

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct DepositStatusQuery <: KrakenPrivateQuery
    asset::String
    method::Maybe{String} = nothing

    nonce::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

@enumx StatusProp begin
    cancel_pending  # cancelation requested
    canceled        # canceled
    cancel_denied   # cancelation requested but was denied
    _return         # a return transaction initiated by Kraken; it cannot be canceled
    onhold          # withdrawal is on hold pending review
end

struct DepositStatusData <: KrakenData
    aclass::String
    amount::Float64
    asset::String
    fee::Float64
    info::String
    method::String
    refid::String
    status::String
    status_prop::Maybe{StatusProp.T}
    time::NanoDate
    txid::String
end

function Serde.deser(::Type{DepositStatusData}, ::Type{StatusProp.T}, x::String)::StatusProp.T
    x == "cancel-pending" && return StatusProp.cancel_pending
    x == "canceled"       && return StatusProp.canceled
    x == "cancel-denied"  && return StatusProp.cancel_denied
    x == "return"         && return StatusProp._return
    x == "onhold"         && return StatusProp.onhold
end

"""
    deposit_status(client::KrakenClient, query::DepositStatusQuery)
    deposit_status(client::KrakenClient; kw...)

Retrieve information about recent deposits. Any deposits initiated in the past 90 days will be included in the response.

[`POST 0/private/DepositStatus`](https://docs.kraken.com/rest/#tag/Funding/operation/getStatusRecentDeposits)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| asset     | String   | true     |             |
| method    | String   | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

result = Kraken.V0.Private.deposit_status(
    client;
    asset = "XBT",
)
```
"""
function deposit_status(client::KrakenClient, query::DepositStatusQuery)
    return APIsRequest{Data{Vector{DepositStatusData}}}("POST", "0/private/DepositStatus", query)(client)
end

function deposit_status(client::KrakenClient; kw...)
    return deposit_status(client, DepositStatusQuery(; kw...))
end

end

