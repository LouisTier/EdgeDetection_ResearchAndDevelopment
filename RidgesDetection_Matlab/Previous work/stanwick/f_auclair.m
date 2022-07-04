function [ Ixx, Iyy, Ixy ]  = f_auclair( I, s)
 
%%%%%% normalisation

borne = 600;

% support et gaussienne
x = -borne:1:borne; 

g =  (1 + s*abs(x)) .* exp(-s * abs(x));

% masques derivee premiere et seconde
dx = [1 0 -1]; 
 
% calcul du coefficient de normalisation C0
S0 = sum(g);
C0 = 1/S0;

g0 = C0 * g;
%    figure, plot(x,G0), xlim([-10,10])
    
    
% on regarde jusqu'a ou la gaussienne > 10^(-5)    
seuil = 10^(-5);
G =1;
% y =0;
incr = borne +1;
tampon = 0;
while (G > seuil)
    G = g0(incr);
    incr=incr+1;
    tampon = tampon +1;
%     y=[y G0(incr)];
end


% du coup, on a notre nouveau support
X = -tampon:1:tampon;

% gaussienne discrete normalisee
Gn = C0 * (1 + s*abs(X)) .* exp(-s * abs(X));

% figure, plot(Gn), title('g normalized')



% derivee 1ere   discrete normalisee
% Gx = conv(Gn, dx, 'replicate');
Gx = conv(Gn, dx, 'same'); % evite les aberations aux bords (supprime un pixel a droite et a gauche)
%   figure, plot(Gx), title('derivee 1  discrete normalisee')
  
% derivee 2nde   discrete normalisee
% Gxx = -conv(Gx, dx, 'replicate');
Gxx = conv(Gx, dx, 'same'); % evite les aberations aux bords (supprime un pixel a droite et a gauche)
% figure, plot(Gxx) , title('derivee 2  discrete normalisee')
%  sum(sum(Gxx))



% convolution avec l'image
Ixx = double(imfilter(imfilter(I,Gn'),Gxx));
Iyy = double(imfilter(imfilter(I,Gn),Gxx'));
%     I2 = double(imfilter(I, Gxx, 'replicate', 'conv'));

    
%                 figure
%          imagesc(Ixx),colormap(gray)
%           title('derivee seconde en x')
%           
%           figure
%                    imagesc(Iyy),colormap(gray)
%           title('derivee seconde en y')
          
%           Iyyi = f_inverse(Iyy);
%                           figure
%          imagesc(Iyyi),colormap(gray)
%           title('derivee seconde inverse  en y')
          
          
          
%           % derivees premieres
%   figure, 
% plot(Gx), title('derivee 1 gaussienne discrete normalisee')
 
 
Ix = double(imfilter(imfilter(I,Gn'),Gx));         
%         Ixy = double(imfilter(Ix,Gx','replicate', 'conv'));
% Ixy = double(imfilter(imfilter(Ix,Gn),Gx','replicate', 'conv'));
Ixy = double(imfilter(imfilter(Ix,Gn),Gx','replicate', 'same'));

%       figure, imagesc(Iyy),colormap(gray)
%           title('derivee seconde en y')
%  
%    figure, hold on
%    bar(X,Gn ),  
%    plot(X,Gn,'r','LineWidth',3), xlim([X(1),X(end)]),ylim([0, max(Gn)])
   
%       figure, hold on
%    bar(X,Gx ),  
%    plot(X,Gx,'r','LineWidth',3), xlim([-10,10]),ylim([-0.15,0.15]),legend(['\sigma =',num2str(sigma) ]);
 


end

