

m = 20
x = -m:1:m;
y= -m:1:m;


% sigma = 1.81

LoG = 1/(pi * sigma^4) * (1 - (x.^2 + y'.^2)/(2*sigma^2)) .* exp(- (x.^2 + y'.^2)/(2*sigma^2));

figure, surf(LoG)

sum(sum(LoG))
ylabel('\fontname{times} x')
xlabel('\fontname{times} y')
zlabel(['\fontname{times} \it LoG,    \sigma = ',num2str(sigma)])





I = f_marges_miroir( I0, tf ); 


ILoG = imfilter(I,LoG, 'same');

% figure, imagesc(ILoG), colormap(gray)

Im = ILoG > 0;
ILoG = ILoG .* Im;

S = size(ILoG)

J = zeros(size(ILoG));

for i = 2:S(1)-1
    for j = 2:S(2)-1
        if ( (ILoG(i,j) >= ILoG(i-1, j)) && (ILoG(i,j) >= ILoG(i+1, j)) )
            J(i,j) = ILoG(i,j); end
        if  ( (ILoG(i,j) >= ILoG(i-1, j+1)) && (ILoG(i,j) >= ILoG(i+1, j-1)) )
            J(i,j) = ILoG(i,j); end
        if  ( (ILoG(i,j) >= ILoG(i, j+1)) && (ILoG(i,j) >= ILoG(i, j-1)) )
            J(i,j) = ILoG(i,j); end
        if  ( (ILoG(i,j) >= ILoG(i-1, j-1)) && (ILoG(i,j) >= ILoG(i+1, j+1)) )
            J(i,j) = ILoG(i,j);  end
       
    end
end

J = f_crop(J, tf);

% figure, imagesc(J), colormap(gray)

%%%%%%%%%%
max_grad_n = f_normalisation(J);
% pc = 0.25
m = sum(sum(max_grad_n > 0))
n = m;
% m = 16000
TH = 0
while n > m*pc
    n = sum(sum(max_grad_n > TH))
    TH = TH + 0.001
end

th = TH

max_grad_s = f_normalisation(J) > th;
figure, imagesc(max_grad_s), colormap(gray)

Ic = f_contours_verts_sur_image(I0, max_grad_s);

figure, imshow(uint8(Ic)), title('cretes en vert')

imwrite(max_grad_s, ['result/lap_sigma_',num2str(sigma),'_pc_',num2str(pc),'.png'])

% imwrite(Ic, 'LoG_th_angiora_sigma_5.png')
% imwrite(f_normalisation(f_crop(imfilter(I,LoG, 'same'), tf)), 'LoG_angiora_sigma_5.png')
% imwrite(f_normalisation(f_crop(I, tf)), 'angiogra.png')