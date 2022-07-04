function [ Icrop ] = f_crop( Id, taille_masque )
% v 3.0 traite la couleur

  if (mod ( taille_masque , 2 ) == 0)
    disp(['ERREUR : la taille de la fenetre du masque vaut ' num2str(tf) ', il faut une taille impaire']);  
    
  end
  n = (taille_masque -1 ) /2;
  
    if length(size(Id))>2
        [dimy , dimx, dimz]= size(Id); % nb lignes, nb colonnes
    else
        [dimy , dimx]= size(Id);
        dimz = 1;
    end
    
  Icrop = zeros(length(1+n : dimy-n), length(  1+n : dimx-n), dimz);
    
  for   i = 1:dimz
    Icrop(:,:,i) = Id(1+n : dimy-n, 1+n : dimx-n, i);
  end

end