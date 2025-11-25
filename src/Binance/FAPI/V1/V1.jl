module V1

include("ContinuousKlines.jl")
using .ContinuousKlines

include("Depth.jl")
using .Depth

include("ExchangeInfo.jl")
using .ExchangeInfo

include("FundingRate.jl")
using .FundingRate

include("HistoricalTrades.jl")
using .HistoricalTrades

include("Klines.jl")
using .Klines

include("PremiumIndex.jl")
using .PremiumIndex

include("Ticker24hr.jl")
using .Ticker24hr

include("InsuranceBalance.jl")
using .InsuranceBalance

end