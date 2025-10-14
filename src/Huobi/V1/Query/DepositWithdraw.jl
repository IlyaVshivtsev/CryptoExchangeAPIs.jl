module DepositWithdraw

export DepositWithdrawQuery,
    DepositWithdrawData,
    deposit_withdraw

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx DirectQuery prev next

Base.@kwdef mutable struct DepositWithdrawQuery <: HuobiPrivateQuery
    AccessKeyId::Maybe{String} = nothing
    Signature::Maybe{String} = nothing
    SignatureMethod::Maybe{String} = nothing
    SignatureVersion::Maybe{String} = nothing
    Timestamp::Maybe{DateTime} = nothing

    currency::Maybe{String} = nothing
    direct::Maybe{DirectQuery.T} = nothing
    from::Maybe{String} = nothing
    size::Maybe{Int64} = nothing
    type::String
end

struct DepositWithdrawData <: HuobiData
    address::Maybe{String}
    address_tag::Maybe{String}
    amount::Maybe{Int64}
    chain::Maybe{String}
    created_at::NanoDate
    currency::Maybe{String}
    fee::Maybe{Int64}
    from_addr_tag::Maybe{String}
    id::Int64
    state::Maybe{String}
    sub_type::Maybe{String}
    tx_hash::Maybe{String}
    type::Maybe{String}
    updated_at::Maybe{NanoDate}
end

"""
    deposit_withdraw(client::HuobiClient, query::DepositWithdrawQuery)
    deposit_withdraw(client::HuobiClient; kw...)

Parent user and sub user search for all existed withdraws and deposits and return their latest status.

[`GET v1/query/deposit-withdraw`](https://huobiapi.github.io/docs/spot/v1/en/#search-for-existed-withdraws-and-deposits)

## Parameters:

| Parameter        | Type        | Required | Description   |
|:-----------------|:------------|:---------|:--------------|
| type             | String      | true     |               |
| currency         | String      | false    |               |
| direct           | DirectQuery | false    | `prev` `next` |
| from             | String      | false    |               |
| size             | Int64       | false    |               |

## Code samples:

```julia
using CryptoExchangeAPIs.Huobi

client = HuobiClient(;
    base_url = "https://api.huobi.pro",
    public_key = ENV["HUOBI_PUBLIC_KEY"],
    secret_key = ENV["HUOBI_SECRET_KEY"],
)

result = Huobi.V1.Query.deposit_withdraw(
    client;
    currency = "usdt",
    from = "1",
    size = 500,
    type = "withdraw",
)
```
"""
function deposit_withdraw(client::HuobiClient, query::DepositWithdrawQuery)
    return APIsRequest{Data{DepositWithdrawData}}("GET", "v1/query/deposit-withdraw", query)(client)
end

function deposit_withdraw(client::HuobiClient; kw...)
    return deposit_withdraw(client, DepositWithdrawQuery(; kw...))
end

end

