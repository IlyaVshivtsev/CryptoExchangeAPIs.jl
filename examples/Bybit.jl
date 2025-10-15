# Bybit Examples
# https://bybit-exchange.github.io/docs/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Bybit


bybit_client = BybitClient(;
    base_url = "https://api.bybit.com",
    public_key = get(ENV, "BYBIT_PUBLIC_KEY", ""),
    secret_key = get(ENV, "BYBIT_SECRET_KEY", ""),
)

Bybit.V5.Market.instruments_info(;
    category = Bybit.V5.Market.InstrumentsInfo.Category.OPTION,
    baseCoin = "BTC",
)

Bybit.V5.Market.instruments_info(;
    category = Bybit.V5.Market.InstrumentsInfo.Category.SPOT,
    baseCoin = "ETH",
    status = "Trading",
    limit = 10,
)

Bybit.V5.Market.tickers(;
    category = Bybit.V5.Market.Tickers.Category.SPOT,
    symbol = "BTCUSDT"
)

Bybit.V5.Market.tickers(;
    category = Bybit.V5.Market.Tickers.Category.OPTION,
    baseCoin = "BTC",
    expDate = "26DEC25",
)

Bybit.V5.Market.kline(;
    category = Bybit.V5.Market.Kline.Category.SPOT,
    symbol = "BTCUSDT",
    interval = Bybit.V5.Market.Kline.TimeInterval.h1
)

Bybit.V5.Market.kline(;
    category = Bybit.V5.Market.Kline.Category.LINEAR,
    symbol = "BTCUSDT",
    interval = Bybit.V5.Market.Kline.TimeInterval.m15,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 3,
)

Bybit.V5.Market.orderbook(;
    category = Bybit.V5.Market.Orderbook.Category.SPOT,
    symbol = "BTCUSDT",
    limit = 25
)

Bybit.V5.Asset.Coin.query_info(bybit_client)

Bybit.V5.Asset.Coin.query_info(bybit_client; coin = "BTC")

Bybit.V5.Asset.Deposit.query_record(bybit_client)

Bybit.V5.Asset.Deposit.query_record(
    bybit_client;
    coin = "USDT",
    startTime = now(UTC) - Month(1),
    endTime = now(UTC),
    limit = 50
)

Bybit.V5.Execution.list(
    bybit_client;
    category = Bybit.V5.Execution.List.Category.SPOT,
    limit = 10
)

Bybit.V5.Execution.list(
    bybit_client;
    category = Bybit.V5.Execution.List.Category.SPOT,
    symbol = "BTCUSDT",
    startTime = now(UTC) - Day(1),
    endTime = now(UTC),
    limit = 20
)
