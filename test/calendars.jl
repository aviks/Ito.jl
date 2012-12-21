
load("Ito")
load("test/runtests")

using Calendar
using Ito
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

@assert_approx_eq 0.497724380567 Ito.Time.yearfraction(Ito.Time.ISDAActualActual(), ymd(2003,November,1), ymd(2004, May, 1))
@assert_approx_eq 0.50 Ito.Time.yearfraction(Ito.Time.ISMAActualActual(), ymd(2003,November,1), ymd(2004, May, 1))
@assert_approx_eq 0.497267759563 Ito.Time.yearfraction(Ito.Time.AFBActualActual(), ymd(2003,November,1), ymd(2004, May, 1))

