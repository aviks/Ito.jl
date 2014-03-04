require("Ito")
using Base.Test
using Ito.Statistics
using StatsBase

v = [ 3.0, 4.0, 5.0, 2.0, 3.0, 4.0, 5.0, 6.0, 4.0, 7.0 ] #data
w = ones(10) #weights
n=10

@test_approx_eq mean(v, weights(w))  4.3
@test_approx_eq var(v, w)  2.23333333333
@test_approx_eq std(v, w) 1.4944341180973264 
#answers verified via excel and quantlib
@test_approx_eq skewness(v, weights(w))*(sqrt(n*(n-1))/(n-2))  0.359543071407
#Limited by excel precision for comparison. 
#Note: Wolfram alpha produces unadjusted value, Octave produces strange result
#@test_approx_eq_eps kurtosis(v, w)  -0.151799637209 10e-9

@test_approx_eq regret(v, w, 4) 2.2222222222222223
@test_approx_eq average_shortfall(v, w, 4) 1.3333333333333333

w=[1:10]
@test_approx_eq mean(v, weights(w)) 4.76363636363636

#TODO Lots more tests with realistic data

