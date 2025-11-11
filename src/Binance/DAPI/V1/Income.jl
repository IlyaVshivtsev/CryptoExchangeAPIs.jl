module Income

export IncomeQuery,
    IncomeData,
    income

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct IncomeQuery <: BinancePrivateQuery
    symbol::Maybe{String} = nothing
    incomeType::Maybe{String} = nothing
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing

    recvWindow::Maybe{Int64} = nothing
    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct IncomeData <: BinanceData
    symbol::Maybe{String}
    incomeType::String
    info::Maybe{String}
    income::Float64
    asset::String
    time::NanoDate
    tranId::Int64
    tradeId::Maybe{String}
end

function Serde.isempty(::Type{IncomeData}, x)::Bool
    return x === ""
end

"""
    income(client::BinanceClient, query::IncomeQuery)
    income(client::BinanceClient; kw...)

Get income history.

[`GET dapi/v1/income`](https://binance-docs.github.io/apidocs/delivery/en/#get-income-history-user_data)

## Parameters:

| Parameter  | Type     | Required | Description |
|:-----------|:---------|:---------|:------------|
| symbol     | String   | false    |             |
| incomeType | String   | false    |             |
| startTime  | DateTime | false    |             |
| endTime    | DateTime | false    |             |
| limit      | Int64    | false    |             |
| recvWindow | Int64    | false    |             |
| timestamp  | DateTime | false    |             |
| signature  | String   | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

binance_client = BinanceClient(;
    base_url = "https://dapi.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

result = Binance.DAPI.V1.income(binance_client)
```
"""
function income(client::BinanceClient, query::IncomeQuery)
    return APIsRequest{Vector{IncomeData}}("GET", "dapi/v1/income", query)(client)
end

function income(client::BinanceClient; kw...)
    return income(client, IncomeQuery(; kw...))
end

end

