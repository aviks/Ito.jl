
load("Ito")

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
#New Year, Sunday
@assert !isWorkingDay(c, ymd(2012, January, 1))
#Republic Day
@assert !isWorkingDay(c, ymd(2012, January, 26))
#Shivratri
@assert !isWorkingDay(c, ymd(2012, February, 20))
#Holi
@assert !isWorkingDay(c, ymd(2012, March, 8))
#Ram Navami, Sunday
@assert !isWorkingDay(c, ymd(2012, April, 1))
#Mahavir Jayanti
@assert !isWorkingDay(c, ymd(2012, April, 5))
#Good Friday
@assert !isWorkingDay(c, ymd(2012, April, 6))
#Ambedkar Jayanti, Saturday
@assert !isWorkingDay(c, ymd(2012, April, 14))
#May Day
@assert !isWorkingDay(c, ymd(2012, May, 1))
#Independence Day
@assert !isWorkingDay(c, ymd(2012, August, 15))
#Ramzan
@assert !isWorkingDay(c, ymd(2012, August, 20))
#Ganesh Chaturthi
@assert !isWorkingDay(c, ymd(2012, September, 19))
#Gandhi Jayanti
@assert !isWorkingDay(c, ymd(2012, October, 2))
#Dussera
@assert !isWorkingDay(c, ymd(2012, October, 24))
#Bakri Id, Saturday
@assert !isWorkingDay(c, ymd(2012, October, 27))
#Diwali
@assert !isWorkingDay(c, ymd(2012, November, 14))
#Moharram, Sunday
@assert !isWorkingDay(c, ymd(2012, November, 25))
#Guru Nanak Jayanti
@assert !isWorkingDay(c, ymd(2012, November, 28))
#Christmas
@assert !isWorkingDay(c, ymd(2012, December, 25))


