function [xi yi zi face] = Devoir4 (nout, nin, poso)
  %INITIALISATION VARIABLES
  xi = [];
  yi = [];
  zi = [];
  face = [];
  
  %NOMBRES D'ANGLES
  N = 200;
  M = 200;
  nb_reflexions = 100;
  
  %OBSERVATEUR
  global observateur = struct(
    'position', poso
    %'indice_refraction', [double] 
  );
  

  %BLOC CYLINDRIQUE
  global cylindre = struct(
    'rayon', 2,
    'hauteur', 18,
    'cdm', [4, 4, 11]
    %'indice_refraction', [double]
  );
  
  
  %BLOC RECTANGULAIRE
  global bloc = struct(
    'dimensions', [1; 2; 5],
    'cdm', [3.5; 4; 14.5]
  );
  
  %CALCUL ANGLES THETA
  theta_initial_min = CalculTheta(true);
  theta_initial_max = CalculTheta(false);
  
  %CALCUL ANGLES PHI
  phi_initial_min = CalculPhi(true);
  phi_initial_max = CalculPhi(false);
  
  for phiIterateur = 1:M
    %calcul angle azimutal phi
    angle_phi = phi_initial_min + ((phi_initial_max - phi_initial_min)*(2*phiIterateur - 1)/(2*M));
    for thetaIterateur = 1:N
      %calcul angle polaire
      angle_theta = theta_initial_min + ((theta_initial_max - theta_initial_min)*(2*thetaIterateur - 1)/(2*N));
     
      %calcul du vecteur direction du rayon
      direction_rayon = CalculDirection(angle_theta, angle_phi);
      u_direction_rayon = direction_rayon/ norm(direction_rayon);

      %Verification de la collision avec le cylindre
      [isCollision poscollision distance normale] = CollisionRayonCylindre(u_direction_rayon, observateur.position);
      
      if(isCollision == false)
        continue  % il n'y a pas de collision avec le cylindre.
                  % le rayon n'est pas valide. On passe a la prochaine iteration
      endif
      
      angle_incidence = CalculAngleIncidence(normale, u_direction_rayon);
      if(IsReflected(angle_incidence, nout, nin ))
        continue  % le rayon est completement reflechi de sa surface.
                  % le rayon n'est pas valide. On passe a la prochaine iteration
      endif
      
      %Mettre a jour le vecteur direction refracte
      direction_rayon_transmis = CalculDirectionTransmise(normale, u_direction_rayon, nin, nout);
      
      distanceImage = distance;
      pointInitRayon = poscollision;
      
      for nb_reflections_tot_internes = 1:nb_reflexions

        
        [isCollision distance faceCollision posCollision] = CollisionRayonBloc (pointInitRayon, direction_rayon_transmis);
        
        if(isCollision)
          % IL y a eu collision!
          distanceImage += distance;
          
          pos_image = poso + distanceImage*u_direction_rayon;
          xi(end+1) = pos_image(1);
          yi(end+1) = pos_image(2);
          zi(end+1) = pos_image(3);
          face(end+1) = faceCollision;
          
          break
        endif
        %Il n'y a pas eu de collision, le rayon va faire une reflection interne
        [isCollision poscollision distance normale] = CollisionRayonCylindre(direction_rayon_transmis, pointInitRayon);
        
        if(isCollision == false)
          break     % il n'y a pas de collision avec le cylindre (impossible normalement ? cet endroit, mais on laisse la v�rification en cas d'erreur)
                    % le rayon n'est pas valide. On passe a la prochaine iteration
        endif  
        
        normale = -normale; %Les normales retournees par la fonction sont vers l'exterieur, il faut vers l'interieur ici
        
        
        %mettre a jour le vecteur direction
        direction_rayon_transmis = CalculDirectionReflechie(normale, direction_rayon_transmis);

        angle_incidence = CalculAngleIncidence(normale, direction_rayon_transmis);
        if( not(IsReflected(angle_incidence, nout, nin)))
          break     % soit le rayon n'est pas reflechi et sort du cylindre
                    % le rayon n'est pas valide. On passe au prochain rayon
        endif      

        distanceImage += distance;
        pointInitRayon = poscollision;
      end
    end
  end
    
endfunction
