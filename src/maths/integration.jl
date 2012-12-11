module Integration

export AdaptiveSimpsonsIntegration,
        integrate

abstract IntegrationMethod

type AdaptiveSimpsonsIntegration <: IntegrationMethod
	accuracy::Real
	maxIterations::Int
end
AdaptiveSimpsonsIntegration() = AdaptiveSimpsonsIntegration(1e-9, 50)

function integrate(f::Function, si::AdaptiveSimpsonsIntegration, a::Real, b::Real)
	 c = (a + b)/2 
	 h = b - a                                                                  
     fa = f(a) 
     fb = f(b) 
     fc = f(c)                                                           
  	 S = (h/6)*(fa + 4*fc + fb)                                                                
  return adaptiveSimpsonsR(f, a, b, si.accuracy, S, fa, fb, fc, si.maxIterations) 
end

function adaptiveSimpsonsR(f::Function,  a,  b,  epsilon, S,  fa,  fb,  fc, bottom)                 
   c = (a + b)/2
   h = b - a                                                                  
   d = (a + c)/2
   g = (c + b)/2                                                              
   fd = f(d)
   fe = f(g)                                                                      
   Sleft = (h/12)*(fa + 4*fd + fc)                                                           
   Sright = (h/12)*(fc + 4*fe + fb)                                                          
   S2 = Sleft + Sright                                                                       
  if (bottom <= 0 || abs(S2 - S) <= 15*epsilon)                                                    
    return S2 + (S2 - S)/15
   end                                                                    
  return adaptiveSimpsonsR(f, a, c, epsilon/2, Sleft,  fa, fc, fd, bottom-1) +                    
         adaptiveSimpsonsR(f, c, b, epsilon/2, Sright, fc, fb, fe, bottom-1)                     
end 

end #Module
