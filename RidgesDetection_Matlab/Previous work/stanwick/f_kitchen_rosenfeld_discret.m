function [ Ix, Iy, Ixixi, Ixx, Iyy, Ixy ] = f_kitchen_rosenfeld_discret( I, sigma )

borne = 600;

% support et gaussienne
x = -borne:1:borne;      
G = exp(-x.^2 / (2*sigma^2));

% masques derivee premiere et seconde
dx = [-1 0 1]; 
dxx = [1 0 -2 0 1];
   
% calcul du coefficient de normalisation C0
S0 = sum(G);
C0 = 1/S0;

G0 = C0 * exp(-x.^2 / (2*sigma^2));
%    figure, plot(x,G0), xlim([-10,10])
    
    
% on regarde jusqu'a ou la gaussienne > 10^(-5)    
seuil = 10^(-1);
g =1;
% y =0;
incr = borne +1;
tampon = 0;
while (g > seuil)
    g = G0(incr);
    incr=incr+1;
    tampon = tampon +1;
%     y=[y G0(incr)];
end


% du coup, on a notre nouveau support
X = -tampon:1:tampon;

% gaussienne discrete normalisee
Gn = C0 * exp(-X.^2 / (2*sigma^2));

% figure, 
% plot(X,Gn), title('gaussienne discrete normalisee')


% derivee 1ere gaussienne discrete normalisee
% Gx = conv(Gn, dx, 'replicate');
Gx = conv(Gn, dx, 'same'); % evite les aberations aux bords (supprime un pixel a droite et a gauche)
%   figure, plot(Gx), title('derivee 1 gaussienne discrete normalisee')
  
% derivee 2nde gaussienne discrete normalisee
% Gxx = -conv(Gx, dx, 'replicate');
Gxx = -conv(Gx, dx, 'same'); % evite les aberations aux bords (supprime un pixel a droite et a gauche)
% figure, plot(Gxx) , title('derivee 2 gaussienne discrete normalisee')
    

% convolution avec l'image
Ixx = double(imfilter(imfilter(I,Gn'),Gxx));
Iyy = double(imfilter(imfilter(I,Gn),Gxx'));
%     I2 = double(imfilter(I, Gxx, 'replicate', 'conv'));

    
%                 figure
%          imagesc(Ixx),colormap(gray)
%           title('derivee seconde en x')
%           
%                    imagesc(Iyy),colormap(gray)
%           title('derivee seconde en y')
          
%           Iyyi = f_inverse(Iyy);
%                           figure
%          imagesc(Iyyi),colormap(gray)
%           title('derivee seconde inverse  en y')
          
          
          
%           % derivees premieres
%   figure, 
% plot(Gx), title('derivee 1 gaussienne discrete normalisee')

%                 figure
% imagesc(I),colormap(gray), title('orig')

Ix = double(imfilter(imfilter(I,Gn'),Gx));
%     Ix = double(imfilter(I,Gx,'replicate', 'conv'));

Iy = double(imfilter(imfilter(I,Gn),-Gx'));

%         figure
% imagesc(Ix),colormap(gray), title('derivee 1ere en x')

Ix2   = Ix.*Ix;
Iy2   = Iy.*Iy;
IxIy  = Ix.*Iy;
Norm2 = Ix2 + Iy2;
        
%         Ixy = double(imfilter(Ix,Gx','replicate', 'conv'));
% Ixy = double(imfilter(imfilter(Ix,Gn),Gx','replicate', 'conv'));
Ixy = double(imfilter(imfilter(Ix,Gn),Gx','replicate', 'same'));

Ixixi = abs(Iy2.*Ixx - 2 * Ix.*Iy.*Ixy + Ix2.*Iyy)./(Norm2); %%% attention valeur absolue
        
Ixixi = f_normalisation (Ixixi);

%    figure, hold on
%    bar(x,G0 ),  
%    plot(x,G0,'r','LineWidth',3), xlim([-10,10]),ylim([0,0.3])
   
%       figure, hold on
%    bar(X,Gx ),  
%    plot(X,Gx,'r','LineWidth',3), xlim([-10,10]),ylim([-0.15,0.15]),legend(['\sigma =',num2str(sigma) ]);
   