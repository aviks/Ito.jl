module TermStructure

using Ito.Time
using Calendar 

export YieldTermStructure, VolatilityTermStructure, FlatYieldTermStructure,
		compound_factor, discount_factor, implied_rate, discount, forward_rate, 
		reference_date, zero_rate, par_rate

#General Interest Rate functionality

compound_factor(r::Real, compounding::Symbol, freq::Symbol,  t::Real) = compound_factor(r, compounding, eval(freq), t)
compound_factor(r::Real, compounding::Symbol,  t::Real) = compound_factor(r, compounding, NoFrequency, t)
compound_factor(r::Real, compounding::Symbol, dc::DayCount, dates::CalendarTime...) = compound_factor(r, compounding, NoFrequency, dates...)
compound_factor(r::Real, compounding::Symbol, freq::Symbol, dc::DayCount, dates::CalendarTime...) = compound_factor(r, compounding, eval(freq), dates...)
compound_factor(r::Real, compounding::Symbol, freq::Integer, dc::DayCount, dates::CalendarTime...) = compound_factor(r,  compounding, freq, yearfraction(dc, dates...))

function compound_factor(r::Real, compounding::Symbol, freq::Integer, t::Real ) 
	if compounding == :Simple
		return 1 + r * t
	elseif compounding == :Compounded
		@assert(freq != NoFrequency)
		return (1 + r / freq) ^ (freq * t)
	elseif compounding == :Continuous
		return exp(r * t)
	elseif compounding == :SimpleThenCompounded
		@assert(freq != NoFrequency)
		if t < (1 / freq) 
            return 1 + r * t
        else
            return (1 + r / freq) ^ (freq * t)
        end
	else
		error("Unknown compounding")
	end
end

discount_factor(x...) = 1/compound_factor(x...)

implied_rate(c::Real, compounding::Symbol, freq::Symbol,  t::Real) = implied_rate(c,compounding, eval(freq), t)
implied_rate(c::Real, compounding::Symbol, freq::Symbol, dc::DayCount, dates::CalendarTime...) = implied_rate(c,compounding, eval(freq), dates...)
implied_rate(c::Real, compounding::Symbol, freq::Integer, dc::DayCount, dates::CalendarTime...) = implied_rate(c, compounding, freq, yearfraction(dc, dates...))

function implied_rate(c::Real, compounding::Symbol, freq::Integer, t::Real)
	@assert c>0 && t>0
	if compounding == :Simple
		return (c-1) / t
	elseif compounding == :Compounded
		return (c ^ (1/(f*t)) - 1) *f
	elseif compounding == :Continuous
		return log(c)/t
	elseif compounding == :SimpleThenCompounded
		if t < (1 / freq) 
            return (c-1) / t
        else
            return (c ^ (1/(f*t)) - 1) *f
        end
	else
		error("Unknown compounding")
	end
end



#abstract TermStructure

abstract VolatilityTermStructure
abstract YieldTermStructure

discount(ts::YieldTermStructure, d::CalendarTime) = discount(ts, yearfraction(reference_date(ts), d))

#Overload this method for each concrete YieldTermStructure
discount(ts::YieldTermStructure, t::Real) = error("Must be implemented by concrete Term Structure")

#Conventional implementation. Usually re-implemented by concrete term structures
reference_date(ts::YieldTermStructure) = ts.reference_date

forward_rate(ts::YieldTermStructure, compounding::Symbol, freq::Integer, d1::CalendarTime, d2::CalendarTime) = forward_rate(ts, compounding, freq, d1, d2) 
function forward_rate(ts::YieldTermStructure, compounding::Symbol, freq::Integer, d1::CalendarTime, d2::CalendarTime ) 
	if d1==d2
		t1 = yearfraction(reference_date(ts), d1)
		t2 = t1+.0001
		c=discount(ts, t1) / discount(ts, t2)
		return implied_rate(c, compound, freq, delta)
	elseif d1<d2
		return implied_rate(discount(ts, d1)/discount(ts, d2), ts.dc, d1, d2)
	else
		error("Forward start date must be before forward end dates")
	end
end

function forward_rate(ts::YieldTermStructure, compounding::Symbol, freq::Integer, t1::Real, t2::Real ) 
	if (t2==t1)
		t2=t1+.0001
	end

	compound = discount(ts, t1) / discount(ts, t2)
	return implied_rate(discount(ts, t1) / discount(ts, t2), ts.dc, t1, t2)
end

zero_rate(ts::YieldTermStructure, compounding::Symbol, freq::Integer, d1::CalendarTime) = zero_rate(ts, compounding, freq, yearfraction(ts.dc, reference_date(ts), d1))
function zero_rate(ts::YieldTermStructure, compounding::Symbol, freq::Integer, t::Real)
	if (t == 0)
		c = 1/discount(ts, .0001)
		return implied_rate(c, compounding, freq, .0001)
	else 
		c = 1/discount(ts, t)
		return implied_rate(c, compounding, freq, t)
	end
end

par_rate(ts::YieldTermStructure, compounding, freq, dates::AbstractVector{CalendarTime}) = 
	par_rate(ts, compounding, freq, [yearfraction(ts.dc, reference_date(ts), dt) for dt in dates])
function par_rate(ts::YieldTermStructure, compounding, freq, tm::AbstractVector) 
	s = sum([discount(ts, t) for t in tm])
	r=discount(ts, tm[1])
end

type ConstantVolatilityTermStructure

end

type FlatYieldTermStructure
	dc::DayCount
	rate::Real
	compounding::Symbol
	freq::Integer
	reference_date::CalendarTime

	FlatYieldTermStructure(dc::DayCount, rate::Real, compounding::Symbol, freq::Symbol, reference_date::CalendarTime) = 
			new(dc, rate, compounding, eval(freq), reference_date)
end

FlatYieldTermStructure(dc::DayCount, rate::Real) = FlatYieldTermStructure(dc, rate, :Continuous, :NoFrequency, today())
discount(ts::FlatYieldTermStructure, t::Real) = discount_factor(ts.r, ts.compounding, ts.freq, t)


const NoFrequency       = -1
const Once			 	= 0 
const Annual			= 1 
const Semiannual		= 2 
const EveryFourthMonth  = 3 
const Quarterly		 	= 4 
const Bimonthly		 	= 6 
const Monthly			= 12
const EveryFourthWeek  	= 13
const Biweekly		 	= 26
const Weekly			= 52
const Daily			 	= 365
const OtherFrequency   	= 999


end #Module
