# Okex Examples
# https://www.okx.com/docs-v5/en/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Okex


Okex.API.V5.Public.instruments(
    instType = Okex.API.V5.Public.Instruments.InstType.SWAP
)

Okex.API.V5.Public.instruments(
    instType = Okex.API.V5.Public.Instruments.InstType.SPOT,
    instId = "BTC-USD"
)

Okex.API.V5.Public.instruments(
    instType = Okex.API.V5.Public.Instruments.InstType.OPTION,
    uly = "BTC-USD"
)

Okex.API.V5.Market.tickers(
    instType = Okex.API.V5.Market.Tickers.InstType.SPOT,
)

Okex.API.V5.Market.tickers(
    instType = Okex.API.V5.Market.Tickers.InstType.FUTURES,
    instFamily = "BTC-USD"
)

Okex.API.V5.Market.tickers(
    instType = Okex.API.V5.Market.Tickers.InstType.OPTION,
    uly = "ETH-USD"
)

Okex.API.V5.Market.candles(instId = "BTC-USDT")

Okex.API.V5.Market.candles(
    instId = "BTC-USDT",
    bar = Okex.API.V5.Market.Candles.TimeInterval.d1,
    after = now(UTC) - Day(6),
    before = now(UTC)
)
