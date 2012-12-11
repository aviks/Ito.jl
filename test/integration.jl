load("Ito")
using Ito.Integration

#All the following use the default convergence limit of 1e-9, and max 50 iterations

epsilon = 1e-9
r=Ito.Integration.integrate(sin, Ito.Integration.AdaptiveSimpsonsIntegration(), 0,pi)
@assert abs(2-r) < epsilon

r=Ito.Integration.integrate(cos, Ito.Integration.AdaptiveSimpsonsIntegration(), 0,pi)
@assert abs(0-r) < epsilon

r=Ito.Integration.integrate((x)->(sin(x))^2+(sin(x))^2, Ito.Integration.AdaptiveSimpsonsIntegration(epsilon, 30), 0,2pi)
@assert abs(2pi-r) < epsilon

epsilon = 1e-5
r=Ito.Integration.integrate((x)->1/x, Ito.Integration.AdaptiveSimpsonsIntegration(), 0.01,1)
@assert abs(4.60517 - r ) < epsilon

r=Ito.Integration.integrate((x)->(cos(x))^8, Ito.Integration.AdaptiveSimpsonsIntegration(epsilon, 30), 0,2pi)
@assert abs(35pi/64 - r ) < epsilon