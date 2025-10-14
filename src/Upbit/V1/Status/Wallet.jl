module Wallet

export WalletQuery,
    WalletData,
    wallet

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Upbit
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx WalletState working withdraw_only deposit_only paused unsupported

@enumx BlockState normal delayed inactive

Base.@kwdef mutable struct WalletQuery <: UpbitPrivateQuery
    signature::Maybe{String} = nothing
end

struct WalletData <: UpbitData
    block_height::Maybe{Int64}
    block_state::Maybe{BlockState.T}
    block_updated_at::Maybe{NanoDate}
    block_elapsed_minutes::Maybe{Int64}
    currency::String
    net_type::String
    wallet_state::WalletState.T
    network_name::String
end

function Serde.deser(::Type{<:WalletData}, ::Type{<:Maybe{NanoDate}}, x::String)::NanoDate
    tz = ZonedDateTime(x, "yyyy-mm-ddTHH:MM:SS.ssszzzz")
    return NanoDate(DateTime(astimezone(tz, tz"UTC+0")))
end

"""
    wallet(client::UpbitClient, query::WalletQuery)
    wallet(client::UpbitClient; kw...)

Balance information.

[`GET v1/status/wallet`](https://docs.upbit.com/reference/입출금-현황)

## Code samples:

```julia
using CryptoExchangeAPIs.Upbit

upbit_client = UpbitClient(;
    base_url = "https://api.upbit.com",
    public_key = ENV["UPBIT_PUBLIC_KEY"],
    secret_key = ENV["UPBIT_SECRET_KEY"],
)

result = Upbit.V1.Status.wallet(upbit_client)
```
"""
function wallet(client::UpbitClient, query::WalletQuery)
    return APIsRequest{Vector{WalletData}}("GET", "v1/status/wallet", query)(client)
end

function wallet(client::UpbitClient; kw...)
    return wallet(client, WalletQuery(; kw...))
end

end

