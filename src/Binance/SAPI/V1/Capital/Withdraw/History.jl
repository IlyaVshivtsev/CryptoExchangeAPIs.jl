module History

export HistoryQuery,
    HistoryData,
    history

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx WithdrawStatus begin
    EMAIL_SENT = 0
    CANCELLED = 1
    AWAITING_APPROVAL = 2
    REJECTED = 3
    PROCESSING = 4
    FAILURE = 5
    COMPLETED = 6
end

Base.@kwdef mutable struct HistoryQuery <: BinancePrivateQuery
    coin::Maybe{String} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = 1000
    offset::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
    status::Maybe{WithdrawStatus.T} = nothing
    withdrawOrderId::Maybe{String} = nothing

    recvWindow::Maybe{Int64} = nothing
    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

function Serde.SerQuery.ser_type(::Type{<:HistoryQuery}, x::WithdrawStatus.T)::Int64
    return Int64(x)
end

struct HistoryData <: BinanceData
    address::String
    amount::Float64
    applyTime::NanoDate
    coin::String
    confirmNo::Maybe{Int64}
    id::String
    info::String
    network::String
    status::WithdrawStatus.T
    transactionFee::Float64
    transferType::Int64
    txId::Maybe{String}
    txKey::Maybe{String}
    walletType::Int64
    completeTime::Maybe{NanoDate}
end

"""
    history(client::BinanceClient, query::HistoryQuery)
    history(client::BinanceClient; kw...)

Fetch withdraw history.

[`GET sapi/v1/capital/withdraw/history`](https://binance-docs.github.io/apidocs/spot/en/#withdraw-history-supporting-network-user_data)

## Parameters:

| Parameter       | Type           | Required | Description                                                                                                        |
|:----------------|:---------------|:---------|:-------------------------------------------------------------------------------------------------------------------|
| coin            | String         | false    |                                                                                                                    |
| endTime         | DateTime       | false    |                                                                                                                    |
| limit           | Int64          | false    | Default: 1000                                                                                                      |
| offset          | Int64          | false    |                                                                                                                    |
| startTime       | DateTime       | false    |                                                                                                                    |
| status          | WithdrawStatus | false    | EMAIL\\_SENT (0), CANCELLED (1), AWAITING\\_APPROVAL (2), REJECTED (3), PROCESSING (4), FAILURE (5), COMPLETED (6) |
| withdrawOrderId | String         | false    |                                                                                                                    |
| recvWindow      | Int64          | false    |                                                                                                                    |
| signature       | String         | false    |                                                                                                                    |
| timestamp       | DateTime       | false    |                                                                                                                    |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

binance_client = BinanceClient(;
    base_url = "https://api.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

result = Binance.SAPI.V1.Capital.Withdraw.history(binance_client)
```
"""
function history(client::BinanceClient, query::HistoryQuery)
    return APIsRequest{Vector{HistoryData}}("GET", "sapi/v1/capital/withdraw/history", query)(client)
end

function history(client::BinanceClient; kw...)
    return history(client, HistoryQuery(; kw...))
end

end 
