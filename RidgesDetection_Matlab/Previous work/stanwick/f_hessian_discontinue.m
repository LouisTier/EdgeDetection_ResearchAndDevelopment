function [Ix, Iy, Ixixi, Ixx, Iyy, Ixy] = f_hessian_discontinue(I,sigma,sigma_b)

syms x; %x est une variable
assume(x, 'real'); %on dit que x est un réel

borne = 10;
abscisse = -borne:1:borne; %Plage de la gaussienne

rho = sigma_b/sigma;%Scale ratio
k = rho^2;

G(x) = (exp(-x^2/(2*(sigma)^2))); %Gaussienne d'écart-type sigma
H(x) = exp(-x^2/(2*(sigma_b)^2)); %Gaussienne d'écart-type sigma_b
c0 = (exp(-1/2)/sqrt(2*pi))*((sigma_b./sigma)-1)*(1/sigma);%Constante pour le lissage

gauche(x) = x - sigma_b + sigma; %Partie gauche pour la Gaussienne
droite(x) = x + sigma_b - sigma; %Partie droite pour la gusienne

%On indique piecewise(plage,compose(fonction,variable), autre valeur), l'autre valeur s'applique si
% ce n'est pas inférieur à sigma
f_gauche(x) = piecewise(x<=sigma, compose(k*H,gauche),0);
f_milieu(x) = piecewise(abs(x)<sigma,G + c0,0);
f_droite(x) = piecewise(x>=sigma, compose(k*H,droite),0);

%Fonction finale qui implémente les 3 précédentes
BG(x) = piecewise(x<=-sigma, f_gauche, abs(x)<sigma, f_milieu, x>=sigma, f_droite,0);

%Discrétisation de BG(x)
BG_disc = double(feval(BG, abscisse)); %Le double permet de convertir les "sym" en "double"

%Masques derivee premiere et seconde
dx = [-1 0 1];
dxx = [1 0 -2 0 1];

%Calcul du coefficient de normalisation C0
% S0 = sum(BG_disc);
% C0 = 1/S0;
% BG0 = C0 * BG_disc;

A0 = 1
A1 = (1/sqrt(2*pi))*(1-exp(-1/2)+exp(-1/2)*rho)
A2 = (2*exp(-1/2))/(sqrt(2*pi))

NF0 = 1/(erf(1/sqrt(2)) + (2*exp(-1/2)/sqrt(2*pi))*((sigma_b/sigma)-1)+(1-erf(1/sqrt(2))*(sigma_b^2/sigma^2)))
NF1 = sigma
NF2 = sigma^2

% % on regarde jusqu'a ou la gaussienne > 10^(-5)
% seuil = 10^(-1);
% g =1;
% % y =0;
% incr = borne +1;
% tampon = 0;
% while (g > seuil)
%     g = BG0(incr);
%     incr=incr+1;
%     tampon = tampon +1;
%     %     y=[y BG0(incr)];
% end

% On a notre nouveau support
%X = -tampon:1:tampon;

%On veut en discret donc valeur par valeur ==>feval
BGn = NF0*BG_disc; %Gausienne discrete et normalisée
BGx = NF1*conv(BGn, dx, 'same'); % Gaussienne dérivée 1ère, discrete et normalisée
BGxx = NF2*-conv(BGx, dx, 'same'); % Gaussienne dérivée 2nde, discrete et normalisée
% evite les aberations aux bords (supprime un pixel a droite et a gauche)
%same indique que BGx et BGxx auront la même taille que l'image en entrée BGx et BGn

I1 = ['La valeur de intégrale',trapz(BGn)];
disp(I1);
%printf('L intégrale de BG1', );
%printf('L integrale de BG2', );

figure(20);
subplot(1,3,1), plot(abscisse,BGn), title('Gaussienne');
subplot(1,3,2), plot(abscisse,BGx), title('Gaussienne première');
subplot(1,3,3), plot(abscisse,BGxx), title('Gaussienne seconde');

% convolution avec l'image et filtrage
Ix = double(imfilter(imfilter(I,BGn'),BGx)); %dérivée 1ère en x
Iy = double(imfilter(imfilter(I,BGn),-BGx')); %' permet de transposer => x devient y
Ixx = double(imfilter(imfilter(I,BGn'),BGxx)); %dérivée 2nde en x
Iyy = double(imfilter(imfilter(I,BGn), BGxx')); % ' permet de transposer
Ixy = double(imfilter(imfilter(Ix,BGn),BGx','replicate', 'same')); %On filtre Ix par BGn
%Ensuite on filtre le résultat par BGx avec 'replicate' pour les effets de bords et same pour la taille

Ix2   = Ix.*Ix; %Dérivée 1ère au carré en x
Iy2   = Iy.*Iy; %Dérivée 1ère au carré en y
IxIy  = Ix.*Iy; %Produit des dérivées premières xy
Norm2 = Ix2 + Iy2; %Coefficient de normalisation

Ixixi = abs(Iy2.*Ixx - 2 * Ix.*Iy.*Ixy + Ix2.*Iyy)./(Norm2); %Formule du cours
Ixixi = f_normalisation(Ixixi); %Fonction de normalisation classique : I - min / max - min