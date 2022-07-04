clear all
close all


%%%% ridge detection of valley detection ?
ridges = 1; % if ridges = 1 ==> ridges, else, valleys

% angular step for the filter ==> from 0 to 360 degrees
delta_theta = 2;


sigmas = [0.58 1.81 2.88 3.91 4.93 5.94 6.95 7.95 8.96 10 11 12 14 16 18 20 25 30]
%%%%%%
taille_masque = 35; %% to extend margin

for SNR = 2:1:6

    load(['MS_Speckle/ridges_snr_',num2str(SNR)]);
    I = Ib;

    figure, imagesc(I), colormap(gray), title('original image')
    I = f_normalisation(I);

    % add margins
    I0 = f_marges_miroir( I, taille_masque );
    lineMap=zeros(size(I));
    dirMap=zeros(size(I));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%  filter rotation technique : best is bilinear

    % 'nearest'  'bilinear' 'bicubic' 'carre'
    rotation = 'bilinear';

    

    for i = 2:1:5 %2:1:9
        sigma = sigmas(i)
    % filter parameters
    % sigma = 2.1; % derivative width
        rho = sigma * 3;   % half smoothing length

        tic                                                                  
        [M1, M2, m, angleMaxHG, angleMinHG] = f_Derivative_Half_Gaussian_Kernel_D2_MS(I0, sigma, rho, delta_theta, rotation, ridges);
        toc

        % ridge intensities
        Grad = M1 + M2 ; %+ 2*m;
        Grad = (Grad >0) .* Grad;
        figure, imagesc( Grad), colormap(gray), title('Ridge/valley intensities')
        Grad = f_crop( [Grad], taille_masque );

        %  direction perpendicular to the ridge/valley
 
        eta = delta_theta*(angleMinHG + angleMaxHG)/2;  % bissector
        eta = f_crop( [eta], taille_masque ); 
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
%     [max_grad] = f_crop( [max_grad], taille_masque );
    % save max_grad_carre max_grad;
     figure, imagesc( max_grad), colormap(gray), title('max grad')

    max_grad_n =  f_normalisation(max_grad); % normalization
    save(['results_speckle_HK/HK_SNR_',num2str(SNR),'.mat'],'max_grad_n');                               

    
end % for SNR

load chirp;sound(y,Fs);
