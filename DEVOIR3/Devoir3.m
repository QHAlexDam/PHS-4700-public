%INPUT
%rai = (Xa(0), Xb(0))
%vai = (vxa(0), vya(0), wza(0))
%rbi, vbi idem pour b
%tb: temps auquel b met les freins et commence a glisser
%OUTPUT
%Coll: 0: collision, 1: pas de collision
%tf: temps fin de simul
%raf,vbf: pos x,y et angle de rotation
function [Coll tf raf vaf rbf vbf] = Devoir3 (rai, vai, rbi, vbi, tb)

%CONDITIONS INITIALES
%AUTO A
MASSE_A = 1540; %KG
LONG_A = 4.78; %M
LARG_A = 1.82; %M
HAUT_A = 1.8; %M
I_A = [MASSE_A/12*(LARG_A*LARG_A + HAUT_A*HAUT_A), 0, 0;
              0, MASSE_A/12*(LONG_A*LONG_A + HAUT_A*HAUT_A), 0;
              0, 0, MASSE_A/12*(LONG_A*LONG_A + LARG_A*LARG_A)];
%AUTO B
MASSE_B = 1010; %KG
LONG_B = 4.23; %M
LARG_B = 1.6; %M
HAUT_B = 1.8; %M
I_B = [MASSE_B/12*(LARG_B*LARG_B + HAUT_B*HAUT_B), 0, 0;
              0, MASSE_B/12*(LONG_B*LONG_B + HAUT_B*HAUT_B), 0;
              0, 0, MASSE_B/12*(LONG_B*LONG_B + LARG_B*LARG_B)];

R_A = sqrt(LONG_A^2 + LARG_A^2);
R_B = sqrt(LONG_B^2 + LARG_B^2 );
coinsA = [];
coinsB = [];
angleA = calculerAngleOmega(vai);
angleB = calculerAngleOmega(vbi);
q0A = [vai(1) vai(2) rai(1) rai(2) 0 0];
q0B = [vbi(1) vbi(2) rbi(1) rbi(2) 0 0];
temps = 0;
normaleCollision = [];
pointCollision = [0 0];
Coll = 1;
isFrottement = true;

%CONSTANTES
VITESSE_MIN = 0.01;
COEF_RESTITUTION = 0.8;
DELTA_T = 0.0001; %intervalle temps pour runge-kutta
global G_GRAVITATIONNEL = 9.8;

%boucle afin d'effectuer les simulations
while 1
  g = @gFrottement;
  q0A = RungeKutta(q0A,temps,DELTA_T,g);
  if(temps < tb)
    g = @gSansFrottement;
    q0B = RungeKutta(q0B, temps, DELTA_T, g);
  else
    q0B = RungeKutta(q0B, temps, DELTA_T, g);
    angleB = angleB + (vbi(3)*DELTA_T);
  endif
  
  angleA = angleA + (vai(3)*DELTA_T);
  
  if(norm(q0A(1:2)) < VITESSE_MIN && norm(q0B(1:2)) < VITESSE_MIN)
    Coll = 1;
    temps = temps + DELTA_T;
    break
  endif
  
  %get les coins dépendamment des résultats de runge-kutta
  coinsA = getCoinsAutos([q0A(3) q0A(4)], angleA, LARG_A, LONG_A);
  coinsB = getCoinsAutos([q0B(3) q0B(4)], angleB, LARG_B, LONG_B);
  
  [pointCollision stateCollisionA normaleCollision] = isCollision(coinsA, coinsB, q0A, q0B, R_A, R_B);
  
  %Si A détecte pas de collision
  if(stateCollisionA == 0)
    [pointCollision stateCollisionB normaleCollision] = isCollision(coinsB, coinsA, q0B, q0A, R_B, R_A);
  endif
  
  %Si A ou B détecte une collision
  if(stateCollisionA == 1 || stateCollisionB == 1)
    Coll = 0;
    temps = temps + DELTA_T;
    break
  endif
  
  temps = temps + DELTA_T;
  
end

if(Coll == 0)
  getVitessesFinales();
else
  vaf = [q0A(1) q0A(2) vai(3)];
  vbf = [q0B(1) q0B(2) vbi(3)];
endif

%Assignation paramètres de retour restants
raf = [q0A(3) q0A(4) angleA];
rbf = [q0B(3) q0B(4) angleB];
tf = temps;

function angleOmega = calculerAngleOmega(vitesse)
  %angles en rad
  if(vitesse(1) == 0)
    if(vitesse(2) > 0)
      angleOmega = pi/2;
    else
      angleOmega = 3*pi/2;
    endif
  else
    angleOmega = atan(vitesse(2)/vitesse(1));
  endif
endfunction

function [posCoins] = getCoinsAutos(posCM, angle, largeur, longueur)  
  matrice_rot_x = [cos(angle) -sin(angle)];
  matrice_rot_y = [sin(angle) cos(angle)];
  
  %top-right
  coin1_x = matrice_rot_x * [longueur/2; largeur/2];
  coin1_y = matrice_rot_y * [longueur/2; largeur/2];
  
  %top-left
  coin2_x = matrice_rot_x * [-longueur/2; largeur/2];
  coin2_y = matrice_rot_y * [-longueur/2; largeur/2];
  
  %bottom-left
  coin3_x = matrice_rot_x * [-longueur/2; -largeur/2];
  coin3_y = matrice_rot_y * [-longueur/2; -largeur/2];
  
  %bottom-right
  coin4_x = matrice_rot_x * [longueur/2; -largeur/2];
  coin4_y = matrice_rot_y * [longueur/2; -largeur/2];
  
  coin1 = [posCM(1)+coin1_x posCM(2)+coin1_y];
  coin2 = [posCM(1)+coin2_x posCM(2)+coin2_y];
  coin3 = [posCM(1)+coin3_x posCM(2)+coin3_y];
  coin4 = [posCM(1)+coin4_x posCM(2)+coin4_y];

  posCoins = [coin1; coin2; coin3; coin4];
  
endfunction

function [posCollision stateCollision normaleCollision] = isCollision(coinsA, coinsB, q0A, q0B, R_A, R_B)
  coinsA = transpose(coinsA);
  coinsB = transpose(coinsB);
  cdm_A = [q0A(3) q0A(4)];
  cdm_B = [q0B(3) q0B(4)];
  normaleCollision = [];
  posCollision = [0 0]; 
  
  normaleB1= -(coinsB(:, 3) - coinsB(:, 2))/norm(coinsB(:, 3) - coinsB(:, 2));
  normaleB2= -(coinsB(:, 4) - coinsB(:, 3))/norm(coinsB(:, 4) - coinsB(:, 3));
  normaleB3= -(coinsB(:, 1) - coinsB(:, 4))/norm(coinsB(:, 1) - coinsB(:, 4));
  normaleB4= -(coinsB(:, 2) - coinsB(:, 1))/norm(coinsB(:, 2) - coinsB(:, 1));
  normalesB = [normaleB1 normaleB2 normaleB3 normaleB4];
  
  #vérfication rayon minimum
  rayon_min = R_A + R_B;
  distanceAB = norm(cdm_A - cdm_B);
  if (distanceAB > rayon_min)
      stateCollision = 0;
      return;
  endif
  
  #methode des plans de division    
  stateCollision = 0;
  
  for i=1:4
    if (stateCollision == 0)
      coll = 1;
      min_dist = inf;
      normale = [0,0];
        if (coll == 1)
          %calcul normale
          n1 = normalesB(:,1);
          d1 = dot(n1, coinsA(:, i) - coinsB(:, 1));
          n2 = normalesB(:,2);
          d2 = dot(n2, coinsA(:, i) - coinsB(:, 2));
          n3 = normalesB(:,3);
          d3 = dot(n3, coinsA(:, i) - coinsB(:, 3));
          n4 = normalesB(:,4);
          d4 = dot(n4, coinsA(:, i) - coinsB(:, 4));
          
          if(d1 <= 0 && d2 <= 0 && d3 <= 0 && d4<=0)
            minSurfaces = min([d1 d2 d3 d4]);
            if(minSurfaces == d1)
              normale = -n1;
            elseif(minSurfaces == d2)
              normale = -n2;
            elseif(minSurfaces == d3)
              normale = -n3;
            elseif(minSurfaces == d4)
              normale = -n4;
            endif
          else
            coll = 0;
          endif

        endif
      if(coll == 1)
        normaleCollision = normale;
        stateCollision = 1;
        posCollision = coinsA(:, i);
      endif

    endif

  endfor
endfunction

#reponse totale post-collision sans omega
function getVitessesFinales()
  rap = [pointCollision - transpose(q0A(3:4)); 0];
  rbp = [pointCollision - transpose(q0B(3:4)); 0];
  wai = [0; 0 ; vai(3)];
  wbi = [0; 0 ; vbi(3)];
  vAP = transpose(q0A(1:2)); + cross(wai, rap);
  vBP = transpose(q0B(1:2)); + cross(wbi, rbp);
  j = getCoefficientImpulsion(vAP(1:2), vBP(1:2), normaleCollision, rap, rbp);
  vecteur_j = normaleCollision * j;
  inv_IA = inv(I_A);
  inv_IB = inv(I_B);
  
  %calcul vitesses lineaires finales
  vfA = transpose(q0A(1:2)) + vecteur_j/ MASSE_A;
  vfB = transpose(q0B(1:2)) - vecteur_j/ MASSE_B;
  
  %calcul vitesses angulaires finales
  wfA = wai + (inv_IA) * cross( rap, [vecteur_j;0]);
  wfB = wbi - (inv_IB)* cross( rbp, [vecteur_j;0]);
  
  vaf = [vfA;wfA(3)];
  vbf = [vfB;wfB(3)];
endfunction

function j = getCoefficientImpulsion(vitesseAP, vitesseBP, normaleCollision, rap, rbp)
  inv_IA = inv(I_A);
  inv_IB = inv(I_B);
  
  Ga = dot([(normaleCollision); 0], (cross(inv_IA * (cross(rap, [(normaleCollision); 0])), rap)));
  Gb = dot([(normaleCollision); 0], (cross(inv_IB * (cross(rbp, [(normaleCollision); 0])), rbp)));

  acceleration_angulaire = 1/((1/MASSE_A) + (1/MASSE_B) + Ga + Gb);
  v_r = dot(normaleCollision, (vitesseAP - vitesseBP));
  j = - (acceleration_angulaire * (1+COEF_RESTITUTION) * v_r);
  
endfunction

endfunction

function g = gFrottement (q0)
  global G_GRAVITATIONNEL;
  
  coefCinetique = 0.075;
  vitesse = [q0(1) q0(2)];
  normeVitesse = norm(vitesse);
  if(normeVitesse < 50)
    coefCinetique = 0.15*(1-(normeVitesse/100));
  endif
  if(normeVitesse !=0)
    acc = -coefCinetique*G_GRAVITATIONNEL * (vitesse/normeVitesse);
  else
    acc = [0 0];
  endif
  g= [acc(1) acc(2)...
      q0(1) q0(2)...
      0 0];
endfunction

function g = gSansFrottement (q0)
  acceleration_gravitationnelle=[0 0];
  
  g= [acceleration_gravitationnelle(1) acceleration_gravitationnelle(2) ...
      q0(1) q0(2)...
      0 0 ];
endfunction