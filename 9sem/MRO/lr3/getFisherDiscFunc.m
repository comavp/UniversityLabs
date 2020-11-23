function [ fisher ] = getFisherDiscFunc(M1, M2, B1, B2, X1, X2)
    W = (0.5*(B1 + B2))^(-1)*(M2 - M1);
    D1 = W.'*B1*W;
    D2 = W.'*B2*W;
    wN = -((M2 - M1).' * (1/2 *(B2 + B1))^(-1) * (D2*M1+D1*M2)  ) / (D1+D2);
    syms x y;
    fisher = W.'*[x; y]+wN;
    for i=1:200
        d1fishera(i) = (W(1)*X1(1,i)+W(2)*X1(2,i)) + wN;
        d2fishera(i) = (W(1)*X2(1,i)+W(2)*X2(2,i)) + wN;
    end
    disp('Вероятности ошибок для классификатора Фишера');
    fprintf('Вероятность ошибки первого рода = %f\n', size(d1fishera(d1fishera>0),2)/200);
    fprintf('Вероятность ошибки второго рода = %f\n', size(d2fishera(d2fishera<0),2)/200);
end

