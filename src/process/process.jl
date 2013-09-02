module Process

using Ito.Time
using Ito.TermStructure
using Calendar

#Stochastic processes
abstract StochasticProcess

evolve(sp::StochasticProcess, t0::Real, x0, dt::Real, dw) = (x0 + drift_discretize(t0, x0, dt) + diffusion_discretize(t0,x0,dt)) * dw
covariance(sp::StochasticProcess, t0::Real, x0, dt::Real) = covariance_discretize(sp, t0, x0, dt)

#Euler discretization functions
drift_discretize(sp::StochasticProcess, t0::Real, x0::AbstractVector, dt::Real) = drift(sp, t0, x0) .* dt

diffusion_discretize(sp::StochasticProcess, t0::Real, x0::AbstractVector, dt::Real) = diffusion(sp, t0, x0) .* sqrt(dt)

function covariance_discretize(sp::StochasticProcess, t0::Real, x0, dt::Real) 
	s= diffusion(sp, t0, x0) 
	( s * s' ) .* dt
end

variance_discretize(sp::StochasticProcess, t0::Real, x0::Real,dt::Real) = covariance_discretize(sp, t0, x0, dt)




type GenericBlackScholesProcess
	ts::YieldTermStructure
	vol::VolatilityTermStructure

end









end #module
