clear all
close all

% s = [zeros(1,51) ones(1,9), zeros(1,4), ones(1,7),zeros(1,6), ones(1,3),zeros(1,4),ones(1,3),zeros(1,6),ones(1,7),zeros(1,4), ones(1,9),  zeros(1,51)];
s = [zeros(1,51) ones(1,9), zeros(1,4), ones(1,7),zeros(1,6), ones(1,3),zeros(1,4),ones(1,3)  zeros(1,81)];

figure, bar(s)

for i = 1:length(s)
    J(i,:) = s;
end

Gt = bwmorph(J,'skel',Inf);

Gt(1:20,:)=0;
Gt(end-20:end, :)=0;
J(1:20,:)=0;
J(end-20:end, :)=0;

D = J-Gt;

figure, imshow(J)
figure, imshow(Gt)
figure, imshow(D)

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