module V3

include("AvgPrice.jl")
using .AvgPrice

include("Depth.jl")
using .Depth

include("ExchangeInfo.jl")
using .ExchangeInfo

include("Klines.jl")
using .Klines

include("MyTrades.jl")
using .MyTrades

include("Ticker24hr.jl")
using .Ticker24hr

include("Time.jl")
using .Time
import .Time: time

end
