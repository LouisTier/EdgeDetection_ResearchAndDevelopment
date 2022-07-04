function [ theta ] = f_translate_pi( theta )

% si -pi/2 < theta < pi/2 on rajoute pi pour theta < 0

L = size(theta);

for i = 1:L(1)
    for j = 1:L(2)
        while (theta(i,j) < 0)
            theta(i,j) = theta(i,j) + pi;
        end           
    end
end