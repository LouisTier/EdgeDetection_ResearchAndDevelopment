clear all
close all

 
%%%%%%
dx = [-1 0 1]; 
dxx = [1 0 -2 0 1];   % pour calculer les dérivées

for nb_pixels = 1:2:7 %%%%% attention, on teste avec des crêtes de largeur impaire

    th = 10^(-5)    % pour les limites de la gaussienne

    % bornes pour le culcul du remplissage

    % x=-100:1:120;
    x=-150:1:150;
    minx = min(x);
    maxx=max(x);

    % gaussienne

    sigma = 20
     SG =1
    S = 1000;
    X = minx:1:maxx;      
    while (S > nb_pixels)
        sigma = sigma - 0.01
        G = exp(-X.^2 / (2*sigma^2));

        Gxx = conv(G, dxx, 'same'); % evite les aberations aux bords (supprime un pixel a droite et a gauche)
        GP = (Gxx < 0);
        S = sum(GP);    
    end

    % figure, plot(Gxx)

    Gs = (G>th);
    SG = sum(Gs)
    Gmin = -(SG+1)/2; 
    Gmax =  (SG+1)/2; 

    if nb_pixels ==1
        m = -5;
        M = 5;
    else
        M = Gmax;
        m = Gmin;
    end


    x = m:1:M;
    M = 6*ceil(sigma);   % support de la gaussienne

    G = exp(-x.^2 / (2*sigma^2));
    H = max(G/sum(G));   % pour affichage

    
    figure, hold on
    % plot(x,shen/max(shen), 'linewidth', 2 )
    plot(x, G/sum(G), 'k', 'linewidth', 2)

    A = legend(['\fontname{times} \it  G_\sigma, \sigma=',num2str(sigma)],'Location','northeast')
    %        ['G, \sigma = ',num2str(sigma)],'Location','northoutside')
    set(A, 'FontSize', 10)
   ylim([0 H])
   xlim([-M M])
    grid on
    grid minor
    % set(h,'FontSize',14); 
    ylabel('\fontname{times} Smoothing discrete filters','FontSize',14)
    xlabel('\fontname{times} Sampling','FontSize',14)



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Derivatives
    Gx = conv(G/sum(G), dxx, 'same');

    H = max(Gx);  % pour affichage
    Hm = min(Gx); % pour affichage

    figure, hold on
    % plot(x,shenx/max(shenx), 'linewidth', 2)
    % plot(x, shx/max(shx), 'g', 'linewidth', 2)
    % plot(x, derx/max(derx), '--m', 'linewidth', 2)
    plot(x, Gx , '-.k', 'linewidth', 2)
    A = legend(['\fontname{times} \it g_\sigma, \sigma=',num2str(sigma)], 'Location','southeast')
    %        ['g, \sigma = ',num2str(sigma)],'Location','northoutside')
    set(A, 'FontSize', 10)
    xlim([-M M])
        ylim([Hm H])
    grid on
    grid minor
    % set(h,'FontSize',14); 
    ylabel('\fontname{times} Second order discrete filters','FontSize',14)
    xlabel('\fontname{times} Sampling','FontSize',14)

    
end % for nb_pixel