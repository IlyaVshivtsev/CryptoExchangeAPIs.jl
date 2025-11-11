# Deribit Examples
# https://docs.deribit.com/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Deribit


deribit_client = DeribitClient(;
    base_url = "https://www.deribit.com",
    public_key = get(ENV, "DERIBIT_PUBLIC_KEY", ""),
    secret_key = get(ENV, "DERIBIT_SECRET_KEY", ""),
)

Deribit.API.V2.Public.get_instruments(;
    currency = Deribit.API.V2.Public.GetInstruments.Currency.BTC
)

Deribit.API.V2.Public.get_instruments(;
    currency = Deribit.API.V2.Public.GetInstruments.Currency.BTC,
    kind = Deribit.API.V2.Public.GetInstruments.InstrumentKind.future
)

Deribit.API.V2.Public.get_instruments(;
    currency = Deribit.API.V2.Public.GetInstruments.Currency.ETH,
    kind = Deribit.API.V2.Public.GetInstruments.InstrumentKind.future,
    expired = false
)

Deribit.API.V2.Public.ticker(;
    instrument_name = "BTC-PERPETUAL"
)

Deribit.API.V2.Public.ticker(;
    instrument_name = "ETH-PERPETUAL"
)

Deribit.API.V2.Public.get_book_summary_by_currency(;
    currency = Deribit.API.V2.Public.GetBookSummaryByCurrency.Currency.BTC
)

Deribit.API.V2.Public.get_book_summary_by_currency(;
    currency = Deribit.API.V2.Public.GetBookSummaryByCurrency.Currency.BTC,
    kind = Deribit.API.V2.Public.GetBookSummaryByCurrency.InstrumentKind.future
)

Deribit.API.V2.Public.get_tradingview_chart_data(;
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = now(UTC) - Day(1),
    end_timestamp = now(UTC),
    resolution = Deribit.API.V2.Public.GetTradingviewChartData.TimeInterval.h1
)

Deribit.API.V2.Public.get_funding_rate_history(;
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = now(UTC) - Day(7),
    end_timestamp = now(UTC)
)

Deribit.API.V2.Public.get_order_book(;
    instrument_name = "BTC-PERPETUAL"
)

Deribit.API.V2.Public.get_order_book(;
    instrument_name = "ETH-PERPETUAL",
    depth = Deribit.API.V2.Public.GetOrderBook.Depth.FIFTY
)
