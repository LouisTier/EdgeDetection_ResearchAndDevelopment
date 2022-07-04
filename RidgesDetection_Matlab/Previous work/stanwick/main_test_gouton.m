s = sr

I = f_marges_miroir( 255 - I0, tf );

% s= 0.69
alpha = s
w = s

[ Ixx, Iyy, Ixy  ] = f_gouton( I, alpha, s, w );


% IxIy = Ix.*Iy;

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

max_grad = f_crop(f_max_grad_pi_4(lambdap,pi-theta), tf);
max_grad = (max_grad > 0) .* max_grad;
max_grad_n = f_normalisation_3D(max_grad);



% figure, imagesc(max_grad_n), colormap(gray), title('max grad normalized')

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
% max_grad_s = (max_grad_n > th);
max_grad_s = (max_grad_n > th);


% theta_s = (theta < s_theta);
figure, imagesc(max_grad_s), colormap(gray), title('max grad seuille')

% imwrite(max_grad_s,'max_crete_gaussienne_d2.png');


Ic = f_contours_verts_sur_image(I0,max_grad_s);
% Ic = f_contours_verts_sur_image(I,theta_s);
figure, imshow(uint8(Ic)), title('cretes en vert')

 imwrite(max_grad_s, ['result/R_s_',num2str(s),'_pc_',num2str(pc),'.png'])