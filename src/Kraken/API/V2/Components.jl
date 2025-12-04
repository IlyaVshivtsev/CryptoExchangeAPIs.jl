module Components

export ComponentsQuery,
    ComponentsData,
    components

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Status begin
    operational
    degraded_performance
    partial_outage
    major_outage
    under_maintenance
end

struct ComponentsQuery <: KrakenPublicQuery end

struct Page <: KrakenData
    id::String
    name::String
    time_zone::String
    updated_at::NanoDate
    url::String
end

struct Component <: KrakenData
    created_at::NanoDate
    description::Maybe{String}
    group::Bool
    group_id::Maybe{String}
    id::String
    name::String
    only_show_if_degraded::Bool
    page_id::String
    position::Int64
    showcase::Bool
    start_date::Maybe{Date}
    status::Status.T
    updated_at::NanoDate
end

struct ComponentsData <: KrakenData
    components::Vector{Component}
    page::Page
end

"""
    components(client::KrakenClient, query::ComponentsQuery)
    components(client::KrakenClient = Kraken.KrakenClient(Kraken.public_status_config); kw...)

Get the components for the page.

[`GET api/v2/public/components`](https://status.kraken.com/api)

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

result = Kraken.API.V2.Components.components()
```
"""
function components(client::KrakenClient, query::ComponentsQuery)
    return APIsRequest{ComponentsData}("GET", "api/v2/components.json", query)(client)
end

function components(
    client::KrakenClient = Kraken.KrakenClient(Kraken.public_status_config);
    kw...,
)
    return components(client, ComponentsQuery(; kw...))
end

end
