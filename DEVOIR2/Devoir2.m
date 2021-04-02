## Created: 2020-10-09
  
function  [coup vbf t x y z] = Devoir2  (option, xy0, vb0, wb0)
  #Constantes terrain
  global RAYON_COUPE = 5.4; #cm
  global POSITION_COUPE = [142 142];
   
  #Constantes balle
  global MASSE_BALLE = 0.0459; #kg
  global RAYON_BALLE = 0.02135; #m
  global POSITION_INITIALE = xy0;
  global VITESSE_INIT = vb0 ; #vitesse initale
  global VITESSE_ANGULAIRE = wb0 ; #vitesse angulaire (reste constante)
  global AIRE_BALLE = pi*RAYON_BALLE^2;
  
  #Constantes environnement
  global COEFFICIENT_V = 0.14; #pas d'unites
  global MASSE_VOL_AIR = 1.2; #kg/m^3
  global VISCOSITE_AIR = 1.81e-5; # kg/m*s 
  global GRAVITE = 9.8; #m/s^2
  global COEFFICIENT_MAGNUS = 0.000791*norm(VITESSE_ANGULAIRE);
  
  #Constantes autres
  DELTA_T = 0.0005; # sec, pour la resolution par Runge-Kutta
  
  #conditions initiales 
  q0 = [vb0(1) vb0(2) vb0(3) ...
          xy0(1) xy0(2) RAYON_BALLE ...
          wb0(1) wb0(2) wb0(3)]; # la balle est au sol
  t0 = 0;
  t(1) = t0;
  x(1) = q0(4);
  y(1) = q0(5);
  z(1) = q0(6);

  #resolution par intervale de 0.1 sec 
  while 1  
    #3 cas possibles (options)
    switch option
      case 1 #seulement la force gravitationnelle est presente
        g = @g1;
      case 2 #la force gravitationnelle et la force visqueuse sont activ�es
        g = @g2;
      case 3 #les trois forces sont prises en compte
        g = @g3;
    end
    q0 = RungeKutta(q0,t0,DELTA_T,g);
    t0 = t0 + DELTA_T;
    
    t(end+1) = t0;
    x(end+1) = q0(4);
    y(end+1) = q0(5);
    z(end+1) = q0(6);
    
    if (q0(6) <= RAYON_BALLE) #tant que la balle n'a pas atterie
      break;
    end
  end

  vbf = [q0(1) q0(2) q0(3)];
  coup = ResultatCoup([x(end), y(end)], POSITION_COUPE);
  
endfunction
