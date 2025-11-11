module DepositMethods

export DepositMethodsQuery,
    DepositMethodsData,
    deposit_methods

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct DepositMethodsQuery <: KrakenPrivateQuery
    asset::String

    nonce::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct DepositMethodsData <: KrakenData
    method::String
    limit::Float64
    fee::Maybe{Float64}
    address_setup_fee::Maybe{String}
    gen_address::Maybe{Bool}
end

function Serde.custom_name(::Type{DepositMethodsData}, ::Val{:address_setup_fee})::String
    return "address-setup-fee"
end

function Serde.custom_name(::Type{DepositMethodsData}, ::Val{:gen_address})::String
    return "gen-address"
end

"""
    deposit_methods(client::KrakenClient, query::DepositMethodsQuery)
    deposit_methods(client::KrakenClient; kw...)

Retrieve methods available for depositing a particular asset.

[`POST 0/private/DepositMethods`](https://docs.kraken.com/rest/#tag/Funding/operation/getDepositMethods)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| asset     | String   | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

result = Kraken.V0.Private.deposit_methods(
    client;
    asset = "XBT",
)
```
"""
function deposit_methods(client::KrakenClient, query::DepositMethodsQuery)
    return APIsRequest{Data{Vector{DepositMethodsData}}}("POST", "0/private/DepositMethods", query)(client)
end

function deposit_methods(client::KrakenClient; kw...)
    return deposit_methods(client, DepositMethodsQuery(; kw...))
end

end

