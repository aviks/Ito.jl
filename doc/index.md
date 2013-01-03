---
layout: default
---

#Ito, an open source toolkit for financial computing in Julia

##About Ito

Ito is a collection of Julia modules containing algorithms for efficient quantitative finance. 

Think of this as [Quantlib](http://quantlib.org) for Julia. Our API is significantly influenced by Quantlib. 

We are just getting started. However, it is hoped that even in this early state, the implemented algorithms can for an useful basis for your own solutions. We are obviously looking for help -- all contributions are gratefully accepted.

##Installation

```julia
require("pkg")
Pkg.init() #Once per Julia install
Pkg.add("Ito")
```

## Current Status

* Day count conventions are implemented
* Holiday calendar framework, and holiday list for major sites are implemented
* Comprehensive financial statistics are implemented
* Numerical integration algorithm using adaptive Simpsons rule implemented
* Fundamental interest rate calculations are implemented (discount factor etc)
* A framework for term structures is available. Only concrete implementation is a flat term structure. 

##About Julia

Julia is a fast, dynamic language particularly suited for quantitative programs. It includes fast primitives for many required operations (e.g. fast matrix operations, FFTs) and a growing ecosystem for additional quantitative algorithms(e.g. [Distributions](https://github.com/JuliaStats/Distributions.jl) and  [Optimsation](https://github.com/johnmyleswhite/Optim.jl) )

Leveraging Julia allows us to write fast, numerically stable kernels in a high level language. This enables much easier extensions and modifications. It also greatly benefits the use of the library as pedagogic aide. 

Eventually, we also hope to leveage Julia's distributed computing capabilites for efficient distributed algorithms. 

