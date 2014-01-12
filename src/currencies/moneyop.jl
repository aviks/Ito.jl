# Helper function 
function convertTo(m::Money, target::Currency, ERM::ExchangeRateManager=ExchangeRateManager())
	if m.currency!=target
		rate=lookup(ERM, m.currency, target)
		m=rounded(exchange(rate, m))
	end
end

convertToBase(m::Money)=convertTo(m, baseCurrency(m))

function functionOperator(m1::Money, m2::Money, op::Function)
	if m1.currency==m2.currency
		return op(m1.value, m2.value)
	elseif ConversionType==:BaseCurrencyConversion
		tmp1=m1
		convertToBase(tmp1)
		tmp2=m2
		convertToBase(tmp2)
		return functionOperator(tpm1, tpm2, op)
	elseif ConversionType==:AutomatedConversion
		tmp=m2
		convertTo(tmp, m1.currency)
		return functionOperator(m1, tmp, op)
	else
		error("currency mismatch and no conversion specified")
	end
end

# Operator functions
+(m1::Money, m2::Money)=functionOperator(m1, m2, +)
-(m1::Money, m2::Money)=functionOperator(m1, m2, -)
/(m1::Money, m2::Money)=functionOperator(m1, m2, /)
==(m1::Money, m2::Money)=functionOperator(m1, m2, ==)
<(m1::Money, m2::Money)=functionOperator(m1, m2, <)
close(m1::Money, m2::Money)=functionOperator(m1, m2, (x,y)=>abs(x-y)<10.0^(-10))