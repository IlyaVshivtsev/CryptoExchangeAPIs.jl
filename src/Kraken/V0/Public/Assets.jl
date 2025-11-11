module Assets

export AssetsQuery,
    AssetsData,
    assets

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx AssetClass currency tokenized_asset

Base.@kwdef struct AssetsQuery <: KrakenPublicQuery
    asset::Maybe{Vector{String}} = nothing
    aclass::Maybe{AssetClass.T} = nothing
end

function Serde.SerQuery.ser_type(::Type{AssetsQuery}, x::Vector{String})::String
    return join(x, ",")
end

@enumx AssetStatus begin
    enabled
    deposit_only
    withdrawal_only
    funding_temporarily_disabled
end

struct AssetsData <: KrakenData
    aclass::AssetClass.T
    altname::String
    decimals::Int64
    display_decimals::Int64
    collateral_value::Maybe{Float64}
    status::AssetStatus.T
end

"""
    assets(client::KrakenClient, query::AssetsQuery)
    assets(client::KrakenClient = Kraken.KrakenClient(Kraken.public_config); kw...)

Get information about the assets that are available for deposit, withdrawal, trading and earn.

[`GET 0/public/Assets`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getAssetInfo)

## Parameters:

| Parameter | Type           | Required | Description |
|:----------|:---------------|:---------|:------------|
| asset     | Vector{String} | false    |             |
| aclass    | AssetClass     | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

result = Kraken.V0.Public.assets(;
    asset = ["ADA", "SUSHI"],
)
```
"""
function assets(client::KrakenClient, query::AssetsQuery)
    return APIsRequest{Data{Dict{String,AssetsData}}}("GET", "0/public/Assets", query)(client)
end

function assets(client::KrakenClient = Kraken.KrakenClient(Kraken.public_config); kw...)
    return assets(client, AssetsQuery(; kw...))
end

end

