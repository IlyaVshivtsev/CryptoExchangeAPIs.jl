# Coinbase Examples
# https://docs.cdp.coinbase.com/api-reference/exchange-api/rest-api/introduction

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Coinbase


coinbase_client = CoinbaseClient(;
    base_url = "https://api.exchange.coinbase.com",
    public_key = get(ENV, "COINBASE_PUBLIC_KEY", ""),
    secret_key = get(ENV, "COINBASE_SECRET_KEY", ""),
    passphrase = get(ENV, "COINBASE_PASSPHRASE", ""),
)

Coinbase.Currencies.all_currencies()

Coinbase.Products.all_products()

Coinbase.Products.all_products(;
    type = "spot"
)

Coinbase.Products.candles(;
    granularity = Coinbase.Products.Candles.TimeInterval.d1,
    product_id = "BTC-USD"
)

Coinbase.Products.candles(;
    granularity = Coinbase.Products.Candles.TimeInterval.d1,
    product_id = "BTC-USD",
    start = now(UTC) - Day(7),
    _end = now(UTC)
)

Coinbase.Products.stats(;
    product_id = "BTC-USD"
)

Coinbase.Products.ticker(;
    product_id = "BTC-USD"
)

Coinbase.Withdrawals.fee_estimate(coinbase_client)

Coinbase.Withdrawals.fee_estimate(
    coinbase_client;
    currency = "BTC"
)

Coinbase.Withdrawals.fee_estimate(
    coinbase_client;
    currency = "ETH",
    crypto_address = "0x742d35Cc6634C0532925a3b8D",
    network = "ethereum"
)
