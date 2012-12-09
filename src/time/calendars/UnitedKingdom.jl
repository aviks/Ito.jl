export UKSettlementCalendar, UKLSECalendar, UKLMECalendar

abstract UnitedKingdomCalendar <: WesternCalendar

type UKSettlementCalendar <: UnitedKingdomCalendar; end
type UKLSECalendar <: UnitedKingdomCalendar; end
type UKLMECalendar <: UnitedKingdomCalendar; end

string(::UKSettlementCalendar) = "UK Generic Settlement"
string(::UKLSECalendar) = "London Stock Exchange"
string(::UKLMECalendar) = "London Metal Exchange"

function isWorkingDay(c::UKSettlementCalendar, dt::CalendarTime)
	d=day(dt)
	dd=dayofyear(dt)
	m=month(dt)
	w=dayofweek(dt)
	y=year(dt)
	em=easterMonday(c,y)

	!(isWeekend(c,w)
            # New Year's Day (possibly moved to Monday)
            || ((d == 1 || ((d == 2 || d == 3) && w == Monday)) && m == January)
            # Good Friday
            || (dd == em - 3)
            # Easter MONDAY
            || (dd == em)
            # first MONDAY of May (Early May Bank Holiday)
            || (d <= 7 && w == Monday && m == May)
            # last MONDAY of MAY (Spring Bank Holiday)
            || (d >= 25 && w == Monday && m == May && y != 2002)
            # last MONDAY of August (Summer Bank Holiday)
            || (d >= 25 && w == Monday && m == August)
            # Christmas (possibly moved to MONDAY or Tuesday)
            || ((d == 25 || (d == 27 && (w == Monday || w == Tuesday))) && m == December)
            # Boxing Day (possibly moved to MONDAY or TUESDAY)
            || ((d == 26 || (d == 28 && (w == Monday || w == Tuesday))) && m == December)
            # June 3rd, 2002 only (Golden Jubilee Bank Holiday)
            # June 4rd, 2002 only (special Spring Bank Holiday)
            || ((d == 3 || d == 4) && m == June && y == 2002)
            # June, 5th, 2012 only (Queens Diamond Jubilee)	
            || (d == 5 && m == June && y == 2012)
            # DECEMBER 31st, 1999 only
            || (d == 31 && m == December && y == 1999))
end

function isWorkingDay(c::UKLSECalendar, dt::CalendarTime)
	d=day(dt);
	dd=dayofyear(dt)
	m=month(dt);
	w=dayofweek(dt);
	y=year(dt);
	em=easterMonday(c,y)

	!(isWeekend(c,w)       
            # New Year's Day (possibly moved to Monday)
            || ((d == 1 || ((d == 2 || d == 3) && w == Monday)) && m == January)
            # Good Friday
            || (dd == em-3)
            # Easter Monday
            || (dd == em)
            # first Monday of May (Early May Bank Holiday)
            || (d <= 7 && w == Monday && m == May)
            # last Monday of May (Spring Bank Holiday)
            || (d >= 25 && w == Monday && m == May && y != 2002)
            # last Monday of August (Summer Bank Holiday)
            || (d >= 25 && w == Monday && m == August)
            # Christmas (possibly moved to Monday or Tuesday)
            || ((d == 25 || (d == 27 && (w == Monday || w == Tuesday))) && m == December)
            # Boxing Day (possibly moved to Monday or Tuesday)
            || ((d == 26 || (d == 28 && (w == Monday || w == Tuesday)))
                && m == December)
            # June 3rd, 2002 only (Golden Jubilee Bank Holiday)
            # June 4rd, 2002 only (special Spring Bank Holiday)
            || ((d == 3 || d == 4) && m == June && y == 2002)
            # June, 5th, 2012 only (Queens Diamond Jubilee)	
            || (d == 5 && m == June && y == 2012)
            # December 31st, 1999 only
            || (d == 31 && m == December && y == 1999)
            )
end

function isWorkingDay(c::UKLMECalendar, dt::CalendarTime)
	d=day(dt);
	dd=dayofyear(dt)
	m=month(dt);
	w=dayofweek(dt);
	y=year(dt);
	em=easterMonday(c,y)

	!(isWeekend(w)
            # New Year's Day (possibly moved to Monday)
            || ((d == 1 || ((d == 2 || d == 3) && w == Monday)) &&  m == January)
            # Good Friday
            || (dd == em-3)
            # Easter Monday
            || (dd == em)
            # first Monday of May (Early May Bank Holiday)
            || (d <= 7 && w == Monday && m == May)
            # last Monday of May (Spring Bank Holiday)
            || (d >= 25 && w == Monday && m == May && y != 2002)
            # last Monday of August (Summer Bank Holiday)
            || (d >= 25 && w == Monday && m == August)
            # Christmas (possibly moved to Monday or Tuesday)
            || ((d == 25 || (d == 27 && (w == Monday || w == Tuesday)))
                && m == December)
            # Boxing Day (possibly moved to Monday or Tuesday)
            || ((d == 26 || (d == 28 && (w == Monday || w == Tuesday))) && m == December)
            # June 3rd, 2002 only (Golden Jubilee Bank Holiday)
            # June 4rd, 2002 only (special Spring Bank Holiday)
            || ((d == 3 || d == 4) && m == June && y == 2002)
            # June, 5th, 2012 only (Queens Diamond Jubilee)	
            || (d == 5 && m == June && y == 2012)
            # December 31st, 1999 only
            || (d == 31 && m == December && y == 1999)
            )
end


