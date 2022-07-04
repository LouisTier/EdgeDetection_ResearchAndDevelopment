clear all
close all

L = 128
I = zeros(L, L);
Gt = I;
J = I;

d = 20; % left margin
s = 4
I = zeros(L, L);

for i = 2:6
    I(:, d + i) = 1;
    Gt = Gt + I;
    se = strel('square',i);
    se
    I = imdilate(I, se) ;
    J = J + I;
    
    
    d = d + s + i;
    
    figure, imshow(I)
    I = zeros(L, L);
end




figure, imshow(I)
figure, imshow(Gt)
figure, imshow(J)

S = size(J);

for i = 1:S(1)
    for j = 1:S(1)
        if (i>j)
            J(j,i) = J(i,j) ;
            Gt(j,i) = Gt(i,j) ;
        end
    end
end

% J = imrotate(J, 20, 'nearest', 'crop');
% Gt = imrotate(Gt, 20, 'nearest', 'crop');

figure, imshow(J)
figure, imshow(Gt)

imwrite(J, 'synth_bended.png')
imwrite(Gt, 'Gt_bended.png')

% figure, plot(J(end, :))
