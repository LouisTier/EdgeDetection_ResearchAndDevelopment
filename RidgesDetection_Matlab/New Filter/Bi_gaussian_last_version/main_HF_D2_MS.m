clear all
close all


%%%% ridge detection of valley detection ?
ridges = 1; % if ridges = 1 ==> ridges, else, valleys

% angular step for the filter ==> from 0 to 360 degrees
delta_theta = 2;



%%%%%%
taille_masque = 35; %% to extend margin


% original image
% I = double(imread( 'bw_001_256x256.TIF')); ridges = 0; % zebre
% I = double(imread( 'bw_002_256x256.TIF')); ridges = 0; % banc
% I = double(imread( 'bw_005_256x256.TIF')); ridges = 0; % papillon
% I = double(imread( 'bw_022_256x256.TIF')); ridges = 0; % dessin
I = double(imread( 'bw_025_256x256.TIF'));  % roue
% I = double(imread( 'arbrespir.bmp')); ridges = 0; % dessin sigma = 1:2:12
% I = double(imread( 'heart.png'));  
% I = double(imread( '35.png'));  ridges = 0;
% I = double(imread( 'goldgate.png'));  I = I(:,:,3); ridges = 0;

% I = double(imread( 'kvp3i4ps.bmp')); ridges = 1; pc = 0.05 % dessin sigma = 1:2:12
% I = double(imread( 'image_8_crop.png')); ridges = 1; pc = 0.5 % dessin sigma = 1:2:12
% I = double(imread( 'route.bmp')); ridges = 1; pc = 0.05 % dessin sigma = 1:2:12



% I = double(imread( 'bureau256.png'));
% I = double(imread( 'doigts_wei.bmp'));
% I = double(imread( 'cercle_blanc.png'));
% I = double(imread( 'cercles_concentriques.jpg'));
% I = (imread( 'chat_valleys.jpg')); I = double(rgb2gray(I)); ridges = 0;
% I = double(imread( 'muscle.jpg'));
% I = double(imread( 'angiogra.jpg'));
% load coroav1.mat ; I = seqb24;
% load coroav2.mat ; I = seqb25;

% I = (imread( 'figurine_elder_zucker.jpg')); ridges = 0;
% I = double(imread( 's60cb040.png'));  ridges = 0;
% I = double(imread( '19.png'));  
% I = double(imread( '25.png'));  ridges = 0;
% I = double(imread( 'sar-large.png'));
% I = double(imread( 'srl2-angkor.png'));   
% I = double(imread( 'srl2-dc.png'));  ridges = 0; % sigma = 8:1:12
% I = double(imread( 'Stanwick.png'));   
% I = double(imread( 'Stanwick-small.png'));   
% I = double(imread( 'IoD-001_VV_div8.png'));  I = I(:,:,3);



figure, imagesc(I), colormap(gray), title('original image')
I = f_normalisation(I);

% add margins
I0 = f_marges_miroir( I, taille_masque );
lineMap=zeros(size(I0));
dirMap=zeros(size(I0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  filter rotation technique : best is bilinear

% 'nearest'  'bilinear' 'bicubic' 'carre'
rotation = 'bilinear';

sigmas = [0.58 1.81 2.88 3.91 4.93 5.94 6.95 7.95 8.96 10 11 12 14 16 18 20 25 30]

for i = 2:1:5
    sigma = sigmas(i)
% filter parameters
% sigma = 2.1; % derivative width
    rho = sigma * 5;   % half smoothing length

    tic                                                                  
    [M1, M2, m, angleMaxHG, angleMinHG] = f_Derivative_Half_Gaussian_Kernel_D2_MS(I0, sigma, rho, delta_theta, rotation, ridges);
    toc

    % ridge intensities
    Grad = M1 + M2 ; %+ 2*m;
    Grad = (Grad >0) .* Grad;
    figure, imagesc( Grad), colormap(gray), title('Ridge/valley intensities')
    % normalization
%     Grad = 2*(sigma + 1/(sqrt(sigma))).* Grad; % semble bien


    Grad = ((sigma)^(1/sigma) + 1/(sqrt(sigma))).* Grad; % semble bien

%     Grad = ( 1/(sqrt(sigma))).* Grad;


    %  direction perpendicular to the ridge/valley
    eta = delta_theta*(angleMinHG + angleMaxHG)/2;  % bissector
%     figure, imagesc( eta), colormap(gray), title('\eta direction perpendicular to the ridge')

    dirMap(Grad>=lineMap)=eta(Grad>=lineMap);
    lineMap(Grad>=lineMap)=Grad(Grad>=lineMap);    
    

%             dirMap(filteredIm>lineMap)=params.theta;
%             lineMap(filteredIm>lineMap)=filteredIm(filteredIm>lineMap);

%%% angles
% figure, imagesc( angleMaxHG), colormap(gray), title('direction of kernel 1')
% figure, imagesc( angleMinHG), colormap(gray), title('direction of kernel 2')

end


% change direction for non maxima suppression (can be optimized)
dirMap = - dirMap;  %  inverse angle
dirMap = dirMap+180 ;
[ dirMap ] = f_retire_180( dirMap );
dirMap = dirMap*pi/180;
[ dirMap ] = f_translate_pi( dirMap ); 
[ dirMap ] = f_remove_pi( dirMap );

 figure, imagesc( lineMap), colormap(gray), title('Final fusion')


% non maxima suppression
[max_grad] = f_max_grad_pi_4_v3(lineMap , dirMap);
[max_grad] = f_crop( [max_grad], taille_masque );
% save max_grad_carre max_grad;
 figure, imagesc( max_grad), colormap(gray), title('max grad')

max_grad_n =  f_normalisation(max_grad); % normalization

% pc = 0.2


%pc = 0.3
for pc = 0.20:0.05:0.6
max_grad_n =  f_normalisation(max_grad); % normalization
m = sum(sum(max_grad_n > 0))
n = m;

TH = 0
while n > m*pc
    n = sum(sum(max_grad_n > TH))
    TH = TH + 0.001
end


max_grad_s = max_grad_n>TH;            % thresholding
 figure, imshow( max_grad_s), title('max grad th')
 
imwrite( max_grad_s, 'ridges_HK.png')

imwrite( max_grad_s, ['filament/ridges_HK_pc_',num2str(pc),'.png'])
imwrite( f_normalisation(f_crop(lineMap, taille_masque)), 'filament/linemap_HK.png')
imwrite( max_grad_n, ['filament/max_grad_HK.png'])
end
