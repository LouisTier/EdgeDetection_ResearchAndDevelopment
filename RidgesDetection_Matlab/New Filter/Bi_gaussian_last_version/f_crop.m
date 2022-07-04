function [ Icrop ] = f_crop( Id, taille_masque )

  if (mod ( taille_masque , 2 ) == 0)
    disp(['ERREUR : la taille de la fenetre du masque vaut ' num2str(tf) ', il faut une taille impaire']);  
    
  end
  n = (taille_masque -1 ) /2;
  [dimy , dimx]= size(Id); % nb lignes, nb colonnes
  Icrop = Id(1+n : dimy-n, 1+n : dimx-n);

end