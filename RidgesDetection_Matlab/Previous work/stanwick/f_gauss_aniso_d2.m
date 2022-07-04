function [ MaxI  MaxI_angle, steer_Image_out, filter_gx, max_grad] = f_gauss_aniso_d2( angle_in_deg,  I0, sigma, aniso, taille_masque, th )
% v1 normalisation des filtres en fontion des coefficients max et min quand
% theta = 0

delta_theta = angle_in_deg*pi/180; % degres to radian 
 
% filter size
    if (3*sigma*aniso) < 21
        L = 10;
        M = 10;
        x = -L:1:L;
        y = -M:1:M;
    else
        L = floor(3*sigma*aniso)
        M = floor(3*sigma*aniso)
        x = -L:1:L;
        y = -M:1:M;
    end
    
    
    angle =0;
    rho = aniso*sigma;   % filter length
    iter = 1;
    
    
%     for theta = 0:delta_theta:pi/4 %pi-delta_theta
for theta = 0:delta_theta:pi-delta_theta
        S = length(0:delta_theta:pi/4);

        
        angle = angle +1;
        
     if theta <= pi/4
        for i = 1:length(x)
            for j = 1:length(y)

                G(i,j) = 1/(2*pi*sigma*rho)* exp(-1/2* ( ((x(i)*cos(theta)+ y(j)*sin(theta))^2 )/sigma^2 + ((-x(i)*sin(theta)+ y(j)*cos(theta))^2 )/rho^2 ));
                dfx(i,j)= -1/2* ( ( 2*x(i)*cos(theta)*cos(theta) + 2*y(j)*cos(theta)*sin(theta))/sigma^2 + ( 2*x(i)*sin(theta)*sin(theta) + 2*y(j)*cos(theta)*sin(theta))/rho^2 );
                
                d2fx(i,j)= -1/2* ( ( 2*cos(theta)*cos(theta) )/sigma^2 + ( 2*sin(theta)*sin(theta) )/rho^2 );
                d2Gx(i,j)= d2fx(i,j)*G(i,j) + dfx(i,j)*dfx(i,j)*G(i,j);  
                                              
            end
        end      
                        
     elseif theta <= 3*pi/4
         thetam = (  pi/2 - theta);
             
         for i = 1:length(x)
            for j = 1:length(y)

                G(i,j) = 1/(2*pi*sigma*rho)* exp(-1/2* ( ((x(i)*cos(thetam)+ y(j)*sin(thetam))^2 )/sigma^2 + ((-x(i)*sin(thetam)+ y(j)*cos(thetam))^2 )/rho^2 ));
                dfx(i,j)= -1/2* ( ( 2*x(i)*cos(thetam)*cos(thetam) + 2*y(j)*cos(thetam)*sin(thetam))/sigma^2 + ( 2*x(i)*sin(thetam)*sin(thetam) + 2*y(j)*cos(thetam)*sin(thetam))/rho^2 );
                
                d2fx(i,j)= -1/2* ( ( 2*cos(thetam)*cos(thetam) )/sigma^2 + ( 2*sin(thetam)*sin(thetam) )/rho^2 );
                d2Gx(i,j)= d2fx(i,j)*G(i,j) + dfx(i,j)*dfx(i,j)*G(i,j);

            end
         end
            
         d2Gx =  fliplr( rot90(d2Gx , -1));
         % figure,imagesc(d2Gx), colormap(gray)
         
     else
         
        for i = 1:length(x)
            for j = 1:length(y)

                G(i,j) = 1/(2*pi*sigma*rho)* exp(-1/2* ( ((x(i)*cos(theta)+ y(j)*sin(theta))^2 )/sigma^2 + ((-x(i)*sin(theta)+ y(j)*cos(theta))^2 )/rho^2 ));
                dfx(i,j)= -1/2* ( ( 2*x(i)*cos(theta)*cos(theta) + 2*y(j)*cos(theta)*sin(theta))/sigma^2 + ( 2*x(i)*sin(theta)*sin(theta) + 2*y(j)*cos(theta)*sin(theta))/rho^2 );
                dGx(i,j)= dfx(i,j)*G(i,j);  % filtre oriente D1 ==> a tester

                d2fx(i,j)= -1/2* ( ( 2*cos(theta)*cos(theta) )/sigma^2 + ( 2*sin(theta)*sin(theta) )/rho^2 );
                d2Gx(i,j)= d2fx(i,j)*G(i,j) + dfx(i,j)*dfx(i,j)*G(i,j);  
%                 dGx(i,j)= d2fx(i,j)*G(i,j) + dfx(i,j)*dfx(i,j)*G(i,j); 
            end
        end
                         
     end
     
%              dGx = d2Gx;
%         figure,imagesc(dGx), colormap(gray)


 
        % normalisation
%         d2Gx = d2Gx/max(max(abs(d2Gx)));

        if (theta == 0)   % coeff de normalisation  calculee pour theta = 0 et insere pour toutes les orientations
             maxF = max(max(d2Gx));
             minF = min(min(d2Gx));
             sum(sum(d2Gx))
        end

        % on recupere les valeurs positives d'un cote et negative de
        % l'autre puis on multiplie avec les coefficients precedemment
        % calcules
        
        d2Gxpos = d2Gx .* (d2Gx>0);
        d2Gxneg = d2Gx .* (d2Gx<=0);
        d2Gxpos = d2Gxpos/max(max(d2Gxpos))*maxF;
        d2Gxneg = d2Gxneg/min(min(d2Gxneg))*minF;
        d2Gx = d2Gxpos + d2Gxneg; % noyan normalise
        
        
        % Calculate image gradients (using separability).
        [steer_Image_out{angle}] = conv2(double(I0), d2Gx,'same'); 
        [ steer_Image_out{angle} ] = f_crop( steer_Image_out{angle}, taille_masque );
        filter_gx{angle} = d2Gx;
 
%         mmi(iter) = min(min(steer_Image_out{angle}));
%         MMi(iter) = max(max(steer_Image_out{angle}));
%         mm(iter) = min(min(d2Gx));
%         MM(iter) = max(max(d2Gx));
%         iter = iter +1;

end

    
     clear angle
    

%      figure, plot(MM), title('Max filter')
%      figure, plot(mm), title('Min filter')

    % calcul gradient et angle
    [MaxI  MaxI_angle ]= steer_max(steer_Image_out);


    figure, 
    subplot(1,2,1),imagesc(MaxI), colormap(gray) , title(['gradient with \it \sigma = ',num2str(sigma),' \it \rho = ',num2str(rho)])
    subplot(1,2,2),imagesc(MaxI_angle), colormap(gray) , title(['gradient angle with \it \sigma = ',num2str(sigma),' \it \rho = ',num2str(rho)])


    % convert to radians
    MaxI_angle = (((MaxI_angle - 1).* delta_theta));   % delta_theta deja en radian

    MaxI_angle = - MaxI_angle;  % sens inverse de l'angle

    [ MaxI_angle ] = f_translate_pi( MaxI_angle );  % ramener les angles positifs


    [max_grad] = f_max_grad_pi_4(MaxI, MaxI_angle);
    figure, imagesc(max_grad), colormap(gray) , title('NMS')
    
    max_grad_s = (f_normalisation(max_grad) > th);
    Ic = f_contours_verts_sur_image(f_crop( I0, taille_masque ),max_grad_s);
    figure, imshow(Ic), title('cretes en vert filtre aniso')

%     imageIc = sprintf(['resultats/%s_steer_Perona_sigma_',num2str(sigma),'_rho_',num2str(rho),'.png'],A);  % Gradient Perona
%     imwrite(f_normalisation(max_grad),[imageIc]);
% imwrite(f_normalisation(max_grad),'resultats/218_perona_sigma_1_rho_3.png');

 





end

