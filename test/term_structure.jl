require("Ito")

using Calendar
using Ito.Time
using Ito.TermStructure


@test_approx_eq 1.7 compound_factor(0.7, :Compounded, Ito.TermStructure.Annual, Actual360(), today(), today()+days(360))
@test_approx_eq 1.35^2 compound_factor(0.7, :Compounded, Ito.TermStructure.Semiannual, Actual360(), today(), today()+days(360))

@test_approx_eq 1/1.7 discount_factor(0.7, :Compounded, Ito.TermStructure.Annual, Actual360(), today(), today()+days(360))
