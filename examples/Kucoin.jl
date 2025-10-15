# Kucoin Examples
# https://www.kucoin.com/docs/rest/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Kucoin

kucoin_client = KucoinClient(;
    base_url = "https://api.kucoin.com",
    public_key = get(ENV, "KUCOIN_PUBLIC_KEY", ""),
    secret_key = get(ENV, "KUCOIN_SECRET_KEY", ""),
    passphrase = get(ENV, "KUCOIN_PASSPHRASE", ""),
)

Kucoin.API.V1.Market.all_tickers()

Kucoin.API.V1.Market.candles(;
    symbol = "BTC-USDT",
    type = Kucoin.API.V1.Market.Candles.TimeInterval.h1
)

Kucoin.API.V1.Market.candles(;
    symbol = "BTC-USDT",
    type = Kucoin.API.V1.Market.Candles.TimeInterval.d1,
    startAt = now(UTC) - Day(6),
    endAt = now(UTC)
)

Kucoin.API.V1.Market.stats(; symbol = "BTC-USDT")

Kucoin.API.V1.KlineQuery.kline_query(;
    symbol = ".KXBT",
    granularity = Kucoin.API.V1.KlineQuery.TimeInterval.m1
)

Kucoin.API.V1.KlineQuery.kline_query(;
    symbol = ".KXBT",
    granularity = Kucoin.API.V1.KlineQuery.TimeInterval.h1,
    from = now(UTC) - Day(1),
    to = now(UTC)
)

Kucoin.API.V1.Contracts.active()

Kucoin.API.V1.Contract.funding_rates(;
    symbol = "XBTUSDTM",
    from = now(UTC) - Day(7),
    to = now(UTC)
)

Kucoin.API.V1.hist_deposits(kucoin_client)

Kucoin.API.V1.hist_deposits(
    kucoin_client;
    currency = "ETH",
    startAt = now(UTC) - Day(30),
    endAt = now(UTC)
)

Kucoin.API.V1.hist_deposits(
    kucoin_client;
    status = Kucoin.API.V1.HistDeposits.Status.SUCCESS
)

Kucoin.API.V1.funding_history(kucoin_client; symbol = "XBTUSDM")

Kucoin.API.V1.funding_history(
    kucoin_client;
    symbol = "XBTUSDM",
    startAt = now(UTC) - Day(7),
    endAt = now(UTC)
)

Kucoin.API.V1.funding_history(
    kucoin_client;
    symbol = "ETHUSDM",
    reverse = true,
    maxCount = 100
)


Kucoin.API.V2.Symbols.all_symbols()

Kucoin.API.V2.Symbols.symbol(; symbol = "BTC-USDT")
