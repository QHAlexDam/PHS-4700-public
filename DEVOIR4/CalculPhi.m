function angle = CalculPhi (isMin)
  
  %VARIABLES GLOBALES
  global cylindre;
  oppose = cylindre.cdm(2);
  adjacent = cylindre.cdm(1);
  angleGauche = 10*pi/6;
  angleDroite = 5*pi/6;
  if(isMin)
    angle = atan((oppose+2*sin(angleGauche))/(adjacent+2*cos(angleGauche)));
  else
    angle = atan((oppose+2*sin(angleDroite))/(adjacent+2*cos(angleDroite)));
  end
  
endfunction