clear all
close all

CLOSE =0

syms x;

assume(x, 'real');

%x = 0.5:0.1:20;
%x2 = x + 52;
% y = x.^(1./x);
% y = log(x);
% y = x./(x+x.*x);
% y = 2 - (x.^(1/3))./(1+(x.^(1/3)));
% y = 2 - x.^2./(1+x.^2);
% y = exp(1./(x+1));
% y = 1 + 1./(x.^(1/3));
% y = -x + max(x)
%y = sqrt(x) + 1./sqrt(x);
% y = (x).^(1./x) + 1./sqrt(x);

%figure(10), plot(x,y)


abscisse = -10:1:10;

%sigma = [0.58 1.81 2.88 3.91 4.93 5.94 6.95 7.95 8.96];
sigma = [0 2 0 0 5];
%sigma_b = sigma .* rho;
%k = rho^2;

nbRidge = 3;

L = 20;
s = zeros(1, L);

if CLOSE
    % close ridges
    s = zeros(1, 20);

    %for i = 1:1:nbRidge     % build signal
    for i = 2
        R = 2*i-1;
        RR = [];
        for j = nbRidge
            RR = [RR zeros(1,2*i-1) ones(1,R)];
        end
        s = [s RR zeros(1, L)];
    end

else
    for i = 2     % build signal
        R = 2*i-1;
        s = [s ones(1,R) zeros(1, L+i)];
    end

end
s = [s zeros(1, 20)];
figure, bar(s)




s2 = s;

for i = 2   % filtering
    for rho = 0.1:0.1:1
        sigma_b = sigma .* rho;
        k = rho^2;


        %Gaussienne d'écart-type sigma
        Gauss = (exp(-x^2/(2*(sigma(i))^2)));
        G2(x) = diff(diff(Gauss));

        %figure(1);
        % fplot(G2)

        %Gaussienne d'écart-type sigma_b
        Gauss2 = (exp(-x^2/(2*(sigma_b(i))^2)));
        H2 = diff(diff(Gauss2));

        %figure(2);
        %fplot(H2);

        %milieu : deuxieme methode pour la fonction par morceaux
        Indic_milieu = heaviside(x+3*sigma(i))-heaviside(x-3*sigma(i));

        %gauche :  deuxieme methode pour la fonction par morceaux
        Indic_gauche = heaviside(x+3*(sigma(i)+sigma_b(i)))-heaviside(x+3*sigma(i));

        %droite : deuxieme methode pour la fonction par morceaux
        Indic_droite = heaviside(x-3*sigma(i)) - heaviside(x-3*(sigma(i)+sigma_b(i)));

        %fonction de composition pour H2
        gauche = x - sigma_b(i) + sigma(i);
        droite = x + sigma_b(i) - sigma(i);


        % f_gauche = compose(k*H2,gauche)*Indic_gauche;  pas terrible
        f_gauche = piecewise(x<=sigma(i), compose(k*H2,gauche),0);

        %f_milieu = G2*Indic_milieu; pas terrible
        f_milieu = piecewise(abs(x)<sigma(i),G2);

        f_droite = piecewise(x>=sigma(i), compose(k*H2,droite),0);

        f_res(x) = -1*piecewise(x<=-sigma(i), f_gauche, abs(x)<sigma(i), f_milieu, x>=sigma(i), f_droite,0.5);

        abscisse = -20:1:20;
        resultat = double(feval(f_res,abscisse));

        %valeurs_G2 = feval(-G2,x);

        % filter normalization : 
        PosF = ((resultat>0).*resultat);
        NegF = ((resultat<0).*resultat);
        MM = sum(sum( PosF ));
        mm = -sum(sum( NegF ));
        PosF = PosF / MM;
        NegF = NegF / mm;
        L  = PosF + NegF ;

        Y = sum(resultat)
       
        figure(30);
        plot(abscisse,resultat);
        figure(31);
        plot(abscisse,L);




        % convolution
        %     s2(i, :) = conv(s, G2, 'same')
        %     s2(i, :) = conv(s, sigma(i)^(1/sigma(i))*G2, 'same')
        %     s2(i, :) = conv(s, (2 - sigma(i)^(1/3)/(1 + sigma(i)^(1/3)))*G2, 'same')
        %     s2(i, :) = conv(s, (exp(1 / (1 + sigma(i))))*G2, 'same')
        %     s2(i, :) = conv(s, (1 - 1/(sigma(i)^(1/(1+sigma(i)))))*L, 'same')
        %    s2(i, :) = conv(s, (1 + -sigma(i) + max(sigma))*G2, 'same')
        s2(i, :) = (conv(s, ((sigma(i))^(1/sigma(i)) + 1/(sqrt(sigma(i))))*L, 'same'));
        
        Z = sum(s2(i,:))

        figure(1);
        s2 = (s2>0).*s2;    % only positive values
        subplot(nbRidge,1, i);
        %     subplot(nbRidge,2, 2*i-1),
        %     plot (x, L, 'linewidth', 2), hold on
        stem (abscisse, resultat , '.', 'linewidth', 2);
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

        figure(10)
        subplot(nbRidge,1,i), hold on, 
        plot(abscisse,L)
    end
end

