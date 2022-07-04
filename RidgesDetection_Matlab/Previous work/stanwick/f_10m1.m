function [ Ixx, Iyy, Ixy  ] = f_10m1( I)



% masques derivee premiere et seconde
dx = [1 0 -1]; 
 
Ixx = double(imfilter(imfilter(I,dx),dx));
Iyy = double(imfilter(imfilter(I,dx'),dx'));
%     I2 = double(imfilter(I, Gxx, 'replicate', 'conv'));

    
%                 figure
%          imagesc(Ixx),colormap(gray)
%           title('derivee seconde en x')
%           
%           figure
%                    imagesc(Iyy),colormap(gray)
%           title('derivee seconde en y')
          
%           Iyyi = f_inverse(Iyy);
%                           figure
%          imagesc(Iyyi),colormap(gray)
%           title('derivee seconde inverse  en y')
          
          
          
%           % derivees premieres

Ixy = double(imfilter(imfilter(I,dx),dx','replicate', 'same'));

%       figure, imagesc(Iyy),colormap(gray)
%           title('derivee seconde en y')

   
%       figure, hold on
%    bar(X,Gx ),  
%    plot(X,Gx,'r','LineWidth',3), xlim([-10,10]),ylim([-0.15,0.15]),legend(['\sigma =',num2str(sigma) ]);
 

end

