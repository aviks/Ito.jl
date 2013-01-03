---
layout: default
---

#Basic Mathematical Routines

Some of these might be moved into their own packages eventaully

### Integrations

`module Ito.Integration` 

`integrate(f, method, a, b)`
$$ \int_{a}^{b} f(x) dx $$
	
The only integration method currently implemented is `AdaptiveSimpsonsIntegration`

`AdaptiveSimpsonsIntegration(accuracy, maximum_iterations)`

`AdaptiveSimpsonsIntegration()`
Default accuracy of $10^{-9}$ and default maximum of $50$ iterations

Examples:

```julia
integrate(cos, AdaptiveSimpsonsIntegration(), 0,pi)  # 2

integrate((x)->(sin(x))^2+(sin(x))^2, 
          AdaptiveSimpsonsIntegration(10e-9, 30), 0,2pi) # 2pi

using Distributions
integrate((x)->pdf(Normal(),x), AdaptiveSimpsonsIntegration(), -10,10) # 1.0
```