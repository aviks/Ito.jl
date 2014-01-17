# Helper function 
function convertTo(m::Money, target::Currency)
	if m.currency!=target
		rate=lookup(m.currency, target)
		return rounded(exchange(rate, m))
	end
	return m
end

convertToBase(m::Money)=convertTo(m, baseCurrency(m))

function functionOperator(m1::Money, m2::Money, op::Function)
	if m1.currency==m2.currency
		return op(m1.value, m2.value)
	elseif ConversionType==:BaseCurrencyConversion
		tmp1=convertToBase(m1)
		tmp2=convertToBase(m2)
		return functionOperator(tmp1, tmp2, op)
	elseif ConversionType==:AutomatedConversion
		tmp=convertTo(m2, m1.currency)
		return functionOperator(m1, tmp, op)
	else
		error("currency mismatch and no conversion specified")
	end
end

# Operator functions that return a value
/(m1::Money, m2::Money)=functionOperator(m1, m2, /)
==(m1::Money, m2::Money)=functionOperator(m1, m2, ==)
<(m1::Money, m2::Money)=functionOperator(m1, m2, <)
close(m1::Money, m2::Money)=functionOperator(m1, m2, (x,y)=>abs(x-y)<10.0^(-10))

function functionOperatorMoney(m1::Money, m2::Money, op::Function)
	if m1.currency==m2.currency
		return Money(m1.currency, op(m1.value, m2.value))
	elseif ConversionType==:BaseCurrencyConversion
		tmp1=convertToBase(m1)		
		tmp2=convertToBase(m2)
		return functionOperatorMoney(tmp1, tmp2, op)
	elseif ConversionType==:AutomatedConversion
		tmp=convertTo(m2, m1.currency)
		return functionOperatorMoney(m1, tmp, op)
	else
		error("currency mismatch and no conversion specified")
	end
end

# Operator functions that return a Money
+(m1::Money, m2::Money)=functionOperatorMoney(m1, m2, +)
-(m1::Money, m2::Money)=functionOperatorMoney(m1, m2, -)