module Ticker

include("ByPairs.jl")
using .ByPairs

include("All.jl")
using .All
import .All: all

end
