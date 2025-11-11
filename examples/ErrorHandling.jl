# ErrorHandling

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Binance

# NB: error_code number

CryptoExchangeAPIs.isretriable(::CryptoExchangeAPIs.APIsResult{BinanceAPIError{-1121}}) = true
CryptoExchangeAPIs.retry_maxcount(::CryptoExchangeAPIs.APIsResult{BinanceAPIError{-1121}}) = 2
CryptoExchangeAPIs.retry_timeout(::CryptoExchangeAPIs.APIsResult{BinanceAPIError{-1121}}) = 5

Binance.API.V3.klines(;
    symbol = "ADADADA",
    interval = Binance.API.V3.Klines.TimeInterval.m1,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 4,
)

using CryptoExchangeAPIs.Coinbase

# NB: error_code symbol

CryptoExchangeAPIs.isretriable(::CryptoExchangeAPIs.APIsResult{CoinbaseAPIError{Symbol("NotFound")}}) = true
CryptoExchangeAPIs.retry_maxcount(::CryptoExchangeAPIs.APIsResult{CoinbaseAPIError{Symbol("NotFound")}}) = 2
CryptoExchangeAPIs.retry_timeout(::CryptoExchangeAPIs.APIsResult{CoinbaseAPIError{Symbol("NotFound")}}) = 5

Coinbase.Products.candles(;
    granularity = Coinbase.Products.Candles.TimeInterval.m1,
    product_id = "ADA-ADA",
    start = now(UTC) - Hour(1),
    _end = now(UTC),
)
