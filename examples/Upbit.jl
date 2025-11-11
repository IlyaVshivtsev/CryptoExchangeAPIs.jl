# Upbit Examples
# https://docs.upbit.com/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Upbit

upbit_client = UpbitClient(;
    base_url = "https://api.upbit.com",
    public_key = get(ENV, "UPBIT_PUBLIC_KEY", ""),
    secret_key = get(ENV, "UPBIT_SECRET_KEY", ""),
)

Upbit.V1.Market.all()

Upbit.V1.Market.all(; isDetails = false)

Upbit.V1.Candles.days(; market = "KRW-BTC")

Upbit.V1.Candles.days(
    market = "BTC-ETH",
    count = 50,
    to = now(UTC)
)

Upbit.V1.Ticker.all(; quoteCurrencies = "KRW")

Upbit.V1.Ticker.by_pairs(; markets = "KRW-BTC")

Upbit.V1.Ticker.by_pairs(; markets = ["KRW-BTC", "KRW-ETH"])

Upbit.V1.orderbook(; markets = "KRW-BTC")

Upbit.V1.orderbook(; markets = ["KRW-BTC", "KRW-ETH"])

Upbit.V1.Status.wallet(upbit_client)
