module Ledgers

export LedgersQuery,
    LedgersData,
    ledgers

export LedgerType

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx AssetClass currency tokenized_asset

@enumx LedgerType begin
    all
    deposit
    withdrawal
    trade
    margin
    rollover
    credit
    transfer
    settled
    staking
    sale
end

Base.@kwdef mutable struct LedgersQuery <: KrakenPrivateQuery
    _end::Maybe{DateTime} = nothing
    aclass::Maybe{AssetClass.T} = nothing
    asset::Maybe{String} = nothing
    ofs::Maybe{Int64} = nothing
    start::Maybe{DateTime} = nothing
    type::Maybe{LedgerType.T} = nothing

    nonce::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct Ledger <: KrakenData
    aclass::Maybe{AssetClass.T}
    amount::Maybe{String}
    asset::Maybe{String}
    balance::Maybe{String}
    fee::Maybe{String}
    refid::Maybe{String}
    subtype::Maybe{String}
    time::NanoDate
    type::Maybe{String}
end

struct LedgersData <: KrakenData
    count::Int64
    ledger::Dict{String,Ledger}
end

"""
    ledgers(client::KrakenClient, query::LedgersQuery)
    ledgers(client::KrakenClient; kw...)

Retrieve information about ledger entries. 50 results are returned at a time, the most recent by default.

[`POST 0/private/Ledgers`](https://docs.kraken.com/rest/#tag/Account-Data/operation/getLedgers)

## Parameters:

| Parameter | Type       | Required | Description |
|:----------|:-----------|:---------|:------------|
| _end      | DateTime   | false    |             |
| aclass    | AssetClass | false    |             |
| asset     | String     | false    |             |
| ofs       | Int64      | false    |             |
| start     | DateTime   | false    |             |
| type      | LedgerType | false    | `all` `deposit` `withdrawal` `trade` `margin` `rollover` `credit` `transfer` `settled` `staking` `sale` |

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

result = Kraken.V0.Private.ledgers(
    client;
    type = Kraken.V0.Private.Ledgers.LedgerType.margin,
    asset = "XBT",
    start = DateTime("2021-04-03T15:33:20"),
    _end = DateTime("2022-04-03T15:33:20"),
)
```
"""
function ledgers(client::KrakenClient, query::LedgersQuery)
    return APIsRequest{Data{LedgersData}}("POST", "0/private/Ledgers", query)(client)
end

function ledgers(client::KrakenClient; kw...)
    return ledgers(client, LedgersQuery(; kw...))
end

end

