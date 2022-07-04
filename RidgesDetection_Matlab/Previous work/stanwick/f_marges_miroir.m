function [ im_ext ] = f_marges_miroir( imb, taille_masque )
% v 4.0 traite les couleurs + derniere ligne (n dedouble pas les lignes

if length(size(imb))>2
    [dimy , dimx, dimz]= size(imb); % nb lignes, nb colonnes
else
    [dimy , dimx]= size(imb);
    dimz = 1;
end


if ( (mod( taille_masque , 2 )) == 0)
error(['ERREUR : la taille de la fenetre du masque vaut ' num2str(tf) ', il faut une taille impaire']);  
end
if ((2*dimy <= taille_masque ) || (2*dimx <= taille_masque )) 
    x = 2*min(dimy,dimx) -1;
error(['ERREUR : la taille de la fenetre du masque vaut ' num2str(tf) ', il faut une taille maximum de ' num2str(x) ]);  
end  


imb = double(imb);
n = taille_masque;

im_ext = double(zeros(dimy+(taille_masque-1), dimx+(taille_masque-1), dimz));

[dimy_ext, dimx_ext, dimz_ext]=size(im_ext);



for z = 1:dimz_ext
 
im_ext((n-1)/2+1:dimy_ext-(n-1)/2, (n-1)/2+1:dimx_ext-(n-1)/2, z)=imb(1:dimy,1:dimx, z);

for i=1:(n-1)/2
    
  im_ext((n-1)/2+1:dimy_ext-(n-1)/2,i,:)=imb(1:dimy,(n-1)/2-i+2, :); %premiere colonne
  im_ext((n-1)/2+1:dimy_ext-(n-1)/2,dimx+(n-1)/2+i,:)=imb(1:dimy,dimx-i, :); %derniere colonne
 
end

for i=1:(n-1)/2

  im_ext(i,:, :)=im_ext((n-1) -i+2,:, :); %premiere ligne
  im_ext(dimy_ext-(n-1)/2+i,:, :)=im_ext(dimy_ext-i-(n-1)/2,:, :); %derniere ligne
end

end

