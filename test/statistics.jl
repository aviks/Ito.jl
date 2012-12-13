load("Ito")

using Ito.Statistics

v = [ 3.0, 4.0, 5.0, 2.0, 3.0, 4.0, 5.0, 6.0, 4.0, 7.0 ] #data
w = ones(10) #weights

@assert_approx_eq mean(v, w)  4.3
@assert_approx_eq var(v, w)  2.23333333333
@assert_approx_eq std(v, w)  1.4944341181
#answers verified via excel and quantlib
@assert_approx_eq skewness(v, w)  0.359543071407
#Limited by excel precision for comparison. 
#Note: Wolfram alpha produces unadjusted value, Octave produces strange result
@assert_approx_eq_eps kurtosis(v, w)  -0.151799637209 10e-9

w=[1,2,3,4,5,6,7,8,9,10]
@assert_approx_eq mean(v, w) 4.76363636363636

