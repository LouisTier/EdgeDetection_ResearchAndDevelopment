clear all
close all


%%%% ridge detection of valley detection ?
ridges = 1; % if ridges = 1 ==> ridges, else, valleys


% DT = [1 2 5 10 15 22.5 45 90]
% DT = 45
DT = 1

% sigma = [0.58 1.81 2.88 3.91 4.93 5.94] % 6.95 7.95 8.96]; %Paramètre de la gaussienne centrale

%filter parameters
sigma = 3.91; % derivative width
sigma_s = 5*sigma;   % half smoothing length
rho = 0.5

%%%%%%
taille_masque = 35; %% to extend margin


% original image
% I = double(imread( 'bureau256.png'));
% I = double(imread( 'doigts_wei.bmp'));
% I = double(imread( 'cercle_blanc.png'));
% I = double(imread( 'cercles_concentriques.jpg'));
% I = double(imread( 'Stanwick-small.png'));
% I = double(imread( 'Stanwick_crop.png')); 
I = double(imread( 'bw_025_256x256.TIF')); 

% I = double(imread( 'Stanwick_curve_crop.png')); 
% I = zeros(96, 96); I(48, :) = 1;


figure, imagesc(I), colormap(gray), title('original image')
I = f_normalisation(I);

% add margins
% taille_masque = 1   % <=========================== for plot
I0 = f_marges_miroir( I, taille_masque );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  filter rotation technique : best is bilinear

% 'nearest'  'bilinear' 'bicubic' 'carre'
rotation = 'bilinear';


% angular step for the filter ==> from 0 to 360 degrees

for i=1:1:length(DT)
    delta_theta = DT(i);


    tic                                     
    [M1, M2, angleMaxHG, angleMinHG] = f_Derivative_Half_Bi_Gaussian_Kernel_D2_plot(I0, sigma, sigma_s, rho, delta_theta, rotation, ridges)
%     [M1, M2, angleMaxHG, angleMinHG] = f_Derivative_Half_Gaussian_Kernel_D2_plot(I0, sigma, rho, delta_theta, rotation, ridges);
    toc

    % ridge intensities
    Grad = M1 + M2;
    % figure, imagesc( Grad), colormap(gray), title('Ridge/valley intensities')

    %%% angles
    % figure, imagesc( angleMaxHG), colormap(gray), title('direction of kernel 1')
    % figure, imagesc( angleMinHG), colormap(gray), title('direction of kernel 2')

    %  direction perpendicular to the ridge/valley
    eta = delta_theta*(angleMinHG + angleMaxHG)/2;  % bissector
    % figure, imagesc( eta), colormap(gray), title('\eta direction perpendicular to the ridge')


    % change direction for non maxima suppression (can be optimized)
    eta = - eta;  %  inverse angle
    eta = eta+180 ;
    [ eta ] = f_retire_180( eta );
    eta = eta*pi/180;
    [ eta ] = f_translate_pi( eta ); 
    [ eta ] = f_remove_pi( eta );

    % non maxima suppression
    [max_grad] = f_max_grad_pi_4_v3(Grad , eta);
    [max_grad] = f_crop( [max_grad], taille_masque );
    % save max_grad_carre max_grad;
    %  figure, imagesc( max_grad), colormap(gray), title('max grad')

    max_grad_n =  f_normalisation(max_grad); % normalization

    %%%%%%%%%%%% threshold
        max_grad = (max_grad >0) .* max_grad;
        max_grad_n =  f_normalisation(max_grad); % normalization
        m = sum(sum(max_grad_n > 0))
        n   = m;
        pc = 0.3

        TH = 0
        while n > m*pc
            n = sum(sum(max_grad_n > TH))
            TH = TH + 0.001
        end


        max_grad_s = max_grad_n>TH;            % thresholding
     figure, imshow( max_grad_s), title('max grad th')

    imwrite( max_grad_s, ['plot_1D/Stan_crop_dela_theta_',num2str(delta_theta),'.png'])

end
