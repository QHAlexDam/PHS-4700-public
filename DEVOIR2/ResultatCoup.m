function resultat = ResultatCoup (posBalle, posCoupe)
  #0, si vous avez reussi un trou d’un coup ;
  #1, si la balle est demeuree sur le terrain apres le coup ;
  #2, si la balle sort du terrain.
  
  dimensions_terrain_x = [0  30  30 150 150   0   0];
  dimensions_terrain_y = [0   0 130 130 150 150   0];
  dimensions_terrain_z = [0   0   0   0   0   0   0];
  
  xCoupe= posCoupe(1);
  yCoupe= posCoupe(2);
  rayonCoupe = 0.054; # m
  
  x = posBalle(1);
  y = posBalle(2);
  
  resultat = 2;
  
  isInCourt = inpolygon(x,y,dimensions_terrain_x, dimensions_terrain_y);
  
  if isInCourt == 1 
    resultat = 1;
    dist = sqrt((x-xCoupe)^2 + (y-yCoupe)^2);
    if dist <= rayonCoupe
      resultat = 0;
    endif
  endif
  
endfunction
