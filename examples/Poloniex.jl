# Poloniex Examples
# https://api-docs.poloniex.com/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Poloniex

Poloniex.Markets.symbols()

Poloniex.Markets.symbols(; symbol = "BTC_USDT")

Poloniex.Markets.candles(
    interval = Poloniex.Markets.Candles.TimeInterval.h1
)

Poloniex.Markets.candles(
    interval = Poloniex.Markets.Candles.TimeInterval.m5,
    symbol = "ETH_USDT",
    startTime = now(UTC) - Day(6),
    endTime = now(UTC)
)

Poloniex.Markets.order_book(
    symbol = "ADA_USDT",
    limit = Poloniex.Markets.OrderBook.OrderBookLimit.TWENTY,
)

Poloniex.Markets.ticker24h()

Poloniex.Markets.ticker24h(; symbol = "BTC_USDT")


Poloniex.V2.currencies()
