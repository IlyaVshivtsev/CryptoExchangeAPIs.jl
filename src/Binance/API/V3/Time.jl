module Time

export TimeQuery,
    TimeData

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TimeQuery <: BinancePublicQuery
    #__ empty
end

struct TimeData <: BinanceData
    serverTime::NanoDate
end

"""
    time(client::BinanceClient, query::TimeQuery)
    time(client::BinanceClient = Binance.BinanceClient(Binance.public_config); kw...)

Check current server time.

[`GET api/v3/time`](https://binance-docs.github.io/apidocs/spot/en/#check-server-time)

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.API.V3.time()
```
"""
function time(client::BinanceClient, query::TimeQuery)
    return APIsRequest{TimeData}("GET", "api/v3/time", query)(client)
end

function time(
    client::BinanceClient = Binance.BinanceClient(Binance.public_config);
    kw...,
)
    return time(client, TimeQuery(; kw...))
end

end

