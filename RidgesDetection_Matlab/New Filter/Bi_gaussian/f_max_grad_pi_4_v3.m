function [max_grad] = f_max_grad_pi_4_v3(mag,theta)
    % theta = gradient angle
    % mag = gradient magnitude
    
    % v3 : add cos sin
    
    C = cos(theta).^2;
    S = sin(theta).^2;
    
    L = size(mag)
    max_grad= zeros(L);
  for i = 2:L(1)-1
      for j = 2:L(2)-1
          
          if mag(i,j)== 13.0759
              cc = c* mag(i+1,j+1)
              ss = s*  mag(i,j+1)
              ad = cc + ss
              
             m = ( s*mag(i,j+1) + c* mag(i-1,j+1)) 
             n = ( c * mag(i+1,j-1)+ s* mag(i,j-1)) 
             bbbb = ( (mag(i,j) > s*mag(i,j+1) + c* mag(i-1,j+1)) && (mag(i,j) > c * mag(i+1,j-1)+ s* mag(i,j-1)) )

              
              
              
          end
          
          
          c = C(i,j);
          s = S(i,j); 
          
          if ( (theta(i,j) >= 0) && (theta(i,j) <= pi/4) )
              if ( (mag(i,j) > s*mag(i-1,j+1) + c* mag(i-1,j)) && (mag(i,j) > c * mag(i+1,j)+ s* mag(i+1,j-1)) )
                    max_grad(i,j) = mag(i,j);
              end
          end
          
          if ( (theta(i,j) > pi/4) && (theta(i,j) <= pi/2) )              
              if ( (mag(i,j) > s*mag(i,j+1) + c* mag(i-1,j+1)) && (mag(i,j) > c * mag(i+1,j-1)+ s* mag(i,j-1)) )                
                    max_grad(i,j) = mag(i,j);
              end
          end
          
          if ( (theta(i,j) > pi/2) && (theta(i,j) <= 3*pi/4) )              
              if ( (mag(i,j) > s*mag(i,j+1) + c* mag(i+1,j+1)) && (mag(i,j) > c * mag(i-1,j-1)+ s* mag(i,j-1)) )                
                    max_grad(i,j) = mag(i,j);
              end
          end
          
          if ( (theta(i,j) > 3*pi/4) && (theta(i,j) <= pi) )              
              if ( (mag(i,j) > c*mag(i+1,j) + s* mag(i+1,j+1)) && (mag(i,j) > s * mag(i-1,j-1)+ c* mag(i-1,j)) )                
                    max_grad(i,j) = mag(i,j);
              end
          end
          
%           if ( (theta(i,j) > pi/4) && (theta(i,j) < 3*pi/4) )
%               
%               if ( (mag(i,j) > s*mag(i,j+1) + c* mag(i-1,j+1)) && (mag(i,j) > c * mag(i+1,j-1)+ s* mag(i,j-1)) )
%                     max_grad(i,j) = mag(i,j);
%               end
%           else          
%               if ( (mag(i,j) > c*mag(i+1,j) +s* mag(i+1,j+1)) && (mag(i,j) > s*mag(i-1,j-1) + c* mag(i-1,j)) )
%                    
%                     max_grad(i,j) = mag(i,j);
%               end
%          end
         
          
      end
  end
  
  
 
  
%    figure
%  imagesc(max_grad),colormap(gray)
%   title('maximum du gradient dans la direstion \pi/4 \theta')
  
   
   
   
%   SE = [1 1 1 ; 1 1 1 ; 1 1 1];
%   dil = imdilate(max_grad,SE);
%   
%      figure
%  imagesc(dil),colormap(gray)
%   title('maximum du gradient dans la direstion \theta dilate')
  
  end
  