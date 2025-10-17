Pkg.activate(@__DIR__);

using Dates
using BenchmarkTools
using CryptoExchangeAPIs.Binance

client = Binance.BinanceClient(Binance.public_config)

Binance.API.V3.klines(;
    symbol = "ADAUSDT",
    interval = Binance.API.V3.Klines.TimeInterval.m1,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 4,
)

# @btime Binance.API.V3.exchange_info(client) samples=1 evals=1
# @btime Binance.API.V3.exchange_info() samples=1 evals=1

Binance.API.V3.depth(; symbol = "BTCUSDT", limit = 10)

Binance.API.V3.ticker24hr()
Binance.API.V3.ticker24hr(; symbol = "BTCUSDT")
Binance.API.V3.ticker24hr(; symbols = ["BTCUSDT", "ADAUSDT"])

Binance.FAPI.V1.klines(;
    symbol = "BTCUSDT",
    interval = Binance.FAPI.V1.Klines.TimeInterval.m5,
)

Binance.FAPI.V1.exchange_info()

Binance.FAPI.V1.funding_rate(; symbol = "BTCUSDT")

Binance.FAPI.V1.depth(; symbol = "BTCUSDT")
Binance.FAPI.V1.depth(; symbol = "BTCUSDT", limit = 10)

Binance.FAPI.V1.ticker24hr(; symbol = "BTCUSDT")

Binance.Futures.Data.long_short_ratio(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.LongShortRatio.TimeInterval.h1,
)

Binance.Futures.Data.open_interest_hist(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.OpenInterestHist.TimeInterval.h1,
)

Binance.Futures.Data.taker_long_short_ratio(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.TakerLongShortRatio.TimeInterval.h1,
)
