#fonction g2 représentant l'option 2 pour Runge-Kutta

function g = g2 (q0)
  global MASSE_VOL_AIR;
  global AIRE_BALLE;
  global COEFFICIENT_V;
  global MASSE_BALLE;
  
  vitesse_balle = [q0(1) q0(2) q0(3)];
  acceleration_gravitationnelle = [0 0 -9.8];
  
  norme_vitesse = norm(vitesse_balle);
  
  coefficient_frottement = -(MASSE_VOL_AIR*COEFFICIENT_V*AIRE_BALLE*norme_vitesse)/2;
  acceleration_frottement_visqueux = coefficient_frottement*vitesse_balle/MASSE_BALLE;
  acceleration = acceleration_gravitationnelle + acceleration_frottement_visqueux;

  g = [acceleration(1) acceleration(2) acceleration(3) ...
        (q0(1)) (q0(2)) (q0(3)) ...
        0 0 0];
endfunction