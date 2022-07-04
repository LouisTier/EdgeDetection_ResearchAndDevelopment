clear all
close all

width = 3

if width == 3
    sigma = 1.81
    sz = 0.63
    sr = 0.69    
elseif width == 5
    sigma = 2.88
    sz = 0.37
    sr = 0.42
end


th = 0.2

pc = 0.5

tf = 33;

% I0=double(imread('Stanwick-small.png'));
% I0=double(imread('doigt_crop.png')); I0 = 255 - I0 ;
I0 = double(imread( 'IoD-001_VV_div8.png'));  I0 = I0(:,:,3);


main_laplacian
main_test_10m1
main_auclair
main_test_gouton
main_comparison_eigen_values
main_weingarten
M = 4
main_steer8JU
M = 2
main_steer8JU
main_aniso_d2