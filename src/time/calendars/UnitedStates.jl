export USSettlementCalendar, USNYSECalendar, USGovernmentBondCalendar, USNERCCalendar

abstract UnitedStatesCalendar <: WesternCalendar

type USSettlementCalendar <: UnitedStatesCalendar; end
type USNYSECalendar <: UnitedStatesCalendar; end
type USNERCCalendar <: UnitedStatesCalendar; end
type USGovernmentBondCalendar <: UnitedStatesCalendar; end

string(::USSettlementCalendar) = "US Settlement"
string(::USNYSECalendar) = "New York Stock Exchange"
string(::USNERCCalendar) = "North American Energy Reliability Council"
string(::USGovernmentBondCalendar) = "US Government Bond Market"


function isWorkingDay(c::USSettlementCalendar, dt::CalendarTime)
	d=day(dt)
	dd=dayofyear(dt)
	m=month(dt)
	w=dayofweek(dt)
	y=year(dt)
	em=easterMonday(c, y)
	if (isWeekend(c, w)
            # New Year's Day (possibly moved to Monday if on Sunday)
            || ((d == 1 || (d == 2 && w == Monday)) && m == January)
            # (or to Friday if on Saturday)
            || (d == 31 && w == Friday && m == December)
            # Martin Luther King's birthday (third Monday in January)
            || ((d >= 15 && d <= 21) && w == Monday && m == January)
            # Washington's birthday (third Monday in February)
            || ((d >= 15 && d <= 21) && w == Monday && m == February)
            # Memorial Day (last Monday in May)
            || (d >= 25 && w == Monday && m == May)
            # Independence Day (Monday if Sunday or Friday if Saturday)
            || ((d == 4 || (d == 5 && w == Monday) ||
                 (d == 3 && w == Friday)) && m == July)
            # Labor Day (first Monday in September)
            || (d <= 7 && w == Monday && m == September)
            # Columbus Day (second Monday in October)
            || ((d >= 8 && d <= 14) && w == Monday && m == October)
            # Veteran's Day (Monday if Sunday or Friday if Saturday)
            || ((d == 11 || (d == 12 && w == Monday) || (d == 10 && w == Friday)) && m == November)
            # Thanksgiving Day (fourth Thursday in November)
            || ((d >= 22 && d <= 28) && w == Thursday && m == November)
            # Christmas (Monday if Sunday or Friday if Saturday)
            || ((d == 25 || (d == 26 && w == Monday) ||
                 (d == 24 && w == Friday)) && m == December))
            return false
    end	
    return true
end

function isWorkingDay(c::USNYSECalendar, dt::CalendarTime)
	d=day(dt)
	dd=dayofyear(dt)
	m=month(dt)
	w=dayofweek(dt)
	y=year(dt)
	em=easterMonday(c, y)

	if (isWeekend(c, w)
            # New Year's Day (possibly moved to Monday if on Sunday)
            || ((d == 1 || (d == 2 && w == Monday)) && m == January)
            # Washington's birthday (third Monday in February)
            || ((d >= 15 && d <= 21) && w == Monday && m == February)
            # Good Friday
            || (dd == em-3)
            # Memorial Day (last Monday in May)
            || (d >= 25 && w == Monday && m == May)
            # Independence Day (Monday if Sunday or Friday if Saturday)
            || ((d == 4 || (d == 5 && w == Monday) ||
                 (d == 3 && w == Friday)) && m == July)
            # Labor Day (first Monday in September)
            || (d <= 7 && w == Monday && m == September)
            # Thanksgiving Day (fourth Thursday in November)
            || ((d >= 22 && d <= 28) && w == Thursday && m == November)
            # Christmas (Monday if Sunday or Friday if Saturday)
            || ((d == 25 || (d == 26 && w == Monday) || (d == 24 && w == Friday)) && m == December)
            ) 
		return false
	end

    if (y >= 1998) 
        if (# Martin Luther King's birthday (third Monday in January)
            ((d >= 15 && d <= 21) && w == Monday && m == January)
            # President Reagan's funeral
            || (y == 2004 && m == June && d == 11)
            # September 11, 2001
            || (y == 2001 && m == September && (11 <= d && d <= 14))
            # President Ford's funeral
            || (y == 2007 && m == January && d == 2)
            ) 
        	return false
    	end
    elseif (y <= 1980) 
        if (# Presidential election days
            ((y % 4 == 0) && m == November && d <= 7 && w == Tuesday)
            # 1977 Blackout
            || (y == 1977 && m == July && d == 14)
            # Funeral of former President Lyndon B. Johnson.
            || (y == 1973 && m == January && d == 25)
            # Funeral of former President Harry S. Truman
            || (y == 1972 && m == December && d == 28)
            # National Day of Participation for the lunar exploration.
            || (y == 1969 && m == July && d == 21)
            # Funeral of former President Eisenhower.
            || (y == 1969 && m == March && d == 31)
            # Closed all day - heavy snow.
            || (y == 1969 && m == February && d == 10)
            # Day after Independence Day.
            || (y == 1968 && m == July && d == 5)
            # June 12-Dec. 31, 1968
            # Four day week (closed on Wednesdays) - Paperwork Crisis
            || (y == 1968 && dd >= 163 && w == Wednesday)
            ) return false
		end
    else 
    	if (# Nixon's funeral
            (y == 1994 && m == April && d == 27)) 
    		return false
    	end
    end


    return true
end

function isWorkingDay(c::USGovernmentBondCalendar, dt::CalendarTime)
	d=day(dt)
	dd=dayofyear(dt)
	m=month(dt)
	w=dayofweek(dt)
	y=year(dt)
	em=easterMonday(c,y)

	if (isWeekend(c, w)
            # New Year's Day (possibly moved to Monday if on Sunday)
            || ((d == 1 || (d == 2 && w == Monday)) && m == January)
            # Martin Luther King's birthday (third Monday in January)
            || ((d >= 15 && d <= 21) && w == Monday && m == January)
            # Washington's birthday (third Monday in February)
            || ((d >= 15 && d <= 21) && w == Monday && m == February)
            # Good Friday
            || (dd == em-3)
            # Memorial Day (last Monday in May)
            || (d >= 25 && w == Monday && m == May)
            # Independence Day (Monday if Sunday or Friday if Saturday)
            || ((d == 4 || (d == 5 && w == Monday) || (d == 3 && w == Friday)) && m == July)
            # Labor Day (first Monday in September)
            || (d <= 7 && w == Monday && m == September)
            # Columbus Day (second Monday in October)
            || ((d >= 8 && d <= 14) && w == Monday && m == October)
            # Veteran's Day (Monday if Sunday or Friday if Saturday)
            || ((d == 11 || (d == 12 && w == Monday) ||
                 (d == 10 && w == Friday)) && m == November)
            # Thanksgiving Day (fourth Thursday in November)
            || ((d >= 22 && d <= 28) && w == Thursday && m == November)
            # Christmas (Monday if Sunday or Friday if Saturday)
            || ((d == 25 || (d == 26 && w == Monday) ||
                 (d == 24 && w == Friday)) && m == December))
            return false
    end
    return true
end

function isWorkingDay(c::USNERCCalendar, dt::CalendarTime)
	d=day(dt)
	dd=dayofyear(dt)
	m=month(dt)
	w=dayofweek(dt)
	y=year(dt)
	em=easterMonday(c,y)

	if (isWeekend(c, w)
            # New Year's Day (possibly moved to Monday if on Sunday)
            || ((d == 1 || (d == 2 && w == Monday)) && m == January)
            # Memorial Day (last Monday in May)
            || (d >= 25 && w == Monday && m == May)
            # Independence Day (Monday if Sunday)
            || ((d == 4 || (d == 5 && w == Monday)) && m == July)
            # Labor Day (first Monday in September)
            || (d <= 7 && w == Monday && m == September)
            # Thanksgiving Day (fourth Thursday in November)
            || ((d >= 22 && d <= 28) && w == Thursday && m == November)
            # Christmas (Monday if Sunday)
            || ((d == 25 || (d == 26 && w == Monday)) && m == December))
            return false
     end
     return true
end


