module V1

include("Market/Market.jl")

include("Candles/Candles.jl")

include("Ticker/Ticker.jl")

include("Orderbook.jl")
using .Orderbook

include("Status/Status.jl")

end
