module Multichain

export MultichainQuery,
    MultichainData,
    multichain

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bithumb
using CryptoExchangeAPIs.Bithumb: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct MultichainQuery <: BithumbPublicQuery
    currency::Maybe{String} = "ALL"
end

Serde.SerQuery.ser_ignore_field(::Type{MultichainQuery}, ::Val{:currency}) = true

struct MultichainData <: BithumbData
    currency::String
    net_type::String
    deposit_status::Bool
    withdrawal_status::Bool
end

"""
    multichain(client::BithumbClient, query::MultichainQuery)
    multichain(client::BithumbClient = Bithumb.BithumbClient(Bithumb.public_config); kw...)

Provides information on the deposit/withdrawal status of virtual assets.

[`GET /public/assetsstatus/multichain/{currency}`](https://apidocs.bithumb.com/reference/%EC%9E%85%EC%B6%9C%EA%B8%88-%EC%A7%80%EC%9B%90-%ED%98%84%ED%99%A9)

## Parameters:

| Parameter | Type         | Required | Description    |
|:----------|:-------------|:---------|:---------------|
| currency  | String       | false    | Default: "ALL" |

## Code samples:

```julia
using CryptoExchangeAPIs.Bithumb

result = Bithumb.Public.AssetsStatus.Multichain.multichain(; 
    currency = "ADA",
)
```
"""
function multichain(client::BithumbClient, query::MultichainQuery)
    return APIsRequest{Data{Vector{MultichainData}}}("GET", "public/assetsstatus/multichain/$(query.currency)", query)(client)
end

function multichain(
    client::BithumbClient = Bithumb.BithumbClient(Bithumb.public_config);
    kw...
)
    return multichain(client, MultichainQuery(; kw...))
end

end
