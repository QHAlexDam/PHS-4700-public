function isReflected = IsReflected (angle_incidence, n1, n2)
  
  isReflected = false;
  angle_critique = asin(n2/n1);
  
  %verification des conditions pour une reflexion totale interne
  if(n1 > n2)
    if(angle_incidence > angle_critique || angle_incidence < -angle_critique)
      isReflected = true;
    endif
  endif

endfunction