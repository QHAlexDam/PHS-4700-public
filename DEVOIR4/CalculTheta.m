function angle = CalculTheta (isMin)
  
  %VARIABLES GLOBALES
  global cylindre;
  global observateur;
  zpos_bas = (cylindre.cdm(3)-cylindre.hauteur/2);
  if(isMin)
    angle = atan((sqrt(cylindre.cdm(1)^2+cylindre.cdm(2)^2)-cylindre.rayon)/(cylindre.cdm(3)+cylindre.hauteur/2-observateur.position(3)));
  else
    if (observateur.position(3) < zpos_bas) %cas si l'observateur regarde du dessous
      angle = atan((sqrt(cylindre.cdm(1)^2+cylindre.cdm(2)^2)+cylindre.rayon)/(zpos_bas-observateur.position(3)));
    else
      angle = pi+atan((sqrt(cylindre.cdm(1)^2+cylindre.cdm(2)^2)-cylindre.rayon)/(zpos_bas-observateur.position(3)));
    end
  end
  
endfunction
