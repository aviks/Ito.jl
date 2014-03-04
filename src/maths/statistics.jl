module Statistics


import Distributions
using Distributions
using StatsBase
# import Debug
# using Debug

import Base.mean, Base.std, Base.var

export mean, var, std,  
		gaussian_regret, gaussian_percentile, gaussian_top_percentile,  gaussian_shortfall, gaussian_average_shortfall, 
		gaussian_expected_shortfall, gaussian_downside_variance, gaussian_downside_deviation, gaussian_value_at_risk,
		semi_variance, semi_deviation, percentile, top_percentile, downside_variance, downside_deviation, 
		shortfall, average_shortfall, expected_shortfall, value_at_risk, regret

#if !isdefined(Main.StatsBase,:weights)
#   weights(x) = x
#   mean(v::AbstractVector, w::AbstractVector) = sum(v.*w)/sum(w)
#end

function var(v::AbstractVector, w::AbstractVector, m) 
	n=length(v)
	@assert (n>1)
	s=expectation_value(v, w, (x)->(x-m)^2, (x)->true) [1]
	
	return s*n/(n-1)
end
std(v::AbstractVector, w::AbstractVector) = sqrt(var(v, w))

var(v::AbstractVector, w::AbstractVector) = var(v, w, mean(v,weights(w)))

gaussian_downside_variance(v::AbstractVector, w::AbstractVector) = gaussian_regret(v,w,0)
gassian_downside_deviation(v::AbstractVector, w::AbstractVector) = sqrt(gaussian_downside_variance(v,w))

#Dembo, Freeman "The Rules Of Risk", Wiley (2001)
function gaussian_regret(v::AbstractVector, w::AbstractVector, target::Real)
	m=mean(v,weights(w))
	s = std(v, w)
	variance = var(v, w)
	f1 = variance + m*m -2*target*m + target*target
	d=Normal(m, s)
	alpha = cdf(d, target)
	f2 = m-target
	beta = variance*pdf(d, target)
	(alpha*f1 - beta*f2) / alpha
end

function gaussian_percentile(v::AbstractVector, w::AbstractVector, percentile::Real)
	@assert percentile > 0 && percentile < 1.0
	m=mean(v,weights(w))
	s=stdm(v,m)
	quantile(Normal(m,s), percentile)
end

gaussian_top_percentile(v::AbstractVector, w::AbstractVector, percentile::Real)=gaussian_percentile(v,w,1-percentile)

function gaussian_potential_upside(v::AbstractVector, w::AbstractVector, percentile::Real)
	@assert percentile <1.0 && percentile >= 0.9
	max(gaussian_percentile(v,w,percentile),0.0)
end

function gaussian_value_at_risk(v::AbstractVector, w::AbstractVector, percentile::Real)
	@assert percentile <1.0 && percentile >= 0.9
	-1*min(gaussian_percentile(v,w,1-percentile),0.0)
end

#Artzner, Delbaen, Eber and Heath, "Coherent measures of risk", Mathematical Finance 9 (1999)
function gaussian_expected_shortfall(v::AbstractVector, w::AbstractVector, percentile::Real)
	@assert percentile <1.0 && percentile >= 0.9
	m=mean(v,weights(w))
	s=stdm(v,m)
	d=Normal(m,s)
	var = quantile(1-percentile)
	g=pdf(d, var)
	r=m-s*s*g/(1-percentile)
	return -1*min(r,0)
end

function gaussian_shortfall(v::AbstractVector, w::AbstractVector, target::Real) 
	m=mean(v,weights(w))
	s=stdm(v,m)
	cdf(Normal(m,s), target)
end

function gaussian_average_shortfall(v::AbstractVector, w::AbstractVector, target::Real)
	m=mean(v,weights(w))
	s=stdm(v,m)
	d=Normal(m,s)
	g=pdf(d,target)
	gi=cdf(d, target)

	(target - m) + s*s*g/gi
end

error_estimate(v::AbstractVector, w::AbstractVector) = sqrt(var(v,w)/length(v))

semi_variance(v::AbstractVector, w::AbstractVector) = regret(v, mean(v,weights(w)))
semi_deviation(v::AbstractVector, w::AbstractVector) = sqrt(semi_variance(v,weights(w)))

downside_variance(v) = regret(v, 0)
downside_deviation(v) = sqrt(downside_variance(v))

#Dembo and Freeman, "The Rules Of Risk", Wiley (2001)
function regret(v::AbstractVector, w::AbstractVector, target::Real) 
	n=length(v)
	(r,_)=expectation_value(v, w, (x)->(x-target)^2, (x)->(x<target))
	r*n/(n-1)
end

potential_upside(v::AbstractVector, w::AbstractVector, p::Real) = max(percentile(v,w,p),0)
value_at_risk(v::AbstractVector, w::AbstractVector, p::Real) = -1*min(percentile(v,w,1-p),0)

#Artzner, Delbaen, Eber and Heath, "Coherent measures of risk", Mathematical Finance 9 (1999)
function expected_shortfall(v::AbstractVector, w::AbstractVector, p::Real) 
	@assert p>= 0.9 && p <1
	target = -1* value_at_risk(v, w, p)

	(r,n)=expectation_value(v, w, (x)->(x), (x)->(x<target))
	return -1 * min(r, 0.0)
end

function average_shortfall(v::AbstractVector, w::AbstractVector, target::Real)
	return expectation_value(v, w, (x)->(target-x), (x)->(x<target)) [1]
end

function shortfall(v::AbstractVector, w::AbstractVector, target::Real) 
	return expectation_value(v, w, (x)->(1), (x)->(x<target)) [1]
end

function expectation_value(v::AbstractVector, w::AbstractVector, mapfun::Function, filterfun::Function)
	@assert length(v) == length(w)
	@assert length(v) >0

	s=0
	sw=0
	n=0
	for i in 1:length(v)
		if filterfun(v[i])
			s = s + mapfun(v[i])*w[i]
			sw = sw + w[i]
			n=n+1
		end
	end

	if n==0
		 return NaN, 0
	end
	return s/sw , n 
end


#Weighted percentile. 
#Warning! Both value and weight arrays are copied and sorted
function percentile(v::AbstractVector, w::AbstractVector, p::Real) 
	@assert p>0 && p<1
	wts = sum(w)
	@assert wts > 0
	vs, ord = Base.sortperm(v)

	k=1; l=length(v)
	i = w[ord[k]]
	target = p*wts

	while (i<target && k!=l)
		k=k+1
		i = i + w[ord[k]]
	end
	return vs[k]
end

function top_percentile(v::AbstractVector, w::AbstractVector, p::Real) 
	@assert p>0 && p<1
	wts = sum(w)
	@assert wts > 0
	vs, ord = Base.sortperm(v)

	l=1; k=length(v)
	i = w[ord[k]]
	target = p*wts

	while (i<target && k!=l)
		k=k-1
		i = i + w[ord[k]]
	end
	return vs[k]
end

function kurtosis(v::AbstractVector, w::AbstractVector, m, corrected::Bool)
	n=length(v)
	vv=v-m
	y,_=expectation_value(v, w, (x)->(x-m)^3, (x)->true)
	if corrected
		@assert n>3
		c1=(n/(n-1.0)) * (n/(n-2.0)) * ((n+1.0)/(n-3.0))
		c2=3.0 * ((n-1.0)/(n-2.0)) * ((n-1.0)/(n-3.0));
		#(n*(n+1)*k)/((n-1)*(n-2)*(n-3))  - 3*(n-1)*(n-1)/( (n-2)*(n-3))   
		c1*y/(var(v)^2) -c2
	else 
		k - 3
	end
end


end
