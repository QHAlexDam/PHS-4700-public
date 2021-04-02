# Created by Octave 5.2.0, Tue Sep 29 10:04:49 2020 GMT <unknown@DESKTOP-08PNE95>
function [pcm MI aa] = Devoir1(pos, theta, wz, force)
  #matrice de rotation selon l'axe de rotation oy
  Ry = [cos(theta), 0, sin(theta);0, 1, 0; -sin(theta), 0, cos(theta)];
#################CONSTANTES#################
  #jambes
  rayon_jambe = 0.06;
  longueur_jambe = 0.75;
  masse_vol_jambe = 1052;
  volume_jambe = pi*power(rayon_jambe, 2)*longueur_jambe;
  masse_jambe = masse_vol_jambe*volume_jambe;
  pcm_jambe_pos = [0.10;0;longueur_jambe/2];
  pcm_jambe_neg = [-0.10;0;longueur_jambe/2];
  #tronc
  rayon_tronc = 0.15;
  longueur_tronc = 0.70;
  masse_vol_tronc = 953;
  volume_tronc = pi*power(rayon_tronc, 2)*longueur_tronc;
  masse_tronc = masse_vol_tronc*volume_tronc;
  pcm_tronc = [0;0;longueur_jambe+longueur_tronc/2];
  #cou
  rayon_cou = 0.04;
  longueur_cou = 0.1;
  masse_vol_cou = 953;
  volume_cou = pi*power(rayon_cou, 2)*longueur_cou;
  masse_cou = masse_vol_cou*volume_cou;
  pcm_cou = [0;0;longueur_jambe+longueur_tronc+longueur_cou/2];
  #tete
  rayon_tete = 0.1;
  masse_vol_tete = 1056;
  volume_tete = 4/3*pi*power(rayon_tete, 3);
  masse_tete = masse_vol_tete*volume_tete;
  pcm_tete = [0;0;(longueur_jambe+longueur_tronc+longueur_cou+rayon_tete)];
  #bras
  rayon_bras = 0.03;
  longueur_bras = 0.75;
  masse_vol_bras = 1052;
  volume_bras = pi*power(rayon_bras, 2)*longueur_bras;
  masse_bras = masse_vol_bras*volume_bras;
  pcm_bras_vertical = [rayon_tronc+rayon_bras;0;longueur_jambe+longueur_tronc-longueur_bras/2];
  pcm_bras_horizontal = [-(rayon_tronc+longueur_bras/2);0;(longueur_jambe+longueur_tronc-rayon_bras)];

#################CALCUL DU CENTRE DE MASSE#################
  masse_totale = 2*masse_jambe + masse_tronc + masse_cou + masse_tete + 2*masse_bras;
  pcm = 1/masse_totale*(masse_jambe*pcm_jambe_pos + masse_jambe*pcm_jambe_neg + masse_tronc*pcm_tronc + masse_cou*pcm_cou + masse_tete*pcm_tete + masse_bras*pcm_bras_vertical + masse_bras*pcm_bras_horizontal);

  
#################CALCUL DU MOMENT D'INERTIE#################

  function moment_inertie = moment_inertie_cylindre(masse, longueur, rayon, pcm, pcm_cylindre)
    inertie_pcm = masse * [(power(longueur, 2)/12 + power(rayon, 2)/4) 0 0; 0 (power(longueur, 2)/12 + power(rayon, 2)/4) 0; 0 0 (power(rayon, 2)/2)];
    dc = pcm - pcm_cylindre;
    matrice_dc = [dc(2)*dc(2)+dc(3)*dc(3), -1*dc(1)*dc(2), -1*dc(1)*dc(3);
                  -1*dc(2)*dc(1), dc(1)*dc(1)+dc(3)*dc(3), -1*dc(2)*dc(3);
                  -1*dc(3)*dc(1), -1*dc(3)*dc(2), dc(1)*dc(1)+dc(2)*dc(2)];
    moment_inertie = inertie_pcm + masse*matrice_dc;
  endfunction
  
  function moment_inertie = moment_inertie_cylindre_horizontal(masse, longueur, rayon, pcm, pcm_cylindre)
    inertie_pcm = masse * [(power(rayon, 2)/2) 0 0; 0 (power(longueur, 2)/12 + power(rayon, 2)/4) 0; 0 0 (power(longueur, 2)/12 + power(rayon, 2)/4)];
    dc = pcm - pcm_cylindre;
    matrice_dc = [dc(2)*dc(2)+dc(3)*dc(3), -dc(1)*dc(2), -dc(1)*dc(3);
                  -dc(2)*dc(1), dc(1)*dc(1)+dc(3)*dc(3), -dc(2)*dc(3);
                  -dc(3)*dc(1), -dc(3)*dc(2), dc(1)*dc(1)+dc(2)*dc(2)];
    moment_inertie = inertie_pcm + masse*matrice_dc;
  endfunction
  
  function moment_inertie = moment_inertie_sphere(masse, rayon, pcm_patineuse, pcm_sphere)
    inertie_pcm = 2/5 * masse * [rayon*rayon 0 0; 0 rayon*rayon 0; 0 0 rayon*rayon];
    dc = pcm_patineuse - pcm_sphere;
    matrice_dc = [dc(2)*dc(2)+dc(3)*dc(3), -dc(1)*dc(2), -dc(1)*dc(3);
                  -dc(2)*dc(1), dc(1)*dc(1)+dc(3)*dc(3), -dc(2)*dc(3);
                  -dc(3)*dc(1), -dc(3)*dc(2), dc(1)*dc(1)+dc(2)*dc(2)];
    moment_inertie = inertie_pcm + masse*matrice_dc;
  endfunction

  #Moments d'inertie cylindres
  inertie_jambe_pos = moment_inertie_cylindre(masse_jambe, longueur_jambe, rayon_jambe, pcm, pcm_jambe_pos);
  inertie_jambe_neg = moment_inertie_cylindre(masse_jambe, longueur_jambe, rayon_jambe, pcm, pcm_jambe_neg);
  inertie_tronc = moment_inertie_cylindre(masse_tronc, longueur_tronc, rayon_tronc, pcm, pcm_tronc);
  inertie_cou = moment_inertie_cylindre(masse_cou, longueur_cou, rayon_cou, pcm, pcm_cou);
  inertie_bras_vertical = moment_inertie_cylindre(masse_bras, longueur_bras, rayon_bras, pcm, pcm_bras_vertical);
  inertie_bras_horizontal = moment_inertie_cylindre_horizontal(masse_bras, longueur_bras, rayon_bras, pcm, pcm_bras_horizontal);

  #Moment d'inertie sphere
  inertie_tete = moment_inertie_sphere(masse_tete, rayon_tete, pcm, pcm_tete);
  
  #Moment d'inertie total
  MI = inertie_jambe_pos + inertie_jambe_neg + inertie_tronc + inertie_cou + inertie_bras_vertical + inertie_bras_horizontal + inertie_tete;
    
  #################CALCUL DE L'ACCELERATION ANGULAIRE#################
  
  vitesse_angulaire = [0; 0; wz];
  #Matrice L
  Lx = MI(1,1)*vitesse_angulaire(1)+MI(1,2)*vitesse_angulaire(2)+MI(1,3)*vitesse_angulaire(3);
  Ly = MI(2,1)*vitesse_angulaire(1)+MI(2,2)*vitesse_angulaire(2)+MI(2,3)*vitesse_angulaire(3);
  Lz = MI(3,1)*vitesse_angulaire(1)+MI(3,2)*vitesse_angulaire(2)+MI(3,3)*vitesse_angulaire(3);
  L = [Lx; Ly; Lz];
  
  #Moment de force
  Rj = [0; rayon_tete; longueur_jambe+longueur_tronc+longueur_cou+rayon_tete];
  Rji = Rj - pcm;
  moment_force = cross(Rji, force);
  
  #Acceleration angulaire
  aa = inv(MI)*(moment_force + cross(L, vitesse_angulaire));
  
  #Application de la matrice de rotation
  #matrice de rotation selon l'axe de rotation oy
  Ry = [cos(theta) 0 sin(theta);0 1 0; -sin(theta) 0 cos(theta)];
  aa = Ry*aa;
  pcm = Ry*pcm;
  #pcm = pcm + pos;
  MI = Ry*MI*(Ry.');
endfunction
