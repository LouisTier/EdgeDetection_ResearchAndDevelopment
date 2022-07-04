clear all;
close all;
pkg load image; 

%On va créer un signal et bruit aléatoire (1D)

n = 1000; %Nbre de valeurs pour le signal
fe = 1500; %Freq d'échantillonnage
t = (1:n)/fe %Espace temporel 

%Génération du signal

f0 = 400;
signal_sin = sin(2*pi*f0*t);

%Génération du bruit 

sigma = 1; %Variance du bruit
moy = 2; %Moyenne du bruit
signal_noise = moy + sigma*randn(1,n); 
     
%Génération du signal final     
signal_final = signal_sin + signal_noise;    

G = fspecial('gaussian', [1 1000], sigma=1); %Filtre Gaussien    
G2 = diff(diff(G)); %Dérivée seconde du filtre Gaussien
G3 = f_filtreGaussien1D(signal_final, 1, 0.5)

##GB = fspecial('gaussian', [1 1000], 5); %Filtre Gaussien pour sigmaB   
##G2B = diff(diff(GB)); %Dérivée seconde du filtre Gaussien pour sigmaB
##figure();
##plot(G2B);
##A = G2B(500);

filtered = conv(signal_final,G2); %Convolution entre le signal bruité et le Gaussien

figure();
subplot(3,1,1); plot(signal_sin); title('Signal sinusoïdal');
subplot(3,1,2); plot(signal_noise); title('Signal de bruit');
subplot(3,1,3); plot(signal_final); title('Signal final (sinusoïdal bruité)');

figure();
subplot(3,1,1); plot(G); title('Filtre Gaussien');
subplot(3,1,2); plot(G2); title('Dérivée seconde du filtre Gaussien');
subplot(3,1,3); plot(filtered); title('Convolution de notre signal avec la dérivée seconde de la gaussienne');

#figure();
#plot(G3); title('Test fonction')

