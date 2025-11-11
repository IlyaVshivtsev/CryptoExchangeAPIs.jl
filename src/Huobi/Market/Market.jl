module Market

include("History/History.jl")

include("Depth.jl")
using .Depth

include("Tickers.jl")
using .Tickers

end
