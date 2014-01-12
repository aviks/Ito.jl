type Money
	value::Float64
	currency::Currency
end

const ConversionType=:NoConversion # or :BaseCurrencyConversion, :AutomatedConversion

# Constructors
Money()=Money(0.0, none)
Money(curr::Currency, val::Float64)=Money(val, curr)

# Transformations
rounded(m::Money)=Money(m.rounding(m.value), m.currency)
baseCurrency(m::Money)=m.currency
+(m::Money)=m
-(m::Money)=Money(-m.value, m.currency)	

# Multiplication with other types
*(m::Money, x::Float64)=Money(m.currency, m.value*x)
*(x::Float64, m::Money)=m*x
*(c::Currency, x::Float64)=Money(x, c)
*(x::Float64, c::Currency)=c*x

# Division with other types
/(m::Money, x::Float64)=Money(m.currency, m.value/x)
/(x::Float64, m::Money)=m/x


# Print function
import Base.show
show(io::IO,m::Money)=print(io, "$(m.currency) $(m.value)")