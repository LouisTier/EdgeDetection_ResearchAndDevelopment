clear all
close all

syms x;

assume(x, 'real');

dx = [-1 0 1];
dxx = [1 -2 1];

for nb_pixels = 1:2:7 %%%%% attention, on teste avec des crêtes de largeur impaire

    th = 10^(-5)    % pour les limites de la gaussienne

    % bornes pour le culcul du remplissage

    % x=-100:1:120;
    abscisse=-150:1:150;
    minx = min(abscisse);
    maxx=max(abscisse);

    % gaussienne

    sigma = 5;
    rho = 1;
    sigma_b = sigma .* rho;
    k = rho^2;
    n = 0;
    SG = 1;
    S = 1000;
    X = minx:1:maxx;
    while (S > nb_pixels && n < 1);
        n = n + 1;

        sigma = sigma - 0.01;
        rho = 0.75;
        sigma_b = sigma * rho;

        %Gaussienne d'écart-type sigma
        G = (exp(-1*x^2/(2*(sigma)^2)));
        G2(x) = diff(diff(G)); %Calcul analytique de la dérivée 2nde de la gausienne sigma

        %Gaussienne d'écart-type sigma_b
        H = (exp(-1*x^2/(2*(sigma_b)^2)));
        H2(x) = diff(diff(H)); %Calcul analytique de la dérivée 2nde de la gausienne sigma_b

        %Constante pour le lissage
        c0 = (exp(-1/2)/sqrt(2*pi))*((sigma_b/sigma)-1)*(1/sigma);

        %Milieu : deuxieme methode pour la fonction par morceaux
        %Indic_milieu = heaviside(x+3*sigma(i))-heaviside(x-3*sigma(i)); %Heaviside permet de sélectionner une plage où ça marche,
        % ici : -3 sigma à 3 sigma sinon la fonction vaut 0

        %gauche :  deuxieme methode pour la fonction par morceaux
        %Indic_gauche = heaviside(x+3*(sigma(i)+sigma_b(i)))-heaviside(x+3*sigma(i));

        %droite : deuxieme methode pour la fonction par morceaux
        %Indic_droite = heaviside(x-3*sigma(i)) - heaviside(x-3*(sigma(i)+sigma_b(i)));


        %fonction de composition pour H2
        gauche(x) = x - sigma_b + sigma;
        droite(x) = x + sigma_b - sigma;

        % f_gauche = compose(k*H2,gauche)*Indic_gauche;  pas terrible
        f_gauche(x) = piecewise(x<=sigma, compose(k*H,gauche),0); %On indique piecewise(plage,compose(fonction,variable), autre valeur)
        % L'autre valeur s'applique si ce n'est pas inférieur à sigma

        
        %f_milieu = G2*Indic_milieu; pas terrible
        f_milieu(x) = piecewise(abs(x)<sigma,G+c0,0);
        figure(12)
        fplot(f_milieu);
        f_droite(x) = piecewise(x>=sigma, compose(k*H,droite),0);
        figure(14)
        fplot(f_droite);
        %Fonction finale qui implémente les 3 précédentes
        BG(x) = piecewise(x<=-sigma, f_gauche, abs(x)<sigma, f_milieu, x>=sigma, f_droite,0);
        %f_res(x) = cumsum([f_droite f_milieu f_gauche]) %Autre méthode pour afficher la courbe finale
        BG2(x) = -diff(diff(BG)); %-1 permet de passer de la détection de vallées à la détection de crêtes

        BG_value = double(feval(BG,abscisse)); %On évalue la fonction créée ci-dessus sur la plage d'abscisses arbitraire
        % définie en début de code, et Gaussienne simple
        BG2_value = double(feval(BG2,abscisse)); %Gaussienne seconde

        %figure(8), plot(abscisse,re)
        GP = (BG2_value<0);
        S = sum(GP);


    end

    figure, plot(BG2_value)

    Gs = (BG_value>th);
    SG = sum(Gs);
    Gmin = -(SG+1)/2;
    Gmax =  (SG+1)/2;

    if nb_pixels ==1
        m = -5;
        M = 5;
    else
        M = Gmax;
        m = Gmin;
    end


    absc = m:1:M;
    M = 6*ceil(sigma);   % support de la gaussienne %peut etre a changer

    BG_value = double(feval(BG,absc));
    L = max(BG_value/sum(BG_value));   % pour affichage


    figure, hold on
    % plot(abs,shen/max(shen), 'linewidth', 2 )
    plot(absc, BG_value/sum(BG_value), 'k', 'linewidth', 2)

    A = legend(['\fontname{times} \it  G_\sigma, \sigma=',num2str(sigma)],'Location','northeast')
    %        ['G, \sigma = ',num2str(sigma)],'Location','northoutside')
    set(A, 'FontSize', 10)
    ylim([0 L])
    xlim([-M M])
    grid on
    grid minor
    % set(h,'FontSize',14);
    ylabel('\fontname{times} Smoothing discrete filters','FontSize',14)
    xlabel('\fontname{times} Sampling','FontSize',14)



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Derivatives
    Gx = conv(BG_value/sum(BG_value), dxx, 'same');

    L = max(Gx);  % pour affichage
    Lm = min(Gx); % pour affichage

    figure, hold on
    % plot(x,shenx/max(shenx), 'linewidth', 2)
    % plot(x, shx/max(shx), 'g', 'linewidth', 2)
    % plot(x, derx/max(derx), '--m', 'linewidth', 2)
    plot(absc, Gx , '-.k', 'linewidth', 2)
    A = legend(['\fontname{times} \it g_\sigma, \sigma=',num2str(sigma)], 'Location','southeast')
    %        ['g, \sigma = ',num2str(sigma)],'Location','northoutside')
    set(A, 'FontSize', 10)
    xlim([-M M])
    ylim([Lm L])
    grid on
    grid minor
    % set(h,'FontSize',14);
    ylabel('\fontname{times} Second order discrete filters','FontSize',14)
    xlabel('\fontname{times} Sampling','FontSize',14)


end % for nb_pixel