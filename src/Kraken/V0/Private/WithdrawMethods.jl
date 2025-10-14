module WithdrawMethods

export WithdrawMethodsQuery,
    WithdrawMethodsData,
    withdraw_methods

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct WithdrawMethodsQuery <: KrakenPrivateQuery
    asset::Maybe{String} = nothing
    aclass::Maybe{String} = nothing
    network::Maybe{String} = nothing

    nonce::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct WithdrawMethodsData <: KrakenData
    asset::String
    method::String
    network::String
    minimum::Float64
end

"""
    withdraw_methods(client::KrakenClient, query::WithdrawMethodsQuery)
    withdraw_methods(client::KrakenClient; kw...)

Retrieve a list of withdrawal methods available for the user.

[`POST 0/private/WithdrawMethods`](https://docs.kraken.com/rest/#tag/Funding/operation/getWithdrawalMethods)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| asset     | String   | false    |             |
| aclass    | String   | false    |             |
| network   | String   | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

result = Kraken.V0.Private.withdraw_methods(
    client;
    asset = "XBT"
)
```
"""
function withdraw_methods(client::KrakenClient, query::WithdrawMethodsQuery)
    return APIsRequest{Data{Vector{WithdrawMethodsData}}}("POST", "0/private/WithdrawMethods", query)(client)
end

function withdraw_methods(client::KrakenClient; kw...)
    return withdraw_methods(client, WithdrawMethodsQuery(; kw...))
end

end

