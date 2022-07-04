
I = f_marges_miroir( 255 - I0, tf ); % filtre taille 3
I = f_normalisation(I);

[dimy , dimx]= size(I); % nb lignes, nb colonnes


angle_in_deg = 2; %22.5;
aniso = 3;   % rho = aniso*sigma
delta_theta = angle_in_deg*pi/180; % degres to radian

[ MaxI  MaxI_angle, steer_Image_out, filter_gx, max_grad_aniso] = f_gauss_aniso_d2( angle_in_deg,  I, sigma, aniso, tf, th );

n = length(steer_Image_out);

figure, imagesc(max_grad_aniso), colormap(gray)

max_grad_aniso_n = f_normalisation_3D(max_grad_aniso);

max_grad_aniso_s = max_grad_aniso_n > th;


Ic = f_contours_verts_sur_image(f_crop(I, tf),max_grad_aniso_s);
figure, imshow(Ic), title('detected ridges')

im = max_grad_aniso_n *255;


% break % affichage filtres
% 
figure,
for i = 1:n
    En(:,:,i) = zeros(size(steer_Image_out{1}));
    En(:,:,i) = (steer_Image_out{i});
    subplot(2,n,i), imagesc(filter_gx{i}), colormap(gray)
    subplot(2,n,i+n), imagesc(En(:,:,i)), colormap(gray)

 
    
end

%%%%%%%%%%
% pc = 0.2
m = sum(sum(max_grad_aniso_n > 0))

n = m;
TH = 0
while n > m*pc
    n = sum(sum(max_grad_aniso_n > TH))
    TH = TH + 0.02
end

th = TH


max_grad_s = (max_grad_aniso_n > th);
Ic = f_contours_verts_sur_image(I0,max_grad_s);
figure, imshow(uint8(Ic)), title('cretes en vert')

 imwrite(max_grad_s, ['result/aniso_sigma_',num2str(sigma),'_pc_',num2str(pc),'.png'])