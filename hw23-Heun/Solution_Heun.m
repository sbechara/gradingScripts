function [t,y] = Heun(dydt,tspan,y0,h,es,maxit)
  
  if nargin<6, maxit=50; end
  if nargin<5, es = 0.001; end
    
  ti = tspan(1);
  tf = tspan(2);
  t = (ti:h:tf)';
  n = length(t);
  
  % if necessary add an additional value of t so range goes t = ti to tf
  if t(n) < tf
    t(n+1) = tf;
    n = n + 1;
  end
  
  y = y0 * ones(n,1); % preallocate to improve efficiency
  
  iter = 0;
  ea = 100;
  
  for i = 1:n-1
    m1 = feval(dydt,t(i),y(i));
    y(i+1) = y(i) + m1*h;
    ea = 100;
    iter = 0;
    
    while ea >= es && iter <= maxit
      yold = y(i+1);
      m2 = feval(dydt,t(i+1),y(i+1));
      y(i+1) = y(i) + h*(m1+m2)/2;
      iter = iter + 1;
      
      if y(i+1) ~= 0
        ea = abs((y(i+1) - yold) / y(i+1)) * 100;
      end
    end
  end
  
  plot(t,y)
end
