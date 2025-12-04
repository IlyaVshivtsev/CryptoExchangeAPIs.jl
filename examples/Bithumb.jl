# Bithumb Examples
# https://apidocs.bithumb.com/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Bithumb


client = BithumbClient(;
    base_url = "https://api.bithumb.com",
    public_key = get(ENV, "BITHUMB_PUBLIC_KEY", ""),
    secret_key = get(ENV, "BITHUMB_SECRET_KEY", ""),
)


Bithumb.Public.AssetsStatus.multichain()

Bithumb.Public.AssetsStatus.multichain(; currency = "ADA")

Bithumb.Public.candlestick(;
    order_currency = "BTC",
    payment_currency = "KRW",
    interval = Bithumb.Public.Candlestick.TimeInterval.h24
)

Bithumb.Public.order_book(;
    order_currency = "BTC",
    payment_currency = "KRW",
    count = 5
)

Bithumb.Public.order_book(;
    payment_currency = "KRW",
    count = 10
)

Bithumb.V1.Market.all()

Bithumb.V1.Market.all(; isDetails = true)

Bithumb.V1.ticker(; markets = "KRW-BTC")

Bithumb.V1.ticker(; markets = ["KRW-BTC", "KRW-ETH", "KRW-ADA"])

Bithumb.Info.user_transactions(
    client;
    order_currency = "BTC",
    payment_currency = "KRW",
    count = 50
)

Bithumb.Info.user_transactions(
    client;
    order_currency = "ETH",
    payment_currency = "KRW",
    searchGb = Bithumb.Info.UserTransactions.UserTransactions.SearchStatus.BUY_COMPLETED,
    count = 20
)
