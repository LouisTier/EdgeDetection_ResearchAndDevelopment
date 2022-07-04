syms x; %x est une variable

assume(x, 'real'); %on dit que x est un réel

abscisse = -10:1:10; %Plage de la gaussienne
abscisse2 = -20:1:20;
resultat = [];


sigma = [0.58 1.81 2.88 3.91 4.93 5.94 6.95 7.95 8.96];

for rho = 0.1:0.1:1
    sigma_b = sigma .* rho; %Paramètres des 2 gaussiennes de part et d'autre de la centrale
    k = rho^2;
    sigma_b = sigma .* rho; %Paramètres des 2 gaussiennes de part et d'autre de la centrale
    k = rho^2;
    i = 2;
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


    %     figure(15);
    %     subplot(2,1,1),fplot(BG);
    %     subplot(2,1,2),fplot(BG2)


    BG_value = double(feval(BG,abscisse)); %On évalue la fonction créée ci-dessus sur la plage d'abscisses arbitraire
    % définie en début de code, et Gaussienne simple
    BG2_value = double(feval(BG2,abscisse)); %Gaussienne seconde

    % filter normalization :
    PosF2 = ((BG2_value>0).*BG2_value);
    NegF2 = ((BG2_value<0).*BG2_value);
    MM2 = sum(sum( PosF2 ));
    mm2 = -sum(sum( NegF2 ));
    PosF2_norm = PosF2 / MM2;
    NegF2_norm = NegF2 / mm2;
    BG2_value  = PosF2_norm + NegF2_norm ;

    resultat = [resultat BG2_value];
   
end
    
% figure(2) ,   
% plot( abscisse2, resultat(1:41),'Color', [0, 0.5, 0.5], 'LineWidth',2),  hold on,
% plot( abscisse2, resultat(42:82),'Color', [0.5, 0, .5], 'LineWidth',2),  hold on,
% plot( abscisse2, resultat(83:123),'Color', 'b', 'LineWidth',2), hold on,
% plot( abscisse2, resultat(124:164),'Color', 'r', 'LineWidth',2), hold on,
% plot( abscisse2, resultat(165:205),'Color', 'g', 'LineWidth',2),hold on,
% plot( abscisse2, resultat(206:246),'Color', 'm', 'LineWidth',2),hold on,
% plot( abscisse2, resultat(247:287),'Color', 'c', 'LineWidth',2), hold on,
% plot( abscisse2, resultat(288:328),'Color', 'k', 'LineWidth',2), hold on,
% plot( abscisse2, resultat(329:369),'Color', [0.9290, 0.6940, 0.1250], 'LineWidth',2), hold on,
% plot( abscisse2, resultat(370:410),'--','Color', [0.6940, 0.1250, 0.9290], 'LineWidth',2),
% h_legend = legend('\rho = 0.1','\rho = 0.2','\rho = 0.3','\rho = 0.4', '\rho = 0.5','\rho = 0.6','\rho = 0.7','\rho = 0.8','\rho = 0.9','\rho = 1'),
% set(h_legend,'FontSize',25);
% set(h_legend,'Location','EastOutside')
% grid on;
% grid minor;
% exportgraphics(gcf,'4.83.pdf','ContentType','vector')
% hold off;



figure(1)
plot( abscisse, resultat(1:21),'Color', [0, 0.5, 0.5], 'LineWidth',2),  hold on,
plot( abscisse, resultat(22:42),'Color', [0.5, 0, .5], 'LineWidth',2),  hold on,
plot( abscisse, resultat(43:63),'Color', 'b', 'LineWidth',2), hold on,
plot( abscisse, resultat(64:84),'Color', 'r', 'LineWidth',2), hold on,
plot( abscisse, resultat(85:105),'Color', 'g', 'LineWidth',2),hold on,
plot( abscisse, resultat(106:126),'Color', 'm', 'LineWidth',2),hold on,
plot( abscisse, resultat(127:147),'Color', 'c', 'LineWidth',2), hold on,
plot( abscisse, resultat(148:168),'Color', 'k', 'LineWidth',2), hold on,
plot( abscisse, resultat(169:189),'Color', [0.9290, 0.6940, 0.1250], 'LineWidth',2), hold on,
plot( abscisse, resultat(190:210),'--','Color', [0.6940, 0.1250, 0.9290], 'LineWidth',2),
%h_legend = legend('\rho = 0.1','\rho = 0.2','\rho = 0.3','\rho = 0.4', '\rho = 0.5','\rho = 0.6','\rho = 0.7','\rho = 0.8','\rho = 0.9','\rho = 1')
%set(h_legend,'FontSize',17);
%set(h_legend,'Location','EastOutside')
grid on;
grid minor;
exportgraphics(gcf,'1.81.pdf','ContentType','vector')
hold off;

