function [isCollision, distance, faceCollision, posCollision] = CollisionRayonBloc(posInitRayon, direction)
  
  global bloc;

  
  plans = [3 0 0; 4 0 0; 0 3 0; 0 5 0; 0 0 12; 0 0 17];
  centres_plans = [3 4 14.5 ; 4 4 14.5; 3.5 3 14.5 ; 3.5 5 14.5 ; 3.5 4 12 ; 3.5 4 17 ];
  normales = [-1 0 0; 1 0 0; 0 -1 0; 0 1 0; 0 0 -1; 0 0 1];
  couleurs = ["rouge" "cyan" "vert" "jaune" "bleu" "magenta"];
  

  
  posCollision = posInitRayon;
  isCollision = false;
  faceCollision = 0;
  distance=inf;
  
  for i = 1:6
    
    face = struct(
      "planxyz" ,plans(i,:),
      "normale" ,normales(i,:),
      "centre"   ,centres_plans(i,:),
      "couleur" ,couleurs(i)
    );

    dist_plan = face.centre - posInitRayon;
    s = dot(face.normale, dist_plan)/dot(face.normale, direction);
    
    % On cherche le point d'intersection avec la face en question
    intersection = posInitRayon + s*direction;
    
    % On verifie si l'intersection est reellement dans les limites du bloc
    if ((s > 0) && (s < distance) &&
        (intersection(1) >= bloc.cdm(1)-bloc.dimensions(1)/2) &&
        (intersection(1) <= bloc.cdm(1)+bloc.dimensions(1)/2) &&
        (intersection(2) >= bloc.cdm(2)-bloc.dimensions(2)/2) &&
        (intersection(2) <= bloc.cdm(2)+bloc.dimensions(2)/2) &&
        (intersection(3) >= bloc.cdm(3)-bloc.dimensions(3)/2) &&
        (intersection(3) <= bloc.cdm(3)+bloc.dimensions(3)/2))
        isCollision = true;
        distance = s;
        faceCollision = i;
        posCollision = intersection;
        
        
     endif
    
    
  end
endfunction
##function [isCollision distance faceCollision posCollision] = CollisionRayonBloc (pointInit, vectDirection)
##
##  global bloc;
##  distance = 0;
##  isCollision = false;
##  faceCollision = 0;
##  posCollision = [0 0 0];
##
##
##  %les normales pointent vers l'exterieur du bloc
##  %les points obtenus en choisissant un coin du prisme
##  %limite : xMin, xMax, yMin, yMax, zMin, zMax
##  
##  plans = [3 0 0; 4 0 0; 0 3 0; 0 5 0; 0 0 12; 0 0 17];
##  normales = [-1 0 0; 1 0 0; 0 -1 0; 0 1 0; 0 0 -1; 0 0 1];
##  points = [3 3 12; 4 3 12; 3 3 12; 3 5 12; 3 3 12; 3 3 17];
##  limites = [3 3 3 5 12 17; 4 4 3 5 12 17; 3 4 3 3 12 17; 3 4 5 5 12 17; 3 4 3 5 12 12; 3 4 3 5 17 17];
##  couleurs = ["rouge" "cyan" "vert" "jaune" "bleu" "magenta"];
##    
##  %Tester les 6 faces du bloc
##  for i = 1:6
##    face = struct(
##    "planxyz" ,plans(i,:),
##    "normale" ,normales(i,:),
##    "point"   ,points(i,:),
##    "limites" ,limites(i,:),
##    "couleur" ,couleurs(i)
##    );
##    
##    %equation plan: A1*x1 + B1*y1 + C1*z1 + D = 0, 
##    %(A1,B1,C1) = normale, 
##    %(x1,y1,z1) = point dans le plan
##    A1 = face.normale(1);
##    B1 = face.normale(2);
##    C1 = face.normale(3);
##    x1 = face.point(1);
##    y1 = face.point(2);
##    z1 = face.point(3);
##    
##    D = -(A1*x1 + B1*y1 + C1*z1);
##    
##    %equation droite: (x = A2*t + y2, y = B2*t + y2, z = C2*t + z2), 
##    %(A2,B2,C2)=vecteur unitaire directionnel, 
##    %(x2,y2,z2)=un point
##    A2 = vectDirection(1);
##    B2 = vectDirection(2);
##    C2 = vectDirection(3);
##    x2 = pointInit(1);
##    y2 = pointInit(2);
##    z2 = pointInit(3);
##    
##    %si le rayon et la normale sont perpendiculaire, 
##    %le rayon est parallele au plan
##    if (dot(vectDirection, face.normale) == 0) 
##      continue
##    else 
##      %combinaision des deux equations
##      %D = - (A1 * x(t) + B1* y(t) + C1 * z(t))
##      %D = - (A1 * (A2*t + x2) + B1* (B2*t + y2) + C1 * (C2*t + z2))
##      t = -((A1*x2) + (B1*y2) + (C1*z2) + D )/((A1*A2) + (B1*B2) + C1*C2);
##      
##      %trouver les coordonées de l'intersection
##      xf = A2 * t + x2;
##      yf = B2 * t + y2;
##      zf = C2 * t + z2;
##      
##      pos(end+1,:) = [xf yf zf];
##      %Déterminer si le point d'intersection est dans les limites de la face
##      if (xf >= face.limites(1) && xf <= face.limites(2)
##          && yf >= face.limites(3) && yf <= face.limites(4)
##          && zf >= face.limites(5) && zf <= face.limites(6))
##          isCollision = true;
##      endif
##      
##      if (isCollision)
##        distancesCollisions(end+1) = sqrt( (xf-pointInit(1)).^2 + (yf-pointInit(2)).^2 + (zf-pointInit(3)).^2 );
##      else
##        distancesCollisions(end+1) = Inf;
##      endif
##    endif
##  endfor
##  
##  if (isCollision)
##    %Determiner la face qui est touche en premier
##    distance = 999999;
##    for i = 1:length(distancesCollisions)
##      if (distancesCollisions(i) <= distance)
##        distance = distancesCollisions(i);
##        faceCollision = i;
##        posCollision = pos(i,:);
##      endif
##    endfor
##  endif
##endfunction
