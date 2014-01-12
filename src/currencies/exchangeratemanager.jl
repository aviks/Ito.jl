using Calendar

immutable Entry
	rate::ExchangeRate
	start::CalendarTime
	end_::CalendarTime
end

type ExchangeRateManager
	data::Dict{BigInt, Array{Entry}}
	ExchangeRateManager()=new(Dict{BigInt, Array{Entry}}())
end

# Add an exchange rate
# The given rate is valid between the given dates
# Note:  If two rates are given between the same currencies
# and with overlapping date ranges, the latest one
# added takes precedence during lookup.
function add(ERM::ExchangeRateManager, ER::ExchangeRate, startdate::CalendarTime, enddate::CalendarTime)
	ERM.data[hash(ER.source, ER.target)]=Entry(ER, startdate, enddate)
end

function addKnownRates(ERM::ExchangeRateManager)
	
end

function clear(ERM::ExchangeRateManager)
	ERM.data=Dict{BigInt, Array{Entry}}() # Delete the dictionary
	addKnownRates(ERM)
end

hash(c1::Currency, c2::Currency)=BigInt(min(c1.numeric, c2.numeric))*1000+BigInt(max(c1.numeric, c2.numeric))
hashes(key::BigInt, c::Currency)=c.numeric==key%1000 || c.numeric==key/1000

function fetch(ERM::ExchangeRateManager, source::Currency, target::Currency, date::CalendarTime)
	entries=ERM.data[hash(source, target)]
	for entry in entries
		if date>=entry.start && date<=entry.end_
			return entry.rate
		end
	end
	return nothing
end 

function directLookup(ERM::ExchangeRateManager, source::Currency, target::Currency, date::CalendarTime)
	fetchedRate=fetch(ERM, source, target, date)
	
	if fetchedRate!=nothing
		return fetchedRate
	else
		error("no direct conversion available from $(source.code) to $(target.code) for $date")
	end
end

function smartLookup(ERM::ExchangeRateManager, source::Currency, target::Currency, date::CalendarTime, forbidden::Array{Integer, 1})
	fetchedRate=fetch(ERM, source, target, date)
	
	# direct exchange rates are preferred.
	if fetchedRate!=nothing
		return fetchedRate
	end
	
	# if none is found, turn to smart lookup. The source currency
    # is forbidden to subsequent lookups in order to avoid cycles.
	push!(forbidden, source.numeric)
	
	for key in keys(ERM.data)
		# we look for exchange-rate data which involve our source currency
		if hashes(key, source) && length(ERM.data[key])!=0
			# ...whose other currency is not forbidden...
			e=ERM.data[key][1]
			other= source==e.rate.source ? e.rate.target : e.rate.source
			
			if !in(other.numeric, forbidden)
				# ...and which carries information for the requested date.
				head=fetch(ERM, source, other, date)
				
				if head!=nothing
					# if we can get to the target from here...
					try
						tail=smartLookup(ERM, other, target, date, forbidden)
						# ..we're done.
					catch
						# otherwise, we just discard this rate.
					end
				end
			end
		end
	end
	
	# if the loop completed, we have no way to return the requested rate.
	error("no conversion available from $(source.code) to $(target.code) for $date")
end

function lookup(ERM::ExchangeRateManager, source::Currency, target::Currency, date::CalendarTime, ERType::Symbol=:Derived)
	if source==target
		return ExchangeRate(source, target, 1.0)
	end
	
	if date==ymd_hms(0, 0, 0, 0, 0, 0)
		date=today()
	end
	
	if ERType==:Direct
		return directLookup(source, target, date)
	elseif haskey(list_deprecated, source.code)
		link=list_deprecated[source.code]
		
		if link==target
			return directLookup(ERM, source, link, date)
		else
			return chain(directLookup(source, link, date), lookup(link, target, date))
		end
		
	elseif haskey(list_deprecated, target.code)
		link=list_deprecated[target.code]
		
		if link==source
			return directLookup(ERM, link, target, date)
		else
			return chain(lookup(source, link, date), directLookup(link, target, date))
		end
		
	else
		return smartLookup(EMR, source, target, date, Array(Int,0))
	end
		
end