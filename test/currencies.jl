require("Ito")
using Base.Test
using Ito.Currencies

# Testing money arithmetic without conversions...

EUR=Currencies.EURCurrency()

m1 = 50000.0 * EUR;
m2 = 100000.0 * EUR;
m3 = 500000.0 * EUR;

Currencies.setConversionType(:NoConversion)

calculated = m1*3.0 + 2.5*m2 - m3/5.0
x = m1.value*3.0 + 2.5*m2.value - m3.value/5.0
expected=Currencies.Money(x, EUR)

@test calculated==expected

# Testing money arithmetic with conversion to base currency...

EUR=Currencies.EURCurrency()
GBP=Currencies.GBPCurrency()
USD=Currencies.USDCurrency()

m1 = 50000.0 * GBP
m2 = 100000.0 * EUR
m3 = 500000.0 * USD

Currencies.clear()

eur_usd=Currencies.ExchangeRate(EUR, USD, 1.2042)
eur_gbp=Currencies.ExchangeRate(EUR, GBP, 0.6612)
Currencies.add(eur_usd)
Currencies.add(eur_gbp)


Currencies.setConversionType(:BaseCurrencyConversion)
Currencies.setStaticBaseCurrency(EUR)


calculated=m1*3.0+2.5*m2-m3/5.0
_round=Currencies.baseCurrency(m1).rounding
x=_round(m1.value*3.0/eur_gbp.rate)+2.5*m2.value-_round(m3.value/(5.0*eur_usd.rate))
expected=Currencies.Money(x, EUR)

Currencies.setConversionType(:NoConversion)

@test calculated==expected

# Testing money arithmetic with automated conversion...

EUR=Currencies.EURCurrency()
GBP=Currencies.GBPCurrency()
USD=Currencies.USDCurrency()

m1 = 50000.0 * GBP
m2 = 100000.0 * EUR
m3 = 500000.0 * USD

Currencies.clear()

eur_usd=Currencies.ExchangeRate(EUR, USD, 1.2042)
eur_gbp=Currencies.ExchangeRate(EUR, GBP, 0.6612)
Currencies.add(eur_usd)
Currencies.add(eur_gbp)

Currencies.setConversionType(:AutomatedConversion)

calculated=(m1*3.0+2.5*m2)-m3/5.0
_round=m1.currency.rounding
x=m1.value*3.0+_round(2.5*m2.value*eur_gbp.rate)-_round((m3.value/5.0)*eur_gbp.rate/eur_usd.rate)
expected=Currencies.Money(x, GBP)

Currencies.setConversionType(:NoConversion)

@test calculated==expected
