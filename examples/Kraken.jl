# Kraken Examples
# https://docs.kraken.com/rest/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Kraken

kraken_client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = get(ENV, "KRAKEN_PUBLIC_KEY", ""),
    secret_key = get(ENV, "KRAKEN_SECRET_KEY", ""),
)

Kraken.V0.Public.ticker()

Kraken.V0.Public.ticker(; pair = "XBTUSD")

Kraken.V0.Public.ohlc(; pair = "XBTUSD")

Kraken.V0.Public.ohlc(;
    pair = "ETHUSD",
    interval = Kraken.V0.Public.Ohlc.TimeInterval.d1,
    since = now(UTC) - Day(1)
)

Kraken.V0.Public.assets()

Kraken.V0.Public.assets(; asset = ["XBT", "ETH"])

Kraken.V0.Public.assets(; aclass = Kraken.V0.Public.Assets.AssetClass.currency)

Kraken.V0.Public.asset_pairs()

Kraken.V0.Public.asset_pairs(; pair = "XBTUSD")

Kraken.V0.Public.asset_pairs(;
    info = Kraken.V0.Public.AssetPairs.AssetPairInfo.fees
)

Kraken.V0.Public.depth(; pair = "XBTUSD")

Kraken.V0.Public.depth(; pair = "XBTUSD", count = 10)


Kraken.V0.Private.deposit_methods(kraken_client; asset = "XBT")

Kraken.V0.Private.deposit_status(
    kraken_client;
    asset = "ETH",
    method = "Ethereum (ERC-20)"
)

Kraken.V0.Private.withdraw_methods(kraken_client)

Kraken.V0.Private.withdraw_methods(
    kraken_client;
    aclass = Kraken.V0.Private.WithdrawMethods.AssetClass.currency
)

Kraken.V0.Private.withdraw_methods(
    kraken_client;
    asset = "ETH",
    network = "Ethereum"
)

Kraken.V0.Private.withdraw_status(kraken_client; asset = "XBT")

Kraken.V0.Private.withdraw_status(
    kraken_client;
    asset = "ETH",
    method = "Ethereum (ERC-20)"
)

Kraken.V0.Private.ledgers(kraken_client)

Kraken.V0.Private.ledgers(
    kraken_client;
    asset = "ETH",
    type = Kraken.V0.Private.Ledgers.LedgerType.trade,
    start = now(UTC) - Day(7),
    _end = now(UTC),
    ofs = 10
)
