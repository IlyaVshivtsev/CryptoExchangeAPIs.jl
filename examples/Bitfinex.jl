# Bitfinex Examples
# https://docs.bitfinex.com/docs/rest-public

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Bitfinex


Bitfinex.V2.book(;
    symbol = "tBTCUSD",
    precision = Bitfinex.V2.Book.Precision.P1,
    len = Bitfinex.V2.Book.BookLength.TWENTY_FIVE
)


Bitfinex.V2.candles(;
    timeframe = Bitfinex.V2.Candles.TimeInterval.h1,
    symbol = "tETHUSD",
    section = Bitfinex.V2.Candles.Section.last,
    limit = 50
)

Bitfinex.V2.candles(;
    timeframe = Bitfinex.V2.Candles.TimeInterval.d1,
    symbol = "tBTCUSD",
    start = now(UTC) - Month(1),
    _end = now(UTC),
)

Bitfinex.V2.tickers()

Bitfinex.V2.tickers(; symbols = "tBTCUSD")

Bitfinex.V2.tickers(; symbols = ["tBTCUSD", "tETHUSD", "tADAUSD"])

Bitfinex.V2.trades(;
    symbol = "tBTCUSD",
    start = now(UTC) - Hour(1),
    limit = 50
)

Bitfinex.V2.trades(;
    symbol = "tETHUSD",
    _end = now(UTC),
    limit = 100
)
