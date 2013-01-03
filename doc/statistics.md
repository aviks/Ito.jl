---
layout: default
---

#Functions for financial Statistics

`module Ito.Statistics`

###Weighted moments

The weighted, second, third and fourth moments. All these measures are corrected for sample bias.

`mean(values::AbstractVector, weights::AbstractVector)`

`var(values::AbstractVector, weights::AbstractVector)`

`std(values::AbstractVector, weights::AbstractVector)`

`skewness(values::AbstractVector, weights::AbstractVector)`

`kurtosis(values::AbstractVector, weights::AbstractVector)`

`error_estimate(v::AbstractVector, w::AbstractVector) `
$\sigma / \sqrt N $

###Risk Statistics

`semi_variance(v::AbstractVector, w::AbstractVector) `
Returns the variance of observations below the mean. 
See Markowitz (1959)
$$ \frac{N}{N-1} \mathrm{E}\left[ (x-\langle x \rangle)^2 \;|\;		   x < \langle x \rangle \right] $$

`semi_deviation(v::AbstractVector, w::AbstractVector) `
The square root of semi variance

`downside_variance(v::AbstractVector, w::AbstractVector)` 
The variance of observations below 0.0
$$ \frac{N}{N-1} \mathrm{E}\left[ x^2 \;|\;		   x < 0 \right] $$

`downside_deviation(v::AbstractVector, w::AbstractVector)` 
The square root of the downside variance

`regret(v::AbstractVector, w::AbstractVector, target::Real)`
The variance of observations below target
$$ \frac{N}{N-1} \mathrm{E}\left[ (x-t)^2 \;|\;	x < t \right] $$
See Dembo and Freeman, "The Rules Of Risk", Wiley (2001).

`top_percentile(v::AbstractVector, w::AbstractVector, p::Real) `

`percentile(v::AbstractVector, w::AbstractVector, p::Real) `

`shortfall(v::AbstractVector, w::AbstractVector, target::Real) `
Probability of missing the given target
$$ \mathrm{E}\left[ \Theta \;|\; (-\infty,\infty) \right]  
\\\\ \text  where  \\\\
 \Theta(x) =  \begin{cases}
    1 & x < t \\\\
     0  & x \geq t  \end{cases}  $$

`average_shortfall(v::AbstractVector, w::AbstractVector, target::Real)`
Averaged shorfall below a target
$$ \mathrm{E}\left[ t-x \;|\; x < t \right] $$

`expected_shortfall(v::AbstractVector, w::AbstractVector, p::Real) `
Expected Shortfall at a given percentile. This is the expected loss in case that the loss exceeded a VaR threshold. 
Also know as conditional value-at-risk.
$$ \mathrm{E}\left[ x \;|\; x < \mathrm{VaR}(p) \right ] , p \in [0.9,1) $$
See Artzner, Delbaen, Eber and Heath, "Coherent measures of risk", Mathematical Finance 9 (1999)

`potential_upside(v::AbstractVector, w::AbstractVector, p::Real) `
potential upside (the reciprocal of VAR) at a given percentile $ p \in [0.9,1) $ 

`value_at_risk(v::AbstractVector, w::AbstractVector, p::Real) `
Value at Risk at a given percentile $ p \in [0.9,1) $  

###Guassian Risk Statistics

`gaussian_downside_variance(v::AbstractVector, w::AbstractVector)`
Gaussian assumption downside variance
$$ \frac{N}{N-1} \times \frac{\sum_{i=1}^{N} \theta \times x_i^{2}}{ \sum_{i=1}^{N} w_i} 
\begin{cases}
\theta  = 0  \text{ if } x > 0  \\\\ 
\theta  = 1 \text{ if }  x <0
\end{cases} $$

`gaussian_downside_deviation(v::AbstractVector, w::AbstractVector)`
The square root of the gaussian downside variance

`gaussian_regret(v::AbstractVector, w::AbstractVector, target::Real)`
$$ \frac{\sum w_i (min(0, x_i-target))^2 }{\sum w_i} $$

`gaussian_expected_shortfall(v::AbstractVector, w::AbstractVector, percentile::Real)`
Gaussian assumption expected Shortfall at a given percentile. Also know as conditional value-at-risk.
$$ \mathrm{E}\left[ x \;|\; x < \mathrm{VaR}(p) \right ] , p \in [0.9,1) $$
See Artzner, Delbaen, Eber and Heath, "Coherent measures of risk", Mathematical Finance 9 (1999)

`gaussian_shortfall(v::AbstractVector, w::AbstractVector, target::Real) `
Gaussian assumption shortfall (observations below target) 

`gaussian_average_shortfall(v::AbstractVector, w::AbstractVector, target::Real)`

`gaussian_percentile(v::AbstractVector, w::AbstractVector, percentile::Real)`

`gaussian_top_percentile(v::AbstractVector, w::AbstractVector, percentile::Real)`
$ percentile \in (0,1) $

`gaussian_potential_upside(v::AbstractVector, w::AbstractVector, percentile::Real)`
$ percentile \in [0.9,1) $

`gaussian_value_at_risk(v::AbstractVector, w::AbstractVector, percentile::Real)`
$ percentile \in [0.9,1) $

