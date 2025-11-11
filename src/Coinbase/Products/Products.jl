module Products

include("AllProducts.jl")
using .AllProducts

include("Candles.jl")
using .Candles

include("Stats.jl")
using .Stats

include("Ticker.jl")
using .Ticker

end
