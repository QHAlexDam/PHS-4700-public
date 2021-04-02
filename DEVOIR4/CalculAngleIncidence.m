function angle_incidence = CalculAngleIncidence (normale, direction)
  
  %calcul plan d'incidence
  j = cross(direction, normale);
  j = j/norm(j);
  k = cross(normale, j);
  k = k/norm(k);
  
  %angle d'incidence du rayon
  angle_incidence = asin(dot(direction, k));
  
endfunction
