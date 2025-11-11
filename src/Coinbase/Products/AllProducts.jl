module AllProducts

export AllProductsQuery,
    AllProductsData,
    all_products

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Coinbase
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Status online offline internal delisted

Base.@kwdef struct AllProductsQuery <: CoinbasePublicQuery
    type::Maybe{String} = nothing
end

struct AllProductsData <: CoinbaseData
    id::String
    base_currency::String
    quote_currency::String
    quote_increment::Float64
    base_increment::Float64
    display_name::String
    min_market_funds::Float64
    margin_enabled::Bool
    post_only::Bool
    limit_only::Bool
    cancel_only::Bool
    status::Status.T
    status_message::Maybe{String}
    trading_disabled::Maybe{Bool}
    fx_stablecoin::Maybe{Bool}
    max_slippage_percentage::Maybe{Float64}
    auction_mode::Bool
    high_bid_limit_percentage::Maybe{Float64}
end

function Serde.isempty(::Type{<:AllProductsData}, x)::Bool
    return x === ""
end

"""
    all_products(client::CoinbaseClient, query::AllProductsQuery)
    all_products(client::CoinbaseClient = Coinbase.CoinbaseClient(Coinbase.public_config); kw...)

Gets a list of available currency pairs for trading.

[`GET products`](https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getproducts)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| type      | String   | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Coinbase

result = Coinbase.Products.all_products(;
    type = "ADA-USDT",
)
```
"""
function all_products(client::CoinbaseClient, query::AllProductsQuery)
    return APIsRequest{Vector{AllProductsData}}("GET", "products", query)(client)
end

function all_products(
    client::CoinbaseClient = Coinbase.CoinbaseClient(Coinbase.public_config);
    kw...,
)
    return all_products(client, AllProductsQuery(; kw...))
end

end
