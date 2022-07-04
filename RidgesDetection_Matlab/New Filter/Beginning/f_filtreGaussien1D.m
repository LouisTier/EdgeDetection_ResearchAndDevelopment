function [gaussian_signal] = f_filtreGaussien1D(signal, sigma, sigmaB)
  
size = length(signal); %Taille du signal 1D
k = (sigmaB**2)/(sigma**2) % ???
rho = sigmaB/sigma %Scale ratio

b_inf = -4*sigma;
b_sup = 4*sigma;

G = fspecial('gaussian', [1 size], sigma); %Filtre Gaussien pour sigma 
G2 = diff(diff(G)); %Dérivée seconde du filtre Gaussien pour sigma
GB = fspecial('gaussian', [1 size], sigmaB); %Filtre Gaussien pour sigmaB   
G2B = diff(diff(GB)); %Dérivée seconde du filtre Gaussien pour sigmaB

resultat = [];

% G(sigmaS, t) = H(t)*exp(-t²/2*sigmaS²) H is the Heaviside function
% a semi-Gaussian for the smoothing in the y direction (vertically)

%G''(sigmaD,t) = ((t² - sigmaD²)/(sigmaD**4)) * exp(-t²/2*sigmaD²)
%a second derivative of a Gaussian in the x direction (horizontally)

for i = 1:8*sigma
   disp('TEST');
   if (i <= 3*sigma)
     signal_filtered = k*G2B(i-sigmaB+sigma); 
     disp('Tes2');
     disp(signal_filtered);
   elseif (i < 5*sigma) && (i >3*sigma)
     signal_filtered = G2(i);  
     disp('Tes3');
     disp(signal_filtered);
   else (i >= 5*sigma)
     signal_filtered = k*G2B(i+sigmaB-sigma);
     disp(signal_filtered);  
     
   endif
   
   resultat.append(signal_filtered);
   disp('HAHA')
   
endfor

gaussian_signal = resultat;
disp('OHOH')

endfunction