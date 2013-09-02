
using Ito
using Base.Test

using Calendar
using Ito.Time


#2010 UK LSE Holidays
c=UKLSECalendar(); year=2010
@assert !isWorkingDay(c, ymd(2010, January, 1))
@assert !isWorkingDay(c, ymd(2010, April, 2))
@assert !isWorkingDay(c, ymd(2010, April, 5))
@assert !isWorkingDay(c, ymd(2010, May, 3))
@assert !isWorkingDay(c, ymd(2010, May, 31))
@assert !isWorkingDay(c, ymd(2010, August, 30))
@assert !isWorkingDay(c, ymd(2010, December, 25)) #Saturday
@assert !isWorkingDay(c, ymd(2010, December, 27))
@assert !isWorkingDay(c, ymd(2010, December, 28))

#US Calendars
@assert !isWorkingDay(USSettlementCalendar(), ymd(2012, July, 4))
@assert !isWorkingDay(USNYSECalendar(), ymd(2012, July, 4))
@assert !isWorkingDay(USGovernmentBondCalendar(), ymd(2012, July, 4))
@assert !isWorkingDay(USNERCCalendar(), ymd(2012, July, 4))

#2012 India LSE Calendar

c=IndiaNSECalendar()

@assert !isWorkingDay(c, ymd(2012, January, 1)) #New Year, Sunday
@assert !isWorkingDay(c, ymd(2012, January, 26)) #Republic Day
@assert !isWorkingDay(c, ymd(2012, February, 20)) #Shivratri
@assert !isWorkingDay(c, ymd(2012, March, 8)) #Holi
@assert !isWorkingDay(c, ymd(2012, April, 1)) #Ram Navami, Sunday
@assert !isWorkingDay(c, ymd(2012, April, 5)) #Mahavir Jayanti
@assert !isWorkingDay(c, ymd(2012, April, 6)) #Good Friday
@assert !isWorkingDay(c, ymd(2012, April, 14)) #Ambedkar Jayanti, Saturday
@assert !isWorkingDay(c, ymd(2012, May, 1)) #May Day
@assert !isWorkingDay(c, ymd(2012, August, 15)) #Independence Day
@assert !isWorkingDay(c, ymd(2012, August, 20)) #Ramzan
@assert !isWorkingDay(c, ymd(2012, September, 19)) #Ganesh Chaturthi
@assert !isWorkingDay(c, ymd(2012, October, 2)) #Gandhi Jayanti
@assert !isWorkingDay(c, ymd(2012, October, 24)) #Dussera
@assert !isWorkingDay(c, ymd(2012, October, 27)) #Bakri Id, Saturday
@assert !isWorkingDay(c, ymd(2012, November, 14)) #Diwali
@assert !isWorkingDay(c, ymd(2012, November, 25)) #Moharram, Sunday
@assert !isWorkingDay(c, ymd(2012, November, 28)) #Guru Nanak Jayanti
@assert !isWorkingDay(c, ymd(2012, December, 25)) #Christmas

#DayCount

@test_approx_eq 0.497724380567 yearfraction(ISDAActualActual(), ymd(2003,November,1), ymd(2004, May, 1))
@test_approx_eq 0.50 yearfraction(ISMAActualActual(), ymd(2003,November,1), ymd(2004, May, 1))
@test_approx_eq 0.497267759563 yearfraction(AFBActualActual(), ymd(2003,November,1), ymd(2004, May, 1))

@test_approx_eq 0.410958904110 yearfraction(ISDAActualActual(), ymd(1999,February,1), ymd(1999, July, 1))
@test_approx_eq 0.410958904110 yearfraction(ISMAActualActual(), ymd(1999,February,1), ymd(1999, July, 1), ymd(1998, July, 1), ymd(1999, July, 1))
@test_approx_eq 0.410958904110 yearfraction(AFBActualActual(), ymd(1999,February,1), ymd(1999, July, 1))

@test_approx_eq_eps 1.001377348600 yearfraction(ISDAActualActual(), ymd(1999,July,1), ymd(2000, July, 1)) 1e-10
@test_approx_eq 1 yearfraction(ISMAActualActual(), ymd(1999,July,1), ymd(2000, July, 1), ymd(1999, July, 1), ymd(2000, July, 1))
@test_approx_eq 1 yearfraction(AFBActualActual(), ymd(1999,July,1), ymd(2000, July, 1)) 

@test_approx_eq 0.915068493151 yearfraction(ISDAActualActual(), ymd(2002,August,15), ymd(2003, July, 15))
@test_approx_eq 0.915760869565 yearfraction(ISMAActualActual(), ymd(2002,August,15), ymd(2003, July, 15), ymd(2003, January, 15), ymd(2003, July, 15))
@test_approx_eq 0.915068493151 yearfraction(AFBActualActual(), ymd(2002,August,15), ymd(2003, July, 15))

@test_approx_eq 0.504004790778 yearfraction(ISDAActualActual(), ymd(2003,July,15), ymd(2004, January, 15))
@test_approx_eq 0.5 yearfraction(ISMAActualActual(), ymd(2003,July,15), ymd(2004, January, 15), ymd(2003, July, 15), ymd(2004, January, 15))
@test_approx_eq 0.504109589041 yearfraction(AFBActualActual(), ymd(2003,July,15), ymd(2004, January, 15))

@test_approx_eq 0.503892506924 yearfraction(ISDAActualActual(), ymd(1999,July,30), ymd(2000, January, 30))
@test_approx_eq 0.5 yearfraction(ISMAActualActual(), ymd(1999,July,30), ymd(2000, January, 30), ymd(1999,July,30), ymd(2000, January, 30))
@test_approx_eq 0.504109589041 yearfraction(AFBActualActual(), ymd(1999,July,30), ymd(2000, January, 30))

@test_approx_eq 0.415300546448 yearfraction(ISDAActualActual(), ymd(2000,January,30), ymd(2000, June, 30))
@test_approx_eq 0.417582417582 yearfraction(ISMAActualActual(), ymd(2000,January,30), ymd(2000, June, 30), ymd(2000,January,30), ymd(2000, July, 30))
@test_approx_eq 0.415300546448 yearfraction(AFBActualActual(), ymd(2000,January,30), ymd(2000, June, 30))



