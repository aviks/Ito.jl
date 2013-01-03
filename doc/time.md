---
layout: default
---

#Date and Time 

`module Ito.Time`

### Day count conventions
	
Day count conventions are specified via the following types:

    DayCount
    +- Actual360
    +- Business252
    +- Actual365
    +- Thirty360
       +- BondThirty360
       +- EuroBondThirty360
       +- ItalianThirty360
    + ActualActual 
       +- ISMAActualActual
       +- ISDAActualActual
       +- AFBActualActual


`Business252(BusinessCalendar bc)`
Create an instance `Business252` day count convention, with a `BusinessCalendar` as an input. All other day count conventions have a zero argument constructor. 

`daycount(dc::DayCount, date_start, date_end)`
Number of days between the two dates, counted according the specified daycount convention

`yearfraction(dc::Daycount, date_start, date_end)`
Number of days between the two dates, divided by the number of days in a year, according to the specified daycount convention

`yearfraction(dc::ISMAAActualActual, date_start, date_end, reference_date_start, reference_date_end)`
Year fraction for the ISMAA Actual/Actual daycount convention, which requires as input the reference start and end dates, typically the coupon dates.  

###HolidayCalendars

Holiday Calendars are specified using a heirarchy of types. Typically an abstract type is present for a country, and composite types for each specific market within the country. All the composite types can be created via a zero argument constructor

The following types are present currently. More types will be added as further holiday calendars are implemented

    BusinessCalendar
    +- OrthodoxCalendar
    +- WesternCalendar
       +- UKCalendar
          +- UKSettlementCalendar
          +- UKLMECalendar
          +- UKLSECalendar
       +- USCalendar
          +- USSettlementCalendar
          +- USGovernmentBondCalendar
          +- USNERCCalendar
          +- USNYSECalendar
       +- IndiaCalendar
          +IndiaNSECalendar

`isWorkingDay(c::BusinessCalendar, date)`
Returns false if the input date is a holiday in the specified calendar, true otherwise

`businessDaysBetween(c::BusinessCalendar, from, to, includeFirst::Bool,  includeLast::Bool) `

`businessDaysBetween(c::BusinessCalendar, from, to) `
The number of business days between two days