I = 255 - I0 ;

I = f_marges_miroir(I, tf);
  

[ Ixx, Iyy, Ixy  ] = f_10m1( I );


A= Ixx;
B= Ixy;
C= Ixy;
D= Iyy;

% figure, imagesc(Ixx), colormap(gray), title('Ixx')
% figure, imagesc(Iyy), colormap(gray), title('Iyy')
% figure, imagesc(Ixy), colormap(gray), title('Ixy')

[ lambdap, lambdam, theta ] = f_valeurs_propres_et_direction_vecteur_propre( A, B, C, D );
% figure, imagesc(theta), colormap(gray), title('\theta before')

% figure, imagesc(lambdap), colormap(gray), title('\lambda_{+}')
 
theta = pi/2 - theta ;

% figure, imagesc(theta), colormap(gray), title('\theta')

% theta = f_translate_pi( theta ); % si directions <0

max_grad = f_max_grad_pi_4(lambdap,pi-theta);
max_grad_n = f_normalisation_3D(f_crop(max_grad, tf));



% figure, imagesc(max_grad_n), colormap(gray), title('max grad normalized')


% max_grad_s = (max_grad_n > th);

%%%%%%%%%%
% pc = 0.2
m = sum(sum(max_grad_n > 0))
m = 15000
n = m;

TH = 0
while n > m*pc
    n = sum(sum(max_grad_n > TH))
    TH = TH + 0.001
end

th = TH

max_grad_s = (max_grad_n > th);


% theta_s = (theta < s_theta);
figure, imagesc(max_grad_s), colormap(gray), title('max grad seuille')

% imwrite(max_grad_s,'max_crete_gaussienne_d2.png');


Ic = f_contours_verts_sur_image(I0,max_grad_s);
% Ic = f_contours_verts_sur_image(I,theta_s);
figure, imshow(uint8(Ic)), title('cretes en vert')
% imwrite(Ic, 'dragonfly_101.png')
 
imwrite(max_grad_s, ['result/m101_pc_',num2str(pc),'.png'])


%%%%% 
% lambdap lambdam
% k1 = lambdap;
% k2 = lambdam;
% 
% D1 = sqrt(k1.^2 + k2.^2);% lindeberg 1
% D2 = (k1.^2 + k2.^2).^2;% lindeberg 2
% % D0 = k1;% Nasser
% D3 = abs(k1 - k2).*abs(k1 + k2); % tremblais
% 
% 
% imwrite(f_normalisation_3D(f_crop(D1,tf)), 'images_D/D1g.png')
% imwrite(f_normalisation_3D(f_crop(D2,tf)), 'images_D/D2g.png')
% imwrite(f_normalisation_3D(f_crop(D3,tf)), 'images_D/D3g.png')
