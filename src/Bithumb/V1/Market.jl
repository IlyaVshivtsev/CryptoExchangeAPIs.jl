module Market

export MarketQuery,
    MarketData,
    market

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bithumb
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct MarketQuery <: BithumbPublicQuery
    isDetails::Bool = false
end

struct MarketData <: BithumbData
    market::String
    korean_name::String
    english_name::String
end

"""
    market(client::BithumbClient, query::MarketQuery)
    market(client::BithumbClient = Bithumb.BithumbClient(Bithumb.public_config); kw...)

List of markets available for trading on Bithumb.

[`GET v1/market/all`](https://apidocs.bithumb.com/reference/)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| isDetails | Bool   | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Bithumb

result = Bithumb.V1.market()
```
"""
function market(client::BithumbClient, query::MarketQuery)
    return APIsRequest{Vector{MarketData}}("GET", "v1/market/all", query)(client)
end

function market(
    client::BithumbClient = Bithumb.BithumbClient(Bithumb.public_config);
    kw...
)
    return market(client, MarketQuery(; kw...))
end

end

