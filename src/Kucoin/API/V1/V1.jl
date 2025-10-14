module V1

include("Market/Market.jl")

include("KlineQuery.jl")
using .KlineQuery

include("HistDeposits.jl")
using .HistDeposits

include("Contracts/Contracts.jl")

include("Contract/Contract.jl")

include("FundingHistory.jl")
using .FundingHistory

end
