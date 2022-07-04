clear all
close all

CLOSE =0

%Lindeberg step edge

x = -50:1:50; %On regarde la réponse jusqu'à 50 pixels d'écart de notre pixel où on applique le filtre
x3 = x + 52; %On translate pour avoir des valeurs positives

sigma = [0.58 1.81 2.88 3.91 4.93 5.94 6.95 7.95 8.96]
rho = 0.5 % <1 permet de detecter les lignes >1 permet de supprimer le bruit ==> Scale Ratio
sigmaB = rho .* sigma
k = (sigmaB.^2)./sigma % ???

nbRidge = length(sigma);
L = 20 
s = zeros(1, L);

if CLOSE
    % close ridges
    %s = zeros(1, 20);

    for i = 1:1:nbRidge     % build signal
        R = 2*i-1;
        RR = [];
        for j = 1:1:nbRidge
            RR = [RR zeros(1,2*i-1) ones(1,R)];
        end
        s = [s RR zeros(1, L)];
    end

else
    for i = 1:1:nbRidge     % build signal
        R = 2*i-1;
        s = [s ones(1,R) zeros(1, L+i)];
    end

end
s = [s zeros(1, 20)];
figure(7), bar(s)




s2 = s;


for i = 1:1:nbRidge     % filtering

    resultat = [];

    G = exp(-x.^2 / (2*((sigma(i))^2))); %Gaussienne avec sigma
    G2 = conv(G, [1 -2 1], 'same'); %G seconde avec sigma

    %figure(5);
    %plot(x, G2);

    GB = exp(-x.^2 / (2*((sigmaB(i))^2))); %Gaussienne avec sigmaB
    G2B = conv(GB, [1 -2 1], 'same'); %G seconde avec sigmaB

    for j = x3

        if (j<= -sigma(i))
            if (floor(j-sigmaB(i)+sigma(i)) < 1) || (floor(j-sigmaB(i)+sigma(i)) == 0)
                resultat = [resultat (G2B(1))];
            else
                resultat = [resultat k(i)*G2B(floor(j-sigmaB(i)+sigma(i)))];
            end

        elseif (abs(j) < sigma(i))
            if (floor(j-sigmaB(i)+sigma(i)) == 0)
                resultat = [resultat 0]; 
            else
                resultat = [resultat (G2(j))];
            end

        else (j > sigma(i))
            if (floor(j+sigmaB(i)-sigma(i)) > 101) || (floor(j-sigmaB(i)+sigma(i)) == 0)
                resultat = [resultat (G2B(101))] % ATTENTIOOOOOOOOOOOOOOOOOOOOOOON 0?
            else
                resultat = [resultat (k(i)*G2B(floor(j+sigmaB(i)-sigma(i))))];
            end

        end
    end

    % filter normalization
    %Remplacer G2 par résultat si bonne dimension ?
    %909 car 9x101 (9 figures)
    PosF = ((resultat>0).*resultat);
    NegF = ((resultat<0).*resultat);
    MM = sum(sum( PosF ));
    mm = -sum(sum( NegF ));
    PosF = PosF / MM;
    NegF = NegF / mm;
    L  = PosF + NegF ;

    figure(31);
    plot(x,L);

    %figure(4);
    %plot(x,resultat);



    % convolution
    %     s2(i, :) = conv(s, G2, 'same') %Convolution signal et Gaussienne ordre 2 sans normalization


    %     Des fonctions de normalisation moins efficaces que la dernière
    %     s2(i, :) = conv(s, sigma(i)^(1/sigma(i))*G2, 'same')
    %     s2(i, :) = conv(s, (2 - sigma(i)^(1/3)/(1 + sigma(i)^(1/3)))*G2, 'same')
    %     s2(i, :) = conv(s, (exp(1 / (1 + sigma(i))))*G2, 'same')
    %     s2(i, :) = conv(s, (1 - 1/(sigma(i)^(1/(1+sigma(i)))))*G2, 'same')
    %     s2(i, :) = conv(s, (1 + -sigma(i) + max(sigma))*G2, 'same')

    s2(i, :) = (conv(s, ((sigma(i))^(1/sigma(i)) + 1/(sqrt(sigma(i))))*L, 'same')) %Convolution avec normalization
    % Tester des fonctions aléatoirements et récupérer la meilleure
    % Composition des fonctions ci-dessus ?

    figure(2)
    s2 = (s2>0).*s2;    % only positive values
    subplot(nbRidge,1, i),
    %     subplot(nbRidge,2, 2*i-1),
    %     plot (x, G2, 'linewidth', 2), hold on
    stem (x, L, '.', 'linewidth', 2)
    title(['G^{(2)}_\sigma, \sigma = ',num2str(sigma(i)),', ideal for ridges of width ',num2str(i*2 -1)], 'FontSize', 11, 'FontName', 'times')
    %     xlim([-3*(round(sigma(i))) 3*(round(sigma(i)))])
    xlim([-27 27])
    xticks([])

    figure(3)
    subplot(nbRidge,1, i), hold on, zoom;
    %     subplot(nbRidge,2, 2*i), hold on,
    bar (s), plot(s2(i,:), 'linewidth', 3), %title(['convolution with G^{(2)}_\sigma, \sigma = ',num2str(sigma(i))], 'FontSize', 11, 'FontName', 'times')
    %     ylim([0 1.6])
    xlim([15 length(s)-45])
    [s2_max(i), index(i)] = max(s2(i,:));
    plot( index(i), s2_max(i), 'ko', 'linewidth', 3 )
    xticks([])
end

