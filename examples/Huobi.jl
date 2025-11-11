# Huobi Examples
# https://huobiapi.github.io/docs/spot/v1/en/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Huobi

huobi_client = HuobiClient(;
    base_url = "https://api.huobi.pro",
    public_key = get(ENV, "HUOBI_PUBLIC_KEY", ""),
    secret_key = get(ENV, "HUOBI_SECRET_KEY", ""),
)

Huobi.Market.tickers()

Huobi.Market.depth(; symbol = "btcusdt")

Huobi.Market.depth(;
    symbol = "ethusdt",
    type = Huobi.Market.Depth.StepType.step1
)

Huobi.Market.History.kline(;
    symbol = "btcusdt",
    period = Huobi.Market.History.Kline.TimeInterval.m1
)

Huobi.V1.Settings.Common.symbols()

Huobi.V1.Settings.Common.symbols(; ts = 1640995200000)

Huobi.V1.Order.history(huobi_client)

Huobi.V1.Order.history(
    huobi_client;
    symbol = "btcusdt"
)

Huobi.V1.Order.history(
    huobi_client;
    symbol = "ethusdt",
    direct = Huobi.V1.Order.History.DirectQuery.next,
    start_time = now(UTC) - Day(1),
    end_time = now(UTC),
    size = 100
)

Huobi.V1.Query.deposit_withdraw(
    huobi_client;
    type = Huobi.V1.Query.DepositWithdraw.DepositWithdrawType.deposit,
    currency = "ada"
)

Huobi.V1.Query.deposit_withdraw(
    huobi_client;
    type = Huobi.V1.Query.DepositWithdraw.DepositWithdrawType.deposit,
    currency = "sol",
    direct = Huobi.V1.Query.DepositWithdraw.DirectQuery.next
)

Huobi.V2.Reference.currencies(huobi_client)

Huobi.V2.Reference.currencies(
    huobi_client;
    currency = "btc",
    authorizedUser = true
)
