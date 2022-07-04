function [ lambdap, lambdam, theta ] = f_valeurs_propres_et_direction_vecteur_propre( A, B, C, D )

% matrix 
%(A B)
%(C D)

[dimy , dimx]= size(A);

lambdap = zeros(size(A));
lambdam = zeros(size(A));


% Delta

sD = sqrt(((A - D).^2 + 4 * B.*C));

% eigen values and vectors


lambdap = 1/2 * (A + D + sD);
lambdam = 1/2 * (A + D - sD);
v1p = B;
v2p = -A + lambdap; 

% eigen values and vectors computation, special cases
% % % 
for i = 1:dimy
    for j = 1:dimx
        if (( abs(A(i,j)) < 0.001) ) % A = 0
            if (( abs(B(i,j)) < 0.001) && ( abs(C(i,j)) < 0.001) && ( abs(D(i,j)) < 0.001)) % ( 0 0 // 0 0)
                lambdap(i,j) = 0;
                lambdam(i,j) = 0;
                v1p(i,j) = 1;
                v2p(i,j) = 0.0001;                
        
            elseif ( (( abs(B(i,j)) < 0.001) || ( abs(C(i,j)) < 0.001)) && ( abs(D(i,j)) > 0.001) ) % ( 0 0 // 0 D)
                lambdap(i,j) = D(i,j);
                lambdam(i,j) = 0;
                v1p(i,j) = 0.0001;
                v2p(i,j) = 1;
            
            elseif ( abs(D(i,j)) < 0.001) % (0 B // C 0)
                
                if (D(i,j) > 0.001)
                a = A(i,j);
                b = B(i,j);                
                c = C(i,j);
                d = D(i,j);
                a
                d
                end

                if ((B(i,j)* C(i,j) > 0.00001)) % ( BC >0)
                    lambdap(i,j) = sqrt(B(i,j)* C(i,j));
                    lambdam(i,j) = -sqrt(B(i,j)* C(i,j));
                    v1p(i,j) = 1;
                    v2p(i,j) = sqrt(C(i,j) / B(i,j)); 
                elseif ((B(i,j)* C(i,j) < -0.00001)) % ( BC <0)
                    lambdap(i,j) = sqrt(abs(B(i,j)* C(i,j)));
                    lambdam(i,j) = -sqrt(abs(B(i,j)* C(i,j)));
                    v1p(i,j) = 1;
                    v2p(i,j) = -sqrt(-C(i,j) / B(i,j)); 
                else % ( BC = 0)
                    lambdap(i,j) = 0;
                    lambdam(i,j) = 0;
                    v1p(i,j) = 1; % peu importe
                    v2p(i,j) = 0.0001;
                end
            end
        else
            if (( abs(B(i,j)) < 0.001) || ( abs(C(i,j)) < 0.001))  % ( A 0 // 0 D) || ( A B // 0 D) ||( A 0 // C D) 
                if (A(i,j) == D(i,j) ) % ( A 0 // 0 A)
                    lambdap(i,j) = A(i,j);
                    lambdam(i,j) = 0;
                    v1p(i,j) = 1;
                    v2p(i,j) = 1;
                elseif ( abs(D(i,j)) < 0.001) % vertical line
                    lambdap(i,j) = A(i,j);
                    lambdam(i,j) = D(i,j);
                    v1p(i,j) = 1;
                    v2p(i,j) = 0.0001;
                elseif ( abs(A(i,j)) < 0.001) % horizontal line
                    lambdap(i,j) = D(i,j);
                    lambdam(i,j) = A(i,j);
                    v1p(i,j) = 0.0001;
                    v2p(i,j) = 1;
                end
            end
        end
    end
end


% 
% for i = 1:dimy
%     for j = 1:dimx
%         if (( abs(B(i,j)) < 0.001) ) % b = 0
%             if (( abs(A(i,j)) < 0.001) && ( abs(D(i,j))< 0.001)) % matrice nulle
%                 v1p(i,j) = 1;
%                 v2p(i,j) = 1;
%             elseif (A(i,j) == D(i,j)) % ( a 0 // 0 a)
%                 v1p(i,j) = 1;
%                 v2p(i,j) = 1;
%             else % (A(i,j) ~= D(i,j)) (a 0 // 0 c)
%                 v1p(i,j) = 1;
%                 v2p(i,j) = 0.0001;                
%             end
%         else
%             if (( abs(A(i,j)) < 0.001) && ( abs(D(i,j)) < 0.001))  % ( 0 b // b 0)
%                 v1p(i,j) = B(i,j);
%                 v2p(i,j) = -B(i,j);
%             end
%             if (( abs(A(i,j)) < 0.001) && (abs(D(i,j)) > 0.001))  % ligne horizontale (0 0 // 0 c)
%                 lambdap(i,j) = D(i,j);
%                 v1p(i,j) = 1;
%                 v2p(i,j) = 0.0001;
%             end
%         end
%     end
% end


theta =(zeros(size(A)));

% 
% for i = 1:dimy
%     for j = 1:dimx
%         if (v1p(i,j) < 0.00001) 
%             a = v1p(i,j) + 0.00001 ;
%             v1p(i,j) = a;
%         end
%     end
% end

theta =  atan(v2p ./ v1p);
% theta =  atan(v1p ./ v2p);

% theta = theta - pi/2 ;
% theta = f_translate_pi( theta ); % si directions <0
