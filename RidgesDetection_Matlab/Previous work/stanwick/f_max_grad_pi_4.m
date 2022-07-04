function [max_grad] = f_max_grad_pi_4(mag,theta)
    % theta = gradient angle
    % mag = gradient magnitude
    
    L = size(mag);
    max_grad= zeros(L);
  for i = 2:L(1)-1
      for j = 2:L(2)-1
          
          if theta(i,j) == 0
              if ((mag(i,j) > mag(i-1,j)) && (mag(i,j) > mag(i+1,j)))
                max_grad(i,j) = mag(i,j);
              end
          end
                  
          if (theta(i,j) >0 && theta(i,j) < pi/4)
            if  (mag(i,j) > mag(i+1,j)) 
                if(mag(i,j) > mag(i+1,j-1))
             if (mag(i,j) > mag(i-1,j)) 
                 if(mag(i,j) > mag(i-1,j+1))

                             max_grad(i,j) = mag(i,j);
                         end
                     end
                  end
              end
          end
          
          if theta(i,j) == pi/4
              if ( (mag(i,j) > mag(i-1,j+1))) && ((mag(i,j) > mag(i+1,j-1)) )
                max_grad(i,j) = mag(i,j);
              end
          end
          
          if ( (theta(i,j) > pi/4) && (theta(i,j) < pi/2) )
              if ( (mag(i,j) > mag(i,j+1)) && (mag(i,j) > mag(i-1,j+1)) && (mag(i,j) > mag(i+1,j-1)) && (mag(i,j) > mag(i,j-1)) )
                    max_grad(i,j) = mag(i,j);
              end
          end          
          
          if theta(i,j) == pi/2
              if (mag(i,j) > mag(i,j+1)) && (mag(i,j) > mag(i,j-1))
                max_grad(i,j) = mag(i,j);
              end
          end
                              
         if ( (theta(i,j) > pi/2) && (theta(i,j) < 3*pi/4) )
              if (mag(i,j) > mag(i,j+1) && mag(i,j) > mag(i+1,j+1) && mag(i,j) > mag(i-1,j-1) && mag(i,j) > mag(i,j-1) )
                    max_grad(i,j) = mag(i,j);
              end
         end
         
         if theta(i,j) == 3*pi/4
              if ( (mag(i,j) > mag(i+1,j+1)) && (mag(i,j) > mag(i-1,j-1)) )
                max_grad(i,j) = mag(i,j);
              end
         end
          
         if ( (theta(i,j) > 3*pi/4) && (theta(i,j) < pi) )
              if ( (mag(i,j) > mag(i+1,j)) && (mag(i,j) > mag(i+1,j+1)) && (mag(i,j) > mag(i-1,j-1)) && (mag(i,j) > mag(i-1,j)) )
                    max_grad(i,j) = mag(i,j);
              end
         end
         
         if theta(i,j) == pi
              if (mag(i,j) > mag(i-1,j)) && (mag(i,j) > mag(i+1,j))
                max_grad(i,j) = mag(i,j);
              end
         end
          
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
  