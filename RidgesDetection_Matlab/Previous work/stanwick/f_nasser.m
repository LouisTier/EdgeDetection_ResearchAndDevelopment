function [ max_grad ] = f_nasser( I, sigma, th, tf)



[ Ix, Iy, Ixixi, Ixx, Iyy, Ixy  ] = f_kitchen_rosenfeld_discret( I, sigma );

IxIy = Ix.*Iy;
Coef = 1 ./( ( 1 + Ix.^2 + Iy.^2 ).^(3/2));    %%%%% d (Nasser)

H11 = Ixx;
H12 = Ixy;
H21 = H12;
H22 = Iyy;

F11 = 1 + Iy.^2;
F12 = - IxIy;
F21 = F12;
F22 = 1 + Ix.^2;

A = F11.*H11 + F12.*H21;
B = F11.*H12 + F12.*H22;
C = F21.*H11 + F22.*H21;
D = F21.*H12 + F22.*H22;

[ k1, k2, theta ] = f_valeurs_propres_et_direction_vecteur_propre( Coef.*A, Coef.*B, Coef.*C, Coef.*D );

% figure, imagesc(k1), colormap(gray), title('k_1')
% figure, imagesc(theta), colormap(gray), title('\theta')

% D = sqrt(k1.^2 + k2.^2);% lindeberg 1
% D = abs(k1 - k2).*abs(k1 + k2); % tremblais
D = k1;   % original Nasser
% figure, imagesc(D), colormap(gray), title('D')

theta = pi/2 - theta  ;
% theta = f_translate_pi( theta ); % si directions <0

max_grad = f_crop(f_max_grad_pi_4(D,theta), tf);

max_grad = (max_grad > 0) .* max_grad;

max(max(D))
min(min(D))
% figure, imagesc(max_grad), colormap(gray), title('max grad seuille')


% max_grad_s = (max_grad_n > th);
max_grad_s = (f_normalisation_3D(max_grad) > th);


Ic = f_contours_verts_sur_image(f_crop(I, tf),max_grad_s);
figure, imshow(Ic), title('cretes en vert Nasser')


% imwrite(f_normalisation_3D(f_crop(abs(k1),tf)), 'images_D/k1_wei.png')



