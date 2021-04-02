#fonction g1 représentant l'option 1 pour Runge-Kutta

function g = g1 (q0)
  acceleration_gravitationnelle = [0 0 -9.8];
  

  g = [acceleration_gravitationnelle(1) acceleration_gravitationnelle(2) acceleration_gravitationnelle(3) ...
        (q0(1)) (q0(2)) (q0(3)) ...
        0 0 0];
endfunction

