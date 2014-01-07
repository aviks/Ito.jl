using Ito
using Ito.Integration

#All the following use the default convergence limit of 1e-9, and max 50 iterations

epsilon = 1e-9

r=integrate((x)->1, AdaptiveSimpsonsIntegration(), 0.0,1)
@assert abs(1 - r ) < epsilon

r=integrate((x)->x, AdaptiveSimpsonsIntegration(), 0.0,1)
@assert abs(1/2 - r ) < epsilon

r=integrate((x)->x*x, AdaptiveSimpsonsIntegration(), 0.0,1)
@assert abs(1/3 - r ) < epsilon

r=integrate(sin, AdaptiveSimpsonsIntegration(), 0,pi)
@assert abs(2-r) < epsilon

r=integrate(cos, AdaptiveSimpsonsIntegration(), 0,pi)
@assert abs(0-r) < epsilon

r=integrate((x)->(sin(x))^2+(sin(x))^2, AdaptiveSimpsonsIntegration(epsilon, 30), 0,2pi)
@assert abs(2pi-r) < epsilon

r=integrate((x)->Distributions.pdf(Distributions.Normal(),x), AdaptiveSimpsonsIntegration(), -10,10)
@assert abs(1-r) < epsilon

epsilon = 1e-6
r=integrate((x)->1/x, AdaptiveSimpsonsIntegration(), 0.01,1)
@assert abs(4.60517 - r ) < epsilon 

r=integrate((x)->(cos(x))^8, AdaptiveSimpsonsIntegration(epsilon, 30), 0,2pi)
@assert abs(35pi/64 - r ) < epsilon 

r=integrate((x)->sin(x) - sin(x^2) + sin(x^3), AdaptiveSimpsonsIntegration(), pi,2pi)
@assert abs(-1.830467 - r) < epsilon  
