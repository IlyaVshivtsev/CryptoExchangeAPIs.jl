module V1

include("Klines.jl")
using .Klines

include("ContinuousKlines.jl")
using .ContinuousKlines

include("Depth.jl")
using .Depth

include("ExchangeInfo.jl")
using .ExchangeInfo

include("FundingRate.jl")
using .FundingRate

include("Ticker24hr.jl")
using .Ticker24hr

include("PremiumIndex.jl")
using .PremiumIndex

include("Income.jl")
using .Income

end

