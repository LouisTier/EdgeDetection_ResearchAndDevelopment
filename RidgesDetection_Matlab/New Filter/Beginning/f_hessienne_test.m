function [Ix, Iy, Ixixi, Ixx, Iyy, Ixy] = f_hessienne_test(I,sigma,sigma_b)

syms x; %x est une variable
syms y;

assume(x, 'real'); %on dit que x est un réel
assume(y, 'real'); %on dit que x est un réel

borne = 100;
abscisse = -borne:1:borne; %Plage de la gaussienne

rho = sigma_b/sigma; %Scale ratio
k = rho^2;

%Gaussienne d'écart-type sigma
G(x) = (exp(-x^2/(2*(sigma)^2)));

%Gaussienne d'écart-type sigma_b
H(x) = exp(-x^2/(2*(sigma_b)^2));

%Constante pour le lissage
c0 = (exp(-1/2)/sqrt(2*pi))*((sigma_b./sigma)-1)*(1/sigma);

%fonction de composition pour H2
gauche(x) = x - sigma_b + sigma;
droite(x) = x + sigma_b - sigma;

%On indique piecewise(plage,compose(fonction,variable), autre valeur), l'autre valeur s'applique si ce n'est pas 
%inférieur à sigma
f_gauche(x) = piecewise(x<=sigma, compose(k*H,gauche),0); 
f_milieu(x) = piecewise(abs(x)<sigma,G + c0,0);
f_droite(x) = piecewise(x>=sigma, compose(k*H,droite),0);

%Fonction finale qui implémente les 3 précédentes
BG(x) = piecewise(x<=-sigma, f_gauche, abs(x)<sigma, f_milieu, x>=sigma, f_droite,0);


%Calcul des coefficients de la matrice hessienne
[gx, gy] = gradient(double(I));
[gxx, gxy] = gradient(gx);
[gxy, gyy] = gradient(gy);



