using Calendar

immutable Entry
	rate::ExchangeRate
	start::CalendarTime
	end_::CalendarTime
end

type ExchangeRateManager
	data::Dict{BigInt, Array{Entry}}
	ExchangeRateManager()=(x=new(Dict{BigInt, Array{Entry}}()); addKnownRates(x); x)
end

# Add an exchange rate
# The given rate is valid between the given dates
# Note:  If two rates are given between the same currencies
# and with overlapping date ranges, the latest one
# added takes precedence during lookup.
function add(ERM::ExchangeRateManager, ER::ExchangeRate, startdate::CalendarTime, enddate::CalendarTime)
	key=hash(ER.source, ER.target)
	if !haskey(ERM.data, key)
		ERM.data[key]=Array(Entry, 0)
	end
	push!(ERM.data[key], Entry(ER, startdate, enddate))	
end

function addKnownRates(ERM::ExchangeRateManager)
	# currencies obsoleted by Euro
	add(ERM, ExchangeRate(EURCurrency(), ATSCurrency(), 13.7603), ymd_hms(1999,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), BEFCurrency(), 40.3399), ymd_hms(1999,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), DEMCurrency(), 1.95583), ymd_hms(1999,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), ESPCurrency(), 166.386), ymd_hms(1999,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), FIMCurrency(), 5.94573), ymd_hms(1999,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), FRFCurrency(), 6.55957), ymd_hms(1999,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), GRDCurrency(), 340.750), ymd_hms(2001,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), IEPCurrency(), 0.787564), ymd_hms(1999,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), ITLCurrency(), 1936.27), ymd_hms(1999,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), LUFCurrency(), 40.3399), ymd_hms(1999,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), NLGCurrency(), 2.20371), ymd_hms(1999,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), PTECurrency(), 200.482), ymd_hms(1999,1,1,0,0,0), today())	
	add(ERM, ExchangeRate(EURCurrency(), CYPCurrency(), 0.585274), ymd_hms(2008,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), EEKCurrency(), 15.6466), ymd_hms(2011,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), LVLCurrency(), 1.42287), ymd_hms(2014,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), MTLCurrency(), 2.32937), ymd_hms(2008,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), SITCurrency(), 239.64), ymd_hms(2007,1,1,0,0,0), today())
	add(ERM, ExchangeRate(EURCurrency(), SKKCurrency(), 30.1260), ymd_hms(2009,1,1,0,0,0), today())
	
    # other obsoleted currencies
	add(ERM, ExchangeRate(TRYCurrency(), TRLCurrency(), 1000000.0), ymd_hms(2005,1,1,0,0,0), today())
	add(ERM, ExchangeRate(RONCurrency(), ROLCurrency(), 10000.0), ymd_hms(2005,7,1,0,0,0), today())
	add(ERM, ExchangeRate(PENCurrency(), PEICurrency(), 1000000.0), ymd_hms(1991,7,1,0,0,0), today())
	add(ERM, ExchangeRate(PEICurrency(), PEHCurrency(), 1000.0), ymd_hms(1985,2,1,0,0,0), today())
end

function clear(ERM::ExchangeRateManager)
	ERM=ExchangeRateManager()
end

hash(c1::Currency, c2::Currency)=BigInt(min(c1.numeric, c2.numeric))*1000+BigInt(max(c1.numeric, c2.numeric))
hashes(key::BigInt, c::Currency)=c.numeric==key%1000 || c.numeric==trunc(key/1000)

function fetch(ERM::ExchangeRateManager, source::Currency, target::Currency, date::CalendarTime)
	if !haskey(ERM.data, hash(source, target))
		return nothing
	end
	
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

function smartLookup(ERM::ExchangeRateManager, source::Currency, target::Currency, date::CalendarTime, forbidden::Array{Int, 1})
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
			e=ERM.data[BigInt(key)][1]
			other= source==e.rate.source ? e.rate.target : e.rate.source
			if !in(other.numeric, forbidden)
				# ...and which carries information for the requested date.
				head=fetch(ERM, source, other, date)	

				if head!=nothing
					# if we can get to the target from here...
					try						
						tail=smartLookup(ERM, other, target, date, forbidden)						
						# ..we're done.
						return chain(head, tail)
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
		return smartLookup(ERM, source, target, date, Array(Int,0))
	end
		
end

# Singleton design pattern
function getInstance()
	global ERM_Instance
	if !isdefined(Currencies, :ERM_Instance)
		ERM_Instance=ExchangeRateManager()
	end
	return ERM_Instance
end

minDate=ymd_hms(1901, 1, 1, 0, 0, 0)
maxDate=ymd_hms(2199, 12, 31, 0, 0, 0)
add(ER::ExchangeRate, startdate::CalendarTime=minDate, enddate::CalendarTime=maxDate)=add(getInstance(), ER, startdate, enddate)
clear()=clear(getInstance())
lookup(source::Currency, target::Currency, date::CalendarTime=today(), ERType::Symbol=:Derived)=lookup(getInstance(), source, target, date, ERType)