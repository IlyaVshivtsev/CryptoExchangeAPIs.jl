# Bitget Examples
# https://www.bitget.com/api-doc/common/intro

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Bitget


Bitget.API.V2.Spot.Public.coins()
Bitget.API.V2.Spot.Public.coins(; coin = "BTC")

Bitget.API.V2.Spot.Public.symbols()
Bitget.API.V2.Spot.Public.symbols(; symbol = "BTCUSDT")

Bitget.API.V2.Spot.Market.tickers()
Bitget.API.V2.Spot.Market.tickers(; symbol = "BTCUSDT")
