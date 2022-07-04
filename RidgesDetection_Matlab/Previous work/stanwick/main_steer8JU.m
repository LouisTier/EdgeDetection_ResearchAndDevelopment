

I = f_marges_miroir( I0, tf );  

        [Gradient, theta, MaxGrad, filterBank] = steerableDetector(I, M, sigma);

%         figure, imagesc(MaxGrad), colormap(gray)
        % figure, imagesc(filterBank(:,:,1)), colormap(gray)
        [ MaxGrad_crop ] = f_crop( MaxGrad, tf );
        MaxGrad_crop = (MaxGrad_crop > 0) .* MaxGrad_crop;
        max_grad_n = f_normalisation(MaxGrad_crop);
        % TI = hysthresh(MaxGrad_n,0.1,0.4);

        % imwrite(f_normalisation(MaxGrad_n),'resultats\police_steer_sigma_1.png');

 
% [ MaxGrad_crop ] = f_crop( MaxGrad_s, taille_masque );

% [Ic] = f_contours_verts_sur_image(I0,MaxGrad_s);
% figure, imshow(Ic)
%   title('contours sur image')

  

%%%%%%%%%%
% pc = 0.2
m = sum(sum(max_grad_n > 0))

n = m;
TH = 0
while n > m*pc
    n = sum(sum(max_grad_n > TH))
    TH = TH + 0.001
end

th = TH

% max_grad_s = (max_grad_n > th);
max_grad_s = (max_grad_n > th);


% theta_s = (theta < s_theta);
figure, imagesc(max_grad_s), colormap(gray), title('max grad seuille')

% imwrite(max_grad_s,'max_crete_gaussienne_d2.png');


% Ic = f_contours_verts_sur_image(255 - I0,max_grad_s);
Ic = f_contours_verts_sur_image(I0,max_grad_s);
figure, imshow(uint8(Ic)), title('cretes en vert')
 
if M ==2
    imwrite(max_grad_s, ['result/SF2_sigma_',num2str(sigma),'_pc_',num2str(pc),'.png'])
else
    imwrite(max_grad_s, ['result/SF4_sigma_',num2str(sigma),'_pc_',num2str(pc),'.png'])
end