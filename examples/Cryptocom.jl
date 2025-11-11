# Cryptocom Examples
# https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Cryptocom


cryptocom_client = CryptocomClient(;
    base_url = "https://api.crypto.com/exchange/v1",
    public_key = get(ENV, "CRYPTOCOM_PUBLIC_KEY", ""),
    secret_key = get(ENV, "CRYPTOCOM_SECRET_KEY", ""),
)

Cryptocom.Public.get_instruments()

Cryptocom.Public.get_tickers()

Cryptocom.Public.get_tickers(; instrument_name = "BTC_USDT")

Cryptocom.Public.get_candlestick(; instrument_name = "BTC_USDT")

Cryptocom.Public.get_candlestick(;
    instrument_name = "BTC_USDT",
    timeframe = Cryptocom.Public.GetCandlestick.TimeInterval.h4,
    count = 10,
    start_ts = now(UTC) - Day(2),
    end_ts = now(UTC)
)
