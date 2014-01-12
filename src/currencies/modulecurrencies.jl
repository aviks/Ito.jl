module Currencies
	include("currency.jl")
	include("money.jl")
	include("exchangerate.jl")
	include("exchangeratemanager.jl")
	include("moneyop.jl") #moneyop depends on exchangeratemanager
end