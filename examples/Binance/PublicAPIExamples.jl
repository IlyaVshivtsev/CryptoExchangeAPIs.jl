# Binance public API coverage across spot, USD-M futures, coin-M futures, and global metrics.

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Binance

import CryptoExchangeAPIs: cex_result

spot_client = Binance.BinanceClient(Binance.public_config)
usd_futures_client = Binance.BinanceClient(Binance.public_fapi_config)
coin_futures_client = Binance.BinanceClient(Binance.public_dapi_config)

now_utc = now(UTC)
one_hour_ago = now_utc - Hour(1)

function safe_first(xs)
    return isempty(xs) ? nothing : xs[1]
end

println("== Spot API v3 ==")
spot_server_time = cex_result(Binance.API.V3.time(spot_client))
println("Server time (ns): ", spot_server_time.serverTime)

spot_exchange_info = cex_result(Binance.API.V3.exchange_info(; symbol = "BTCUSDT"))
println("Exchange info symbols returned: ", length(spot_exchange_info.symbols))

spot_depth = cex_result(Binance.API.V3.depth(; symbol = "BTCUSDT", limit = 10))
spot_top_ask = safe_first(spot_depth.asks)
spot_top_bid = safe_first(spot_depth.bids)
println(
    "Depth top ask: ",
    isnothing(spot_top_ask) ? "n/a" : string(spot_top_ask.price),
    " | top bid: ",
    isnothing(spot_top_bid) ? "n/a" : string(spot_top_bid.price),
)

spot_avg_price = cex_result(Binance.API.V3.avg_price(; symbol = "BTCUSDT"))
println("Average price: ", spot_avg_price.price)

spot_klines = cex_result(
    Binance.API.V3.klines(; symbol = "BTCUSDT",
        interval = Binance.API.V3.Klines.TimeInterval.m1,
        startTime = one_hour_ago,
        endTime = now_utc,
        limit = 5,
    ),
)
if !isempty(spot_klines)
    println("Spot klines fetched: ", length(spot_klines), " | first close: ", spot_klines[1].closePrice)
else
    println("Spot klines fetched: 0")
end

spot_ticker = cex_result(Binance.API.V3.ticker24hr(; symbol = "BTCUSDT"))
println("24h ticker change %: ", spot_ticker.priceChangePercent)

spot_multi_ticker = cex_result(
    Binance.API.V3.ticker24hr(; symbols = ["BTCUSDT", "ETHUSDT"]),
)
println(
    "24h tickers (multi): ",
    isempty(spot_multi_ticker) ? [] : [t.symbol for t in spot_multi_ticker],
)

println("\n== USD-M Futures FAPI v1 ==")
usd_depth = cex_result(
    Binance.FAPI.V1.depth(usd_futures_client; symbol = "BTCUSDT", limit = 10),
)
usd_top_bid = safe_first(usd_depth.bids)
println(
    "USD-M order book top bid: ",
    isnothing(usd_top_bid) ? "n/a" : string(usd_top_bid.price),
)

usd_exchange_info = cex_result(Binance.FAPI.V1.exchange_info(usd_futures_client))
println("USD-M symbols available: ", length(usd_exchange_info.symbols))

usd_klines = cex_result(
    Binance.FAPI.V1.klines(usd_futures_client;
        symbol = "BTCUSDT",
        interval = Binance.FAPI.V1.Klines.TimeInterval.m5,
        startTime = one_hour_ago,
        endTime = now_utc,
        limit = 5,
    ),
)
if !isempty(usd_klines)
    println("USD-M klines fetched: ", length(usd_klines), " | first high: ", usd_klines[1].highPrice)
else
    println("USD-M klines fetched: 0")
end

usd_continuous = cex_result(
    Binance.FAPI.V1.continuous_klines(usd_futures_client;
        pair = "BTCUSDT",
        contractType = Binance.FAPI.V1.ContinuousKlines.ContractType.PERPETUAL,
        interval = Binance.FAPI.V1.ContinuousKlines.TimeInterval.m5,
        limit = 5,
    ),
)
println("USD-M continuous klines fetched: ", length(usd_continuous))

usd_historical = cex_result(
    Binance.FAPI.V1.historical_trades(usd_futures_client;
        symbol = "BTCUSDT",
        limit = 10,
    ),
)
println("USD-M historical trades fetched: ", length(usd_historical))

usd_funding = cex_result(
    Binance.FAPI.V1.funding_rate(usd_futures_client;
        symbol = "BTCUSDT",
        limit = 5,
    ),
)
println("USD-M funding rate samples: ", length(usd_funding))

usd_premium = cex_result(Binance.FAPI.V1.premium_index(usd_futures_client; symbol = "BTCUSDT"))
println("USD-M mark price: ", usd_premium.markPrice)

usd_ticker = cex_result(Binance.FAPI.V1.ticker24hr(usd_futures_client; symbol = "BTCUSDT"))
println("USD-M 24h price change %: ", usd_ticker.priceChangePercent)

println("\n== Coin-M Futures DAPI v1 ==")
coin_depth = cex_result(
    Binance.DAPI.V1.depth(coin_futures_client; symbol = "BTCUSD_PERP", limit = 10),
)
coin_top_bid = safe_first(coin_depth.bids)
println(
    "Coin-M order book top bid: ",
    isnothing(coin_top_bid) ? "n/a" : string(coin_top_bid.price),
)

coin_exchange_info = cex_result(Binance.DAPI.V1.exchange_info(coin_futures_client))
println("Coin-M symbols available: ", length(coin_exchange_info.symbols))

coin_klines = cex_result(
    Binance.DAPI.V1.klines(coin_futures_client;
        symbol = "BTCUSD_PERP",
        interval = Binance.DAPI.V1.Klines.TimeInterval.m5,
        startTime = one_hour_ago,
        endTime = now_utc,
        limit = 5,
    ),
)
if !isempty(coin_klines)
    println("Coin-M klines fetched: ", length(coin_klines), " | first volume: ", coin_klines[1].volume)
else
    println("Coin-M klines fetched: 0")
end

coin_continuous = cex_result(
    Binance.DAPI.V1.continuous_klines(coin_futures_client;
        pair = "BTCUSD",
        contractType = Binance.DAPI.V1.ContinuousKlines.ContractType.PERPETUAL,
        interval = Binance.DAPI.V1.ContinuousKlines.TimeInterval.m5,
        limit = 5,
    ),
)
println("Coin-M continuous klines fetched: ", length(coin_continuous))

coin_funding = cex_result(
    Binance.DAPI.V1.funding_rate(coin_futures_client;
        symbol = "BTCUSD_PERP",
        limit = 5,
    ),
)
println("Coin-M funding rate samples: ", length(coin_funding))

coin_premium = cex_result(
    Binance.DAPI.V1.premium_index(coin_futures_client;
        symbol = "BTCUSD_PERP",
    ),
)
println("Coin-M premium entries: ", length(coin_premium))

coin_ticker = cex_result(
    Binance.DAPI.V1.ticker_24hr(coin_futures_client;
        symbol = "BTCUSD_PERP",
    ),
)
println("Coin-M ticker entries: ", length(coin_ticker))

println("\n== Futures Data (global metrics) ==")

global_ratio = cex_result(
    Binance.Futures.Data.global_long_short_account_ratio(usd_futures_client;
        symbol = "BTCUSDT",
        period = Binance.Futures.Data.GlobalLongShortAccountRatio.TimeInterval.h1,
        limit = 5,
    ),
)
println("Global long/short samples: ", length(global_ratio))

open_interest = cex_result(
    Binance.Futures.Data.open_interest_hist(usd_futures_client;
        symbol = "BTCUSDT",
        period = Binance.Futures.Data.OpenInterestHist.TimeInterval.h1,
        limit = 5,
    ),
)
println("Open interest samples: ", length(open_interest))

taker_ratio = cex_result(
    Binance.Futures.Data.taker_long_short_ratio(usd_futures_client;
        symbol = "BTCUSDT",
        period = Binance.Futures.Data.TakerLongShortRatio.TimeInterval.h1,
        limit = 5,
    ),
)
println("Taker long/short samples: ", length(taker_ratio))

top_accounts = cex_result(
    Binance.Futures.Data.top_long_short_account_ratio(usd_futures_client;
        symbol = "BTCUSDT",
        period = Binance.Futures.Data.TopLongShortAccountRatio.TimeInterval.h1,
        limit = 5,
    ),
)
println("Top account ratio samples: ", length(top_accounts))

top_positions = cex_result(
    Binance.Futures.Data.top_long_short_position_ratio(usd_futures_client;
        symbol = "BTCUSDT",
        period = Binance.Futures.Data.TopLongShortPositionRatio.TimeInterval.h1,
        limit = 5,
    ),
)
println("Top position ratio samples: ", length(top_positions))
