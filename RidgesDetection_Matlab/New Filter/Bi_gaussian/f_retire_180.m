function [ theta ] = f_retire_180( theta )

S = size(theta);

for i = 1:S(1)
    for j = 1:S(2)
        if (theta(i, j) > 180)
            theta(i, j) = 360 - theta(i, j) ;
        end
    end
end
