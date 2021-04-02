function direction_transmise = CalculDirectionTransmise (normale, direction, nin, nout)
  %VARIABLES GLOBALES
  
  %calcul plan d'incidence
  j = cross(direction, normale)/norm(cross(direction, normale));
  k = cross(normale, j)/norm(cross(normale, j));
  
  %angle d'incidence du rayon
  s=dot(direction, k);
  angle_incidence = asin(dot(direction, k));
  
  angle_transmis = asin((nout/nin)*s);
  
  direction_transmise = (-normale*sqrt(1-((sin(angle_transmis))^2))) + k*s;
  direction_transmise = direction_transmise/norm(direction_transmise);
  
endfunction