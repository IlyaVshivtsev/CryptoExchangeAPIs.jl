module Underlying

export UnderlyingQuery,
    UnderlyingData,
    underlying

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Okx
using CryptoExchangeAPIs.Okx: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx InstType begin
    SWAP
    FUTURES
    OPTION
end

Base.@kwdef struct UnderlyingQuery <: OkxPublicQuery
    instType::InstType.T
end

"""
    underlying(client::OkxClient, query::UnderlyingQuery)
    underlying(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)

Returns available underlying assets for derivatives.

[`GET api/v5/public/underlying`](https://www.okx.com/docs-v5/en/#public-data-rest-api-get-underlying)

## Parameters:

| Parameter       | Type     | Required    | Description         |
|:----------------|:---------|:------------|:--------------------|
| instType        | InstType | true        | Instrument type:    |
|                 |          |             | SPOT, MARGIN, SWAP, |
|                 |          |             | FUTURES, OPTION     |

## Code samples:

```julia
using CryptoExchangeAPIs.Okx

result = Okx.API.V5.Public.underlying(;
    instType = Okx.API.V5.Public.Underlying.InstType.OPTION,
)
```
"""
function underlying(client::OkxClient, query::UnderlyingQuery)
    return APIsRequest{Data{Vector{String}}}("GET", "api/v5/public/underlying", query)(client)
end

function underlying(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)
    return underlying(client, UnderlyingQuery(; kw...))
end

end
