function [M1, M2, C1, C2] = f_Derivative_Half_Bi_Gaussian_Kernel_D2_plot(I0, sigma, sigma_s, rho, delta_theta, rotation, ridges)
% v0 : normalization of the filter using sum(sum(F))

syms x; %x est une variable

assume(x, 'real'); %on dit que x est un réel

abscisse = -20:1:20; %Plage de la gaussienne

sigma_b = sigma .* rho; %Paramètres des 2 gaussiennes de part et d'autre de la centrale
k = rho^2;

%Gaussienne d'écart-type sigma
G(x) = (exp(-x^2/(2*(sigma)^2)));
G2(x) = diff(diff(G)); %Calcul analytique de la dérivée 2nde de la gausienne sigma

%Gaussienne d'écart-type sigma_b
H(x) = (exp(-x^2/(2*(sigma_b)^2)));
H2(x) = diff(diff(H));

%Constante pour le lissage
c0 = (exp(-1/2)/sqrt(2*pi))*((sigma_b/sigma)-1)*(1/sigma);

    gauche(x) = x - sigma_b + sigma;
    droite(x) = x + sigma_b - sigma;

% f_gauche = compose(k*H2,gauche)*Indic_gauche;  pas terrible
f_gauche(x) = piecewise(x<=sigma, compose(k*H,gauche),0); %On indique piecewise(plage,compose(fonction,variable), autre valeur)
% L'autre valeur s'applique si ce n'est pas inférieur à sigma

%f_milieu = G2*Indic_milieu; pas terrible
f_milieu(x) = piecewise(abs(x)<sigma,G + c0,0);

f_droite(x) = piecewise(x>=sigma, compose(k*H,droite),0);

%Fonction finale qui implémente les 3 précédentes
BG(x) = piecewise(x<=-sigma, f_gauche, abs(x)<sigma, f_milieu, x>=sigma, f_droite,0);
%f_res(x) = cumsum([f_droite f_milieu f_gauche]) %Autre méthode pour afficher la courbe finale
BG2(x) = -diff(diff(BG)); %-1 permet de passer de la détection de vallées à la détection de crêtes


if ridges
    dx = [-1 0 2 0 -1];  % filter for ridge detection
else
    dx = [1 0 -2 0 1];  % filter for valley detection
end

X1 = 77  % to visualize a signal of a specific point in the image
Y1 = 23
ss = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we create the filter support in 2D
% for that, we need the highest parameter beween sigma and rho
param_gauss = max(sigma, sigma_s);


%      filter convergence
borne = 200;

% Gaussian support as a function of the highest parameter of the 2D
% anisotropic Gaussian
x = -borne:1:borne;      
G = exp(-x.^2 / (2*param_gauss^2));

% compute normalization coeff C0
S0 = sum(G);
C0 = 1/S0;

% new Gaussian
G0 = C0 * exp(-x.^2 / (2*param_gauss^2));
%    figure, plot(x,G0), xlim([-10,10])
    
    
% where the Gaussian > 10^(-k)    for support of the normalized Gaussian
seuil = 10^(-3);
g =1;
% y =0;
incr = borne +1;
tampon = 0;
while (g > seuil)
    g = G0(incr);
    incr=incr+1;
    tampon = tampon +1;
end

% new Gaussian support
X = -tampon:1:tampon;

%%%%%%%%%%%%%%%%%
abscisse = -tampon:1:tampon; %Plage de la bi-gaussienne

BG_value = double(feval(BG,abscisse)); %On évalue la fonction créée ci-dessus sur la plage d'abscisses arbitraire
% définie en début de code, et Gaussienne simple
BG2_value = double(feval(BG2,abscisse)); %Gaussienne seconde

% filter normalization : PB ici
PosF2 = ((BG2_value>0).*BG2_value);
NegF2 = ((BG2_value<0).*BG2_value);
MM2 = sum(sum( PosF2 ));
mm2 = -sum(sum( NegF2 ));
PosF2_norm = PosF2 / MM2;
NegF2_norm = NegF2 / mm2;
L2  = PosF2_norm + NegF2_norm ;

figure, plot(L2)


%  discrete normalized Gaussian in x, then derivation
Gn = C0 * exp(-X.^2 / (2*sigma^2));

% seconde derivative 
Gx = conv(Gn, dx, 'same'); % evite les aberations aux bords (supprime un pixel a droite et a gauche)

% half Gaussian in y
Gr = C0 * exp(-X.^2 / (2*sigma_s^2));

% figure, plot(Gn), title('Gn')
% figure, plot(Gx), title('Gx')

% filter support in 2D
H = zeros(length(X), length(X));

% build of 2D HK : line in the midle = 1D derivative
% H(tampon+1,:) = Gx;
H(tampon+1,:) = BG2_value;
% figure, imagesc(H), colormap(gray)

% H = BG2_value;
% figure, imagesc(H), colormap(gray), title('H avant lissage')

% convolution with vertical Gaussian to build anisotropic filter
HG = conv2(H, Gr', 'same'); % convolution for vertical smoothing

% figure, imagesc(HG), colormap(gray), title('H apres convergence')

%  heaviside function, to cut the filter
HG(tampon+2:end,:) =0;

%%% avoid border problems : init to 0 ;  filter rotation
HG(:,1) = 0; 
HG(:,end) = 0;

% figure, imagesc(HG), colormap(gray) , title('anisotropic filter')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% filter visualization
Im0 = zeros(51, 51);
Im0(25, 25) = 1;
F0 = double(imfilter(Im0,HG));
figure, imshow(F0, []), title ('original filter')
imwrite(f_normalisation(F0), 'filter_HK_D2.png')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% add margins of the filter to rotate him
HG = f_marges_noires(HG);


%%%%%%%%%%%%%%%% maxima (M1, M2) and directions (C1, C2)
M1 = zeros(size(I0));
M2 = zeros(size(I0));
C1 = ones(size(I0));
C2 = ones(size(I0));

% size of the image for loop next
[s1 s2]= size(I0 );

% angle index
angle = 1;


for rotation_filter_angle = 0:delta_theta:360-delta_theta
    rotation_filter_angle
    
    % filter rotation (different techniques)
    if(strcmp(rotation, 'nearest')) 
        HG_angle{angle}  = imrotate(HG, rotation_filter_angle, 'nearest', 'crop');
    elseif(strcmp(rotation, 'bilinear'))
        HG_angle{angle}  = imrotate(HG, rotation_filter_angle, 'bilinear', 'crop');
    elseif(strcmp(rotation, 'bicubic'))
        HG_angle{angle}  = imrotate(HG, rotation_filter_angle, 'bicubic', 'crop');
    elseif(strcmp(rotation, 'condat'))
        HG_angle{angle}  = imrotate_condat(HG, rotation_filter_angle);
    elseif(strcmp(rotation, 'carre'))
        HG_angle{angle}  = imrotate_carre(HG, rotation_filter_angle);
    end
    
    %%%% uncomment for visualization of the rotated filter
%   figure, imagesc(HG_angle{angle}), colormap(gray)
    

        % filter normalization
    PosF = ((HG_angle{angle}>0).*HG_angle{angle});
    NegF = ((HG_angle{angle}<0).*HG_angle{angle});
    MM(angle) = sum(sum( PosF ));
    mm(angle) = -sum(sum( NegF ));
    
    PosF = PosF / MM(angle);
    NegF = NegF / mm(angle);

%   figure, imagesc(HG_angle{angle}), colormap(gray), title('filter avant conv')

    HG_angle{angle}  = PosF + NegF ; % final rotated normalized filter

    
    IangleHF{angle} = double(imfilter(I0,HG_angle{angle}));
%     figure, imagesc( IangleHF{angle}), colormap(gray)


%% uncomment to save 2D HK
M = max(max(HG_angle{angle}));
m = min(min(HG_angle{angle}));
% normalization to keep 128 at 0 of the filter value
HG_angle{angle} = (HG_angle{angle} + max(M,m) )/ (2*max(M,m));

HG_angle{angle}((length(HG_angle{angle})+1)/2,(length(HG_angle{angle})+1)/2)=1;
    imwrite(flip(HG_angle{angle},2), ['HK\HGFilter_',num2str(angle),'.png']);
%     %%%%%
 

%% uncomment for signal visualization
IangleHF{angle}(X1,Y1);
ss = [ss IangleHF{angle}(X1,Y1)];

%%% attention, d?calage car angle + 1 pas encore cr?? !!
    if angle > 2
        for i = 1:s1
            for j = 1:s2                
                 
                % compute first and second maxima in the 1D signal
                if (IangleHF{angle-1}(i,j) > M1(i,j)) && (IangleHF{angle-1}(i,j) > IangleHF{angle-2}(i,j)) && (IangleHF{angle-1}(i,j) > IangleHF{angle}(i,j))
                       M2(i,j) = M1(i,j);
                       C2(i,j) = C1(i,j);
                       M1(i,j) = IangleHF{angle-1}(i,j);
                       C1(i,j) = angle-2; % yes "-1"
                elseif IangleHF{angle-1}(i,j) >= M2(i,j) && IangleHF{angle-1}(i,j) > IangleHF{angle-2}(i,j) && IangleHF{angle-1}(i,j) > IangleHF{angle}(i,j)
                       M2(i,j) = IangleHF{angle-1}(i,j);
                       C2(i,j) = angle-2; % yes "-1"
                end
            end
        end
    end
    angle = angle +1;
end


%%%%%%%%%%%%%%%%%%% last angle and first angle (depends of both first and
%%%%%%%%%%%%%%%%%%% last angles, that is why they are outside the loop
angle = angle -1; % for last angle in the computation
for i = 1:s1
    for j = 1:s2                
        %%%%%%%%%%%%%%%%%%% last angle
        if (IangleHF{angle}(i,j) > M1(i,j)) && (IangleHF{angle}(i,j) >= IangleHF{angle-1}(i,j)) && (IangleHF{angle}(i,j) >= IangleHF{1}(i,j))
               M2(i,j) = M1(i,j);
               C2(i,j) = C1(i,j);
               M1(i,j) = IangleHF{angle}(i,j);
               C1(i,j) = angle-1; % yes "-2"
        elseif IangleHF{angle}(i,j) > M2(i,j) && IangleHF{angle}(i,j) >= IangleHF{angle-1}(i,j) && IangleHF{angle}(i,j) >= IangleHF{1}(i,j)
               M2(i,j) = IangleHF{angle}(i,j);
               C2(i,j) = angle-1; % yes "-2"
        end
        
        %%%%%%%%%%%%%%%%%%% first angle
        if (IangleHF{1}(i,j) > M1(i,j)) && (IangleHF{1}(i,j) >= IangleHF{angle}(i,j)) && (IangleHF{1}(i,j) >= IangleHF{2}(i,j))
               M2(i,j) = M1(i,j);
               C2(i,j) = C1(i,j);
               M1(i,j) = IangleHF{1}(i,j);
               C1(i,j) = 0; 
        elseif IangleHF{1}(i,j) > M2(i,j) && IangleHF{1}(i,j) >= IangleHF{angle}(i,j) && IangleHF{1}(i,j) >= IangleHF{2}(i,j)
               M2(i,j) = IangleHF{1}(i,j);
               C2(i,j) = 0; 
        end
    end
end


%%% uncomment to watch values of selected points and plot signals
M1(X1, Y1)
M2(X1, Y1)
C1(X1, Y1)
C2(X1, Y1)



figure(100), plot(ss)
save(['plot_1D/signal_dela_theta_',num2str(delta_theta),'.mat'],'ss')
ss