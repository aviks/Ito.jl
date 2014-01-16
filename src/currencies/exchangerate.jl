immutable ExchangeRate
	source::Currency
	target::Currency
	rate::Float64
	type_::Symbol # :Direct or :Derived
	rateChain::(ExchangeRate, ExchangeRate)
	
	ExchangeRate(source::Currency, target::Currency, rate::Float64)=new(source, target, rate, :Direct)
	ExchangeRate(source::Currency, target::Currency, rate::Float64, type_::Symbol, rateChain::(ExchangeRate, ExchangeRate))=new(source, target, rate, type_, rateChain)
end

# Apply the exchange rate to a cash amount
function exchange(ER::ExchangeRate, m::Money)

	if ER.type_==:Direct # Given directly by the user
		
		if m.currency==ER.source
			return Money(m.value*ER.rate, ER.target)		
		elseif m.currency==ER.target
			return Money(m.value/ER.rate, ER.source)
		else
			error("Exchange rate not applicable")
		end
	
	elseif ER.type_==:Derived #Derived from exchange rates between other currencies
		if m.currency==ER.rateChain[1].source || m.currency==ER.rateChain[1].target
			return exchange(ER.rateChain[2], exchange(ER.rateChain[1], m))
		elseif m.currency==ER.rateChain[2].source || m.currency==ER.rateChain[2].target
			return exchange(ER.rateChain[1], exchange(ER.rateChain[2], m))
		else
			error("Exchange rate not applicable")
		end
	
	end	
		
end

# Chain two exchange rates
function chain(ER1::ExchangeRate, ER2::ExchangeRate)

	if ER1.source==ER2.source
	
		source=ER1.target
		target=ER2.target
		rate=ER2.rate/ER1.rate
		
	elseif ER1.source==ER2.target
	
		source=ER1.target
		target=ER2.source
		rate=1.0/(ER1.rate*ER2.rate)
	
	elseif ER1.target==ER2.source

		source=ER1.source
		target=ER2.target
		rate=ER1.rate*ER2.rate
	
	elseif ER1.target==ER2.target
	
		source=ER1.source
		target=ER2.source
		rate=ER1.rate/ER2.rate
	
	else
		error("Exchange rates not chainable")
	end
	
	return ExchangeRate(source, target, rate, :Derived, (ER1, ER2))
end
	