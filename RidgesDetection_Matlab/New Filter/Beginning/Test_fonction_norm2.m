clear all
close all

CLOSE = 0

syms x; %x est une variable

assume(x, 'real'); %on dit que x est un réel

abscisse = -20:1:20; %Plage de la gaussienne

rho = 0.75; %Scale ratio
sigma = [0.58 1.81 2.88 3.91 4.93 5.94 6.95 7.95 8.96]; %Paramètre de la gaussienne centrale
sigma_b = sigma .* rho; %Paramètres des 2 gaussiennes de part et d'autre de la centrale
k = rho^2;

nbRidge = length(sigma);
L = 20;
s = zeros(1, L);

if CLOSE
    % close ridges
    s = zeros(1, 20);

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
figure, bar(s)
s2 = s;

for i = 1:1:nbRidge     %Filtrage gaussien

    %Gaussienne d'écart-type sigma
    G(x) = (exp(-x^2/(2*(sigma(i))^2)));
    G2(x) = diff(diff(G)); %Calcul analytique de la dérivée 2nde de la gausienne sigma

    %Gaussienne d'écart-type sigma_b
    H(x) = (exp(-x^2/(2*(sigma_b(i))^2)));
    H2(x) = diff(diff(H)); %Calcul analytique de la dérivée 2nde de la gausienne sigma_b

    %Constante pour le lissage
    c0 = (exp(-1/2)/sqrt(2*pi))*((sigma_b(i)/sigma(i))-1)*(1/sigma(i));

    %Milieu : deuxieme methode pour la fonction par morceaux
    %Indic_milieu = heaviside(x+3*sigma(i))-heaviside(x-3*sigma(i)); %Heaviside permet de sélectionner une plage où ça marche, 
    % ici : -3 sigma à 3 sigma sinon la fonction vaut 0

    %gauche :  deuxieme methode pour la fonction par morceaux
    %Indic_gauche = heaviside(x+3*(sigma(i)+sigma_b(i)))-heaviside(x+3*sigma(i));

    %droite : deuxieme methode pour la fonction par morceaux
    %Indic_droite = heaviside(x-3*sigma(i)) - heaviside(x-3*(sigma(i)+sigma_b(i)));


    %fonction de composition pour H2
    gauche(x) = x - sigma_b(i) + sigma(i);
    droite(x) = x + sigma_b(i) - sigma(i);

    % f_gauche = compose(k*H2,gauche)*Indic_gauche;  pas terrible
    f_gauche(x) = piecewise(x<=sigma(i), compose(k*H,gauche),0); %On indique piecewise(plage,compose(fonction,variable), autre valeur)
    % L'autre valeur s'applique si ce n'est pas inférieur à sigma

    %f_milieu = G2*Indic_milieu; pas terrible
    f_milieu(x) = piecewise(abs(x)<sigma(i),G + c0,0);
    
    f_droite(x) = piecewise(x>=sigma(i), compose(k*H,droite),0);
    
    %Fonction finale qui implémente les 3 précédentes
    BG(x) = piecewise(x<=-sigma(i), f_gauche, abs(x)<sigma(i), f_milieu, x>=sigma(i), f_droite,0); 
    %f_res(x) = cumsum([f_droite f_milieu f_gauche]) %Autre méthode pour afficher la courbe finale
    BG2(x) = -diff(diff(BG)); %-1 permet de passer de la détection de vallées à la détection de crêtes

   
    figure(15);
    subplot(2,1,1),fplot(BG);
    subplot(2,1,2),fplot(BG2)



    BG_value = double(feval(BG,abscisse)); %On évalue la fonction créée ci-dessus sur la plage d'abscisses arbitraire 
    % définie en début de code, et Gaussienne simple
    BG2_value = double(feval(BG2,abscisse)); %Gaussienne seconde


    %Problème car mm = 0 : il n'y a aucune valeur négative et on divise donc par 0...
%     PosF = ((lissage>0).*lissage);
%     NegF = ((lissage<0).*lissage);
%     MM = sum(sum( PosF ));
%     mm = -sum(sum( NegF ));
%     PosF_norm = PosF / MM;
%     NegF_norm = NegF / mm;
%     L  = PosF_norm + NegF_norm ;

    % filter normalization : PB ici
    PosF2 = ((BG2_value>0).*BG2_value);
    NegF2 = ((BG2_value<0).*BG2_value);
    MM2 = sum(sum( PosF2 ));
    mm2 = -sum(sum( NegF2 ));
    PosF2_norm = PosF2 / MM2;
    NegF2_norm = NegF2 / mm2;
    L2  = PosF2_norm + NegF2_norm ;

    figure(30);
    subplot(4,1,1); plot(abscisse,BG_value);
    subplot(4,1,2); plot(abscisse,BG2_value);
    subplot(4,1,3); plot(abscisse,L);
    subplot(4,1,4); plot(abscisse,L2);

    % convolution
    %     s2(i, :) = conv(s, G2, 'same')
    %     s2(i, :) = conv(s, sigma(i)^(1/sigma(i))*G2, 'same')
    %     s2(i, :) = conv(s, (2 - sigma(i)^(1/3)/(1 + sigma(i)^(1/3)))*G2, 'same')
    %     s2(i, :) = conv(s, (exp(1 / (1 + sigma(i))))*G2, 'same')
    %     s2(i, :) = conv(s, (1 - 1/(sigma(i)^(1/(1+sigma(i)))))*G2, 'same')
    %    s2(i, :) = conv(s, (1 + -sigma(i) + max(sigma))*G2, 'same')
    s2(i, :) = (conv(s, ((sigma(i))^(1/sigma(i)) + 1/(sqrt(sigma(i))))*L2, 'same'));

    figure(1);
    s2 = (s2>0).*s2;    % only positive values
    subplot(nbRidge,1, i);
    %     subplot(nbRidge,2, 2*i-1),
    %     plot (x, L, 'linewidth', 2), hold on
    stem (abscisse, BG2_value , '.', 'linewidth', 2);
    title(['G^{(2)}_\sigma, \sigma = ',num2str(sigma(i)),', ideal for ridges of width ',num2str(i*2 -1)], 'FontSize', 11, 'FontName', 'times')
    %     xlim([-3*(round(sigma(i))) 3*(round(sigma(i)))])
    xlim([-27 27])
    xticks([])

    figure(2)
    subplot(nbRidge,1, i), hold on,
    %     subplot(nbRidge,2, 2*i), hold on,
    bar (s), plot(s2(i,:), 'linewidth', 3), %title(['convolution with G^{(2)}_\sigma, \sigma = ',num2str(sigma(i))], 'FontSize', 11, 'FontName', 'times')
    %     ylim([0 1.6])
    xlim([15 length(s)-45])
    [s2_max(i), index(i)] = max(s2(i,:));
    plot( index(i), s2_max(i), 'ko', 'linewidth', 3 )
    xticks([])

    

end

