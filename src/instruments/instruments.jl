module Instruments

import Base.ref
export VanillaPayoff, ForwardPayoff, VanillaOption, AmericanOption

abstract Payoff
abstract Instrument

type VanillaPayoff <: Payoff
	typ
	strike
end

type ForwardPayoff <: Payoff
	typ
	strike
end

type StraddlePayoff <: Payoff
	typ
	strike
end

ref(p::VanillaPayoff, s::Real) = typ == :call ? max(s - p.strike, 0) : max(p.strike - s, 0)
ref(p::ForwardPayoff, s::Real) = typ == :long ? (s - p.strike) : (p.strike - s)
ref(p::StraddlePayoff, s::Real) = typ == :long ? max(s - p.strike, 0) + max(p.strike - s, 0) : -max(s - p.strike, 0) - max(p.strike - s, 0)

type VanillaOption
	payoff
	excercise
end

type AmericanOption
	payoff
	excercise
end

end
