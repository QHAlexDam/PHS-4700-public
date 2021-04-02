function [isCollision poscollision distance normale] = CollisionRayonCylindre (direction_rayon, poso)
  %https://stackoverflow.com/questions/1073336/circle-line-segment-collision-detection-algorithm
  
  %VARIABLES GLOBALES
  global cylindre;
  
  normale = [0 0 0];
  distance = 0;
  poscollision = poso;
  
  %CONSTANTES
  INF_LIMITER = 99999; %valeur exag?r?ment grande pour trouver les INF
  
  %calcul de la distance entre l'observateur et le cylindre
  vect_distance_observateur_cylindre = [poso(1) - cylindre.cdm(1), poso(2) - cylindre.cdm(2)];
  
  %equation quadratique
  a = dot (direction_rayon(1:2),direction_rayon(1:2));
  b = 2*dot(vect_distance_observateur_cylindre, direction_rayon(1:2));
  c = dot(vect_distance_observateur_cylindre, vect_distance_observateur_cylindre) - cylindre.rayon^2;
  
  intersections = roots([a b c]);
  %on garde seulement les valeurs réelles
  intersections = intersections(imag(intersections)==0);
  
  %on souhaite retirer les valeurs sous 0 avec une valeur exagerement grande
  intersections(intersections <= 0) = inf;
  
  if(numel(intersections) == 0) % il n'y a pas d'intersection
    isCollision = false;
    return
  endif
  
  if(min(intersections) >= INF_LIMITER)
    isCollision = false;
    return
  endif
  distance = min(intersections);
  poscollision = poso + min(intersections)*direction_rayon;
  
  %on verifie en hauteur le point d'intersection
  if(poscollision(3) >= (cylindre.cdm(3) - cylindre.hauteur/2) && poscollision(3) <= (cylindre.cdm(3) + cylindre.hauteur/2))
    isCollision = true;
    
    %la normale est la continuation du rayon du cylindre, ? la hauteur de la collision
    normale = [poscollision(1) - cylindre.cdm(1), poscollision(2) - cylindre.cdm(2), 0];
    normale = normale/ norm(normale);
    %%%%angle_incidence = CalculAngleIncidence(normale, direction_rayon);
    
    return
  else % Si la collision n'a pas eu lieu dans le limites en z, on va voir si elle a touche les faces du haut et du bas
    CollisionExtremites(direction_rayon, poso);
  endif


  function [isCollision poscollision distance normale] = CollisionExtremites (direction_rayon, poso)
    isCollision=false;
    obs_yz = poso(2:3);
    
    centre_haut = cylindre.cdm(2:3) + [0 cylindre.hauteur/2];
    centre_bas = cylindre.cdm(2:3) - [0 cylindre.hauteur/2];
    
    zcoll_haut = centre_haut(2);
    zcoll_bas = centre_bas(2);
    if (direction_rayon(3) != 0 )
      t_haut = (zcoll_haut-poso(3))/direction_rayon(3);
      t_bas = (zcoll_bas-poso(3))/direction_rayon(3);
      t = min([t_haut t_bas]);
      poscollision = poso + t*direction_rayon;
      
      %calcul de la distance entre le point et le centre de la face
      vect_coll_centreface =  poscollision(1:2) - cylindre.cdm(1:2);
      distance_coll_centreface = norm(vect_coll_centreface);
      %comparaison avec le rayon du cylindre
      if (distance_coll_centreface <= cylindre.rayon)
        isCollision = true;
        distance = t;
        if(t == t_haut)
          normale = [0 0 1];
        else 
          normale = [0 0 -1];
        endif
        return;
      else
        isCollision = false;
        
      endif
    else
      print("division par 0");
##      %vecteur direction tout droit (pas de coord en z)
##      return;
##      isCollision = false;
    endif
    return;
      
  endfunction
  
  isCollision = false;

endfunction
%VIEUX CODE DE HAUT BAS
%VIEUX CODE
%https://www.mathworks.com/matlabcentral/answers/17039-line-and-a-line-segment-intersection    
%parametres y=mx+b
##collision_haut = false;
##    collision_bas = false;
##    pente_m = direction_rayon(3)/direction_rayon(2);
##    orig_b = obs_yz(2)-pente_m*obs_yz(1);
    %sous la forme [start point; end point]
    %seg_haut = [centre_haut(1)-cylindre.rayon centre_haut(2); centre_haut(1)+cylindre.rayon centre_haut(2)];
    %seg_bas = [centre_bas(1)-cylindre.rayon centre_bas(2); centre_bas(1)+cylindre.rayon centre_bas(2)];
    
    %intersection du rayon avec le haut et le bas du cylindre, t obtenu est sur le segment
    %t_haut = (orig_b - seg_haut(1,2) + pente_m*seg_haut(1,1))/(seg_haut(2,2) - seg_haut(1,2) + pente_m*(seg_haut(1,1) - seg_haut(2,1)))
    %t_bas = (orig_b - seg_bas(1,2) + pente_m*seg_bas(1,1))/(seg_bas(2,2) - seg_bas(1,2) + pente_m*(seg_bas(1,1) - seg_bas(2,1)))
    ##    if (t_haut > 0 && t_haut <=1)
##      collision_haut = true;
##      poscollision = poso+t_haut*direction_rayon;
##    elseif (t_bas > 0 && t_bas <=1)
##      collision_bas = true;
##      poscollision = poso+t_bas*direction_rayon;
##    else
##      poscollision = poso;
##    endif
%probleme t est la distance du point de gauche de la face
%VIEUX CODE
    
    %on cherche avec le z des faces la position du point grace a la formule 
    %p(t) = p0 + t*direction
    %t= (p(t)-p0)/direction