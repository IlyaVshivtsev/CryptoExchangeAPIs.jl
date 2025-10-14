module MarketAll

export MarketAllQuery,
    MarketAllData,
    market_all

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Upbit
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct MarketAllQuery <: UpbitPublicQuery
    isDetails::Bool = true
end

struct Caution <: UpbitData 
    PRICE_FLUCTUATIONS::Maybe{Bool}
    TRADING_VOLUME_SOARING::Maybe{Bool}
    DEPOSIT_AMOUNT_SOARING::Maybe{Bool}
    GLOBAL_PRICE_DIFFERENCES::Maybe{Bool}
    CONCENTRATION_OF_SMALL_ACCOUNTS::Maybe{Bool}
end

struct MarketEvent <: UpbitData 
    warning::Maybe{Bool}
    caution::Maybe{Caution}
end

struct MarketAllData <: UpbitData
    market::String
    english_name::String
    korean_name::String
    market_event::Maybe{MarketEvent}
end

"""
    market_all(client::UpbitClient, query::MarketAllQuery)
    market_all(client::UpbitClient = Upbit.UpbitClient(Upbit.public_config); kw...)

Listing Market List

[`GET v1/market/all`](https://docs.upbit.com/reference/마켓-코드-조회)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| isDetails | Bool     | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Upbit

result = Upbit.V1.MarketAll.market_all()
```
"""
function market_all(client::UpbitClient, query::MarketAllQuery)
    return APIsRequest{Vector{MarketAllData}}("GET", "v1/market/all", query)(client)
end

function market_all(
    client::UpbitClient = Upbit.UpbitClient(Upbit.public_config);
    kw...,
)
    return market_all(client, MarketAllQuery(; kw...))
end

end
