#Ito, an open source toolkit for financial computing in Julia

##About Ito

Ito is a collection of Julia modules containing algorithms for efficient quantitative finance. 

Think of this as [Quantlib](http://quantlib.org) for Julia. Our API is significantly influenced by Quantlib. 

This is an ambitious undertaking, and we are just getting started. However, it is hoped that even in this early state, the implemented algorithms can for an useful basis for your own solutions. We are obviously looking for help -- all contributions are gratefully accepted.

## Current Status

* Day count conventions are implemented
* Holiday calendar framework, and holiday list for major sites are implemented
* Comprehensive financial statistics are implemented
* Numerical integration algorithm using adaptive Simpsons rule implemented
* Fundamental interest rate calculations are implemented (discount factor etc)

##About Julia

Julia is a fast, dynamic language particularly suited for quantitative programs. It includes fast primitives for many required operations (e.g. fast matrix operations, FFTs) and a growing ecosystem for additional quantitative algorithms(e.g. [Distributions](https://github.com/JuliaStats/Distributions.jl) and  [Optimsation](https://github.com/johnmyleswhite/Optim.jl) )

The performance of the Julia interpreter (based on LLVM) means that almost all Julia primitives are implemented in Julia itself. For our purposes, this means that we get the power, expressiveness and productivity of writing quantitative techniques in a high level language, while still getting the speed of a low level implementation. This fact has a few important side effects

* Its much easier to understand existing codebases, and therefore contribute
* Julia is therefore highly suited for all pedagogic requirements 
* Kernels and objective functions can be written in Julia itself, which can then be passed to optimisation routines in Julia. This makes for a much smoother programming experience, while still maintaining performance. 
* Eventually, we will be able to leverage Julia's distributed computing capabilities to write efficient distributed algorithms. 