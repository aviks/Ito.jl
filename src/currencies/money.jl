type Money
	value::Float64
	currency::Currency
end

ConversionType=:NoConversion # or :BaseCurrencyConversion, :AutomatedConversion
setConversionType(s::Symbol)=(global ConversionType; ConversionType=s)

staticBaseCurrency=nothing
setStaticBaseCurrency(c::Currency)=(global staticBaseCurrency; staticBaseCurrency=c)
resetStaticBaseCurrency()=(global staticBaseCurrency; staticBaseCurrency=nothing)

# Constructors
Money()=Money(0.0, none)
Money(curr::Currency, val::Float64)=Money(val, curr)

# Transformations
rounded(m::Money)=Money(m.currency.rounding(m.value), m.currency)

baseCurrency(m::Money)= staticBaseCurrency==nothing ? m.currency : staticBaseCurrency
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

# Copy function
import Base.copy
copy(m::Money)=Money(m.currency, m.value)

# Print function
import Base.show
show(io::IO,m::Money)=print(io, "$(m.currency) $(m.value)")