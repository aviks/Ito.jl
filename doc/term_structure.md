---
layout: default
---

#Term Structures

###Time value of money

`compound_factor(rate, compounding, freq,  time)`
`compound_factor(rate, compounding, freq,  daycount_convention, dates...)`
The compoounding factor for the specified annual rate, with the given compounding type and frequency. Either a time is specified as a fraction of year, or a daycount convention and a series of days. Usually, two dates are specified (the start and end dates). However, for the `ISMAActualActual` daycount convention, four dates are required (the start and end dates, and the reference start and end dates). The frequency may be omitted if compounding is `Simple` or `Continuous`; it is not used in those cases. 

Compounding type is specified as a symbol, and can be one of 

```julia
:Simple
:Compounded
:Continuous
:SimpleThenCompounded
```

Frequency can be specified either as a symbol, or as an integer variable that denotes the divisor of the year. The following variables are allowed:

```julia
NoFrequency       	= -1
Once			 	= 0 
Annual				= 1 
Semiannual			= 2 
EveryFourthMonth  	= 3 
Quarterly		 	= 4 
Bimonthly		 	= 6 
Monthly				= 12
EveryFourthWeek  	= 13
Biweekly		 	= 26
Weekly				= 52
Daily			 	= 365
OtherFrequency   	= 999
```
discount_factor(x...)
The discount factor for a specified rate, with the given compounding type and frequency. The reciprocal of the compound factor. The parameters to the discount factor function are exactly the same as the `compound_factor` function. 

`implied_rate(comp, compounding, freq,  time)`
`implied_rate(comp, compounding, freq,  daycount_convention, dates...)`
The implied interest rate given a particular compound factor

Examples:

```julia
compound_factor(0.7, :Compounded, :Annual, Actual360(), today(), today()+days(360)) #1.7
compound_factor(0.7, :Compounded, :Semiannual, Actual360(), today(), today()+days(360)) #1.035^2
discount_factor(0.7, :Compounded, :Annual, Actual360(), today(), today()+days(360)) #1/1.7
```


###Term Structure

Any interest rate term structure implementation must extend the abstract `YieldTermStructure`. The term structure type must store its day count conventions as an attribute `dc`. It must provide an implementation of the `discount(ts::YieldTermStructure, time::Real)` function, where, as usual, time is specified as fractions or multiples of a year . 

A term structure must also specify its reference date, either via a `reference_date` attribute on the type, or by implementing a `reference_date(ts::YieldTermStructure)` method. All other functions of a `YieldTermStructure` are defined via the abstract type.

`discount(ts::YieldTermStructure, d::CalendarTime)`
The discount factor from the reference date to the input date, counted according to the daycount convention of the term structure

`forward_rate(ts::YieldTermStructure, compounding, freq, date_start, date_end)`
`forward_rate(ts::YieldTermStructure, compounding, freq, time_start, time_end)`
The forward rate between two specified dates or times. When the input is a date, the time calculated as year fractions from the reference date. If the date is the same as the reference date, the instantaneous forward rate is returned. 

`zero_rate(ts::YieldTermStructure, compounding, freq, date)`
`zero_rate(ts::YieldTermStructure, compounding, freq, time)`
The implied zero yield rate at the specified date or time. When the input is a date, the time calculated as year fractions from the reference date. 

`par_rate(ts::YieldTermStructure, compounding, freq, date_array)`
`par_rate(ts::YieldTermStructure, compounding, freq, time_array)`
Implied par rate for a sequence of payments at the specified dates or times. The first date is the valuation date, and the other dates are payment dates.

###Flat Term Structure

The `FlatYieldTermStructure <: YieldTermStructure` is a concrete type defines a term structure with a constant rate. 

`FlatYieldTermStructure(dc::DayCount, rate::Real)`
Create a FlatYieldTermStructure with the specified day count convention and annualised interest rate. 

