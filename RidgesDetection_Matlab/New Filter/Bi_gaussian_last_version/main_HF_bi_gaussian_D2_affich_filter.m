clear all
close all


%%%% ridge detection of valley detection ?
ridges = 1; % if ridges = 1 ==> ridges, else, valleys



%filter parameters
sigma = 3.91; % derivative width
sigma_s = 5*sigma;   % half smoothing length
rho = 1
delta_theta = 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  filter rotation technique : best is bilinear

% 'nearest'  'bilinear' 'bicubic' 'carre'
rotation = 'bilinear';


% angular step for the filter ==> from 0 to 360 degrees


    tic                                     
    f_Derivative_Half_Bi_Gaussian_Kernel_D2_affich_filter(sigma, sigma_s, rho, delta_theta, rotation, ridges)
%     [M1, M2, angleMaxHG, angleMinHG] = f_Derivative_Half_Gaussian_Kernel_D2_plot(I0, sigma, rho, delta_theta, rotation, ridges);
    toc

