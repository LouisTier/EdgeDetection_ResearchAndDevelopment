function [ I_fin ] = f_marges_noires( I )
% avoid border effect during rotation process

[dimy , dimx]= size(I);

if dimy > dimx
    n = dimy;
else
    n = dimx;
end;

dimy2 = dimy;
dimx2 = dimx;

while (dimy2 < dimy + n + 2)
    I_fin = cat(1,zeros(1,dimx),I,zeros(1,dimx));
    I = I_fin;
    dimy2 = size(I_fin,1);
end

while (dimx2 < dimx + n + 2)
    I_fin = cat(2,zeros(dimy2,1),I,zeros(dimy2,1));
    I = I_fin;
    dimx2 = size(I_fin,2);
end

