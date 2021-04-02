#fonction g3 représentant l'option 3 pour Runge-Kutta

function g = g3 (q0)
  global MASSE_VOL_AIR;
  global AIRE_BALLE;
  global MASSE_BALLE;
  global RAYON_BALLE;
  global COEFFICIENT_V;
  global COEFFICIENT_MAGNUS;
  global VITESSE_ANGULAIRE;
  
  vitesse_balle = [q0(1) q0(2) q0(3)];
  vitesse_angulaire = [q0(7) q0(8) q0(9)];
  #acceleration gravitationnelle
  acceleration_gravitationnelle = [0 0 -9.8];
  
  #acceleration frottement visqueux
  norme_vitesse = norm(vitesse_balle);
  coefficient_frottement = -(MASSE_VOL_AIR*COEFFICIENT_V*AIRE_BALLE*norme_vitesse)/2;
  acceleration_frottement_visqueux = coefficient_frottement*vitesse_balle/MASSE_BALLE;
  
  #acceleration magnus
  norme_wb = norm(vitesse_angulaire);
  wb_x_vb_matrix = cross(vitesse_angulaire, vitesse_balle);

  Cm = 0.000791 * norm(vitesse_angulaire);
  
  acceleration_magnus = (MASSE_VOL_AIR* Cm * AIRE_BALLE* norme_vitesse^2*wb_x_vb_matrix)/(2*MASSE_BALLE*norm(wb_x_vb_matrix));
  
  #acceleration totale
  acceleration = acceleration_gravitationnelle + acceleration_frottement_visqueux + acceleration_magnus;
  
  g = [acceleration(1) acceleration(2) acceleration(3) ...
        (q0(1)) (q0(2)) (q0(3)) ...
        0 0 0];
endfunction