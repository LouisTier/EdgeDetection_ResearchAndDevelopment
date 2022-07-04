clear all
close all

width = 3

if width == 3 %Largeur des signaux
    sigma = 1.81
    sigma_b = 0.5
    sz = 0.63
    sr = 0.69    
elseif width == 5
    sigma = 2.88
    sigma_b = 0.5
    sz = 0.37
    sr = 0.42
end


th = 0.2

pc = 0.5 %pourcentage de pixels qu'on garde dans le résultat après supression des non maximas locaux
%peu de crêtes et beaucoup de bruits => on descend le pc
tf = 33;


I0 = imread('heart.png');
I = f_marges_miroir( I0, tf ); % filtre taille 3
I = f_normalisation(I);



[dimy , dimx]= size(I); % nb lignes, nb colonnes



[ Ix, Iy, Ixixi, Ixx, Iyy, Ixy  ] = f_hessian_discontinue( I, sigma, sigma_b );

IxIy = Ix.*Iy;
Coef = 1 ./( ( 1 + Ix.^2 + Iy.^2 ).^(3/2));    %%%%% d (Nasser)

A=  Ixx;
B=  Ixy;
C=  Ixy;
D=  Iyy;

% A= Coef.*( Ixx + Ixx.* (Iy.^2) - IxIy.*Ixy );
% B= Coef.*( Ixy + Ixy.* (Iy.^2) - IxIy .* Iyy );
% C= Coef.*( - Ix .* Iy .* Ixx + Ixy +  Ixy.*(Ix.^2) );
% D= Coef.*( - IxIy.*Ixy + Iyy + Iyy.*(Ix.^2) );

% figure, imagesc(Ixx), colormap(gray), title('Ixx')
% figure, imagesc(Iyy), colormap(gray), title('Iyy')

[ k1, k2, theta ] = f_valeurs_propres_et_direction_vecteur_propre( A, B, C, D );
%k1 et k2 correspondent au valeur propre
 figure, imagesc(k1), colormap(gray), title('k_1')
 figure, imagesc(theta), colormap(gray), title('\theta')%On s'en sert pour supprimer les non maximas locaux

% D1
[ max_grad_steger ] = f_steger( I, k1, k2, theta, th, tf );
% max_grad_s = (max_grad_n > th);
max_grad_steger = (max_grad_steger >0).* max_grad_steger;
%%%%%%%%%%
% pc = 0.2
m = sum(sum(max_grad_steger > 0))
n = m;
TH = 0
while n > m*pc
    n = sum(sum(max_grad_steger > TH))
    TH = TH + 0.001
end

th = TH
max_grad_D1 = (f_normalisation_3D(max_grad_steger) > th);
IcD1 = f_contours_verts_sur_image(I0,max_grad_D1);

% D2
[ max_grad_lindeberg_1 ] = f_lindeberg_1( I, k1, k2, theta, th, tf );
%%%%%%%%%%
m = sum(sum(max_grad_lindeberg_1 > 0))
n = m;
TH = 0
while n > m*pc
    n = sum(sum(max_grad_lindeberg_1 > TH))
    TH = TH + 0.001
end

th = TH
max_grad_D2 = (f_normalisation_3D( max_grad_lindeberg_1) > th);
IcD2 = f_contours_verts_sur_image(I0,max_grad_D2);

% D3
% [ max_grad_lindeberg_2 ] = f_lindeberg_2( I, k1, k2, theta, th, tf );
% max_grad_s = (f_normalisation_3D(max_grad_lindeberg_2) > th);
% IcD3 = f_contours_verts_sur_image(I0,max_grad_s);

% D4
[ max_grad_tremblais ] = f_tremblais( I, k1, k2, theta, th, tf );
%%%%%%%%%%
m = sum(sum(max_grad_tremblais > 0))
n = m;
TH = 0
while n > m*pc
    n = sum(sum(max_grad_tremblais > TH))
    TH = TH + 0.001
end

th = TH
max_grad_D4 = (f_normalisation_3D(max_grad_tremblais) > th);
IcD4 = f_contours_verts_sur_image(I0,max_grad_D4);
 
imwrite(max_grad_D1, ['result/D1_sigma_',num2str(sigma),'_pc_',num2str(pc),'.png'])
imwrite(max_grad_D2, ['result/D2_sigma_',num2str(sigma),'_pc_',num2str(pc),'.png'])
% imwrite(umax_grad_D3, ['heart/D3_sigma_',num2str(sigma),'_pc_',num2str(pc),'.png'])
imwrite(max_grad_D4, ['result/D4_sigma_',num2str(sigma),'_pc_',num2str(pc),'.png'])

a = f_lineness(k1,k2);
disp(a);


