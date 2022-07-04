clear
close all

x = -50:1:50;
sigma = [0.58 1.81 2.88 3.91 4.93 5.94 6.95 7.95 8.96];
nbRidge = length(sigma);

L = 20;
s = zeros(1, L);

for i = 1:1:nbRidge     % build signal
    R = 2*i-1;
    s = [s ones(1,R) zeros(1, L+i)];
end

s = [s zeros(1, 20)];
figure, bar(s)

s2 = s;

for i = 1:1:nbRidge     % filtering
    G = exp(-x.^2 / (2*((sigma(i))^2)));
    G2 = conv(G, [-1 2 -1], 'same');

    % filter normalization
    PosF = ((G2>0).*G2);
    NegF = ((G2<0).*G2);
    MM = sum(sum( PosF ));
    mm = -sum(sum( NegF ));
    PosF = PosF / MM;
    NegF = NegF / mm;
    G2  = PosF + NegF ;

    % convolution
    %     s2(i, :) = conv(s, G2, 'same')
    %     s2(i, :) = conv(s, sigma(i)^(1/sigma(i))*G2, 'same')
    %     s2(i, :) = conv(s, (2 - sigma(i)^(1/3)/(1 + sigma(i)^(1/3)))*G2, 'same')
    %     s2(i, :) = conv(s, (exp(1 / (1 + sigma(i))))*G2, 'same')
    %     s2(i, :) = conv(s, (1 - 1/(sigma(i)^(1/(1+sigma(i)))))*G2, 'same')
    %     s2(i, :) = conv(s, (1 + -sigma(i) + max(sigma))*G2, 'same')
    s2(i, :) = (conv(s, ((sigma(i))^(1/sigma(i)) + 1/(sqrt(sigma(i))))*G2, 'same'));

    %----------------------------------------------------------------------
    figure(2)
    s2 = (s2>0).*s2;    % only positive values
    subplot(nbRidge, 1, i),
    %     subplot(nbRidge,2, 2*i-1),
    %     plot (x, G2, 'linewidth', 2), hold on
    stem (x, G2 , '.', 'linewidth', 2)
    title(['G^{(2)}_\sigma, \sigma = ',num2str(sigma(i)),', ideal for ridges of width ',num2str(i*2 -1)], 'FontSize', 11, 'FontName', 'times')

    %----------------------------------------------------------------------
    figure(3)
    subplot(nbRidge, 1, i), hold on,
    %     subplot(nbRidge,2, 2*i), hold on,
    bar (s), plot(s2(i,:), 'linewidth', 3), %title(['convolution with G^{(2)}_\sigma, \sigma = ',num2str(sigma(i))], 'FontSize', 11, 'FontName', 'times')
    [s2_max(i), index(i)] = max(s2(i,:));
    plot( index(i), s2_max(i), 'ko', 'linewidth', 3 )

end

