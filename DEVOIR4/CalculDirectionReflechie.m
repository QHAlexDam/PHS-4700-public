function direction_reflechie = CalculDirectionReflechie (normale, direction)
  
  %calcul plan d'incidence
  j = cross(direction, normale)/norm(cross(direction, normale));
  k = cross(normale, j)/norm(cross(normale, j));
  
  %angle d'incidence du rayon
  s = dot(direction, k);
  angle_incidence = asin(dot(direction, k));
  
  direction_reflechie = normale*sqrt(1-s^2) + k*s;
  direction_reflechie = direction_reflechie/norm(direction_reflechie);
  
endfunction