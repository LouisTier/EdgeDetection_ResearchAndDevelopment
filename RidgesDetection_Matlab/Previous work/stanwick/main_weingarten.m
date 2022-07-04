 

I = f_marges_miroir( I0, tf ); % filtre taille 3
I = f_normalisation(I);

[dimy , dimx]= size(I); % nb lignes, nb colonnes



[ Ix, Iy, Ixixi, Ixx, Iyy, Ixy  ] = f_kitchen_rosenfeld_discret( I, sigma );

IxIy = Ix.*Iy;
Coef = 1 ./( ( 1 + Ix.^2 + Iy.^2 ).^(3/2)); 

A= Coef.*( Ixx + Ixx.* (Iy.^2) - IxIy.*Ixy );
B= Coef.*( Ixy + Ixy.*(Iy.^2) - IxIy .* Iyy );
C= Coef.*( - Ix .* Iy .* Ixx + Ixy +  Ixy.*(Ix.^2) );
D= Coef.*( - IxIy.*Ixy + Iyy + Iyy.*(Ix.^2) );

% figure, imagesc(Ixx), colormap(gray), title('Ixx')
% figure, imagesc(Iyy), colormap(gray), title('Iyy')

[ k1, k2, theta ] = f_valeurs_propres_et_direction_vecteur_propre( A, B, C, D );

% figure, imagesc(k1), colormap(gray), title('k_1')
% figure, imagesc(theta), colormap(gray), title('\theta')

[ max_grad_nasser ] = f_nasser( I, sigma, th, tf);

max_grad_n = f_normalisation( max_grad_nasser);
%%%%%%%%%%
% pc = 0.2
m = sum(sum(max_grad_n > 0))
n = m;

TH = 0
while n > m*pc
    n = sum(sum(max_grad_n > TH))
    TH = TH + 0.001
end

th = TH
max_grad_s = (f_normalisation_3D(max_grad_nasser) > th);
Ic = f_contours_verts_sur_image(I0,max_grad_s);

figure, imshow(uint8(Ic)), title('cretes en vert')

imwrite(max_grad_s, ['result/wei_sigma_',num2str(sigma),'_pc_',num2str(pc),'.png'])