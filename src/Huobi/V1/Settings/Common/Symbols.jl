module Symbols

export SymbolsQuery,
    SymbolsData,
    symbols

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct SymbolsQuery <: HuobiPublicQuery
    ts::Maybe{Int64} = nothing
end

struct SymbolsData <: HuobiData
    symbol::Maybe{String}
    bcdn::Maybe{String}
    qcdn::Maybe{String}
    bc::Maybe{String}
    qc::Maybe{String}
    state::Maybe{String}
    cd::Maybe{Bool}
    te::Maybe{Bool}
    toa::Maybe{NanoDate}
    sp::Maybe{String}
    w::Maybe{Int64}
    ttp::Maybe{Float64}
    tap::Maybe{Float64}
    tpp::Maybe{Float64}
    fp::Maybe{Float64}
    tags::Maybe{String}
    d::Maybe{Int64}
    elr::Maybe{String}
end

"""
    symbols(client::HuobiClient, query::SymbolsQuery)
    symbols(client::HuobiClient = Huobi.HuobiClient(Huobi.public_config); kw...)

Get all Supported Trading Symbol.

[`GET v1/settings/common/symbols`](https://www.htx.com/en-in/opend/newApiPages/?id=7ec51cb5-7773-11ed-9966-0242ac110003)

| Parameter     | Type       | Required | Description |
|:--------------|:-----------|:---------|:------------|
| ts            | Int64      | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Huobi

result = Huobi.V1.Settings.Common.symbols()
```
"""
function symbols(client::HuobiClient, query::SymbolsQuery)
    return APIsRequest{Data{Vector{SymbolsData}}}("GET", "v1/settings/common/symbols", query)(client)
end

function symbols(client::HuobiClient = Huobi.HuobiClient(Huobi.public_config); kw...)
    return symbols(client, SymbolsQuery(; kw...))
end

end
