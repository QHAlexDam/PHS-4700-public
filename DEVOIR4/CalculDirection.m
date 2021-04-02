function direction = CalculDirection (theta, phi)
  
  direction = [sin(theta)*cos(phi) sin(theta)*sin(phi) cos(theta)];
  
endfunction
