function [Ic] = f_contours_verts_sur_image(I,C)
% V2 
% considers normalized images 
% 2021-04-13 by Baptiste Magnier

L = size(I);

  s1= size(C);
  if (L~=s1)
    disp(['ERREUR : la taille de I0 vaut ' num2str(size(I)) ' et la taille de Ir vaut ' num2str(size(C)) ]);
    
  end

if max(max(I)) > 1
    Ic(:,:,1)=I;
    Ic(:,:,2)=I;
    Ic(:,:,3)=I;

      for i = 1:L(1)
          for j = 1:L(2)
              if (C(i,j)==1)
                    Ic(i,j,1)=0;
                    Ic(i,j,2)=255;
                    Ic(i,j,3)=0;
              end

          end
      end
  
else
    I = f_normalisation(I);

    Ic(:,:,1)=I;
    Ic(:,:,2)=I;
    Ic(:,:,3)=I;

      for i = 1:L(1)
          for j = 1:L(2)
              if (C(i,j)==1)
                    Ic(i,j,1)=0;
                    Ic(i,j,2)=1;
                    Ic(i,j,3)=0;
              end

          end
      end
  
end
  

  
  