function [ max_grad ] = f_steger( I, k1, k2, theta, th, tf )



% D = sqrt(k1.^2 + k2.^2);% lindeberg 1
% D = (k1.^2 + k2.^2).^2;% lindeberg 2
D = k1;% Steger
% D = abs(k1 - k2).*abs(k1 + k2); % tremblais

% figure, imagesc(D), colormap(gray), title('D Lindeberg 1')

% theta = theta + pi/2 ;
theta = pi/2 - theta  ;

% theta = f_translate_pi( theta ); % si directions <0

max_grad = f_crop(f_max_grad_pi_4(D,theta), tf);


% figure, imagesc(max_grad), colormap(gray), title('max grad')


% max_grad_s = (max_grad_n > th);
max_grad_s = (f_normalisation_3D(max_grad) > th);

% 
% Ic = f_contours_verts_sur_image(f_crop(I, tf),max_grad_s);
% figure, imshow(Ic), title('cretes en vert Lindeberg 1')

