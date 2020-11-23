function rm = getDiscFuncByRobbinsMonroAlg(X1, X2)
    N = size(X1, 2);
    NIterations = 20000;
    for i=1:NIterations
        for k=1:2
            if(mod(i, 2) == 0)
                z(k, i) = X1(k, 1 + mod(i/2, N));
            else
                z(k, i) = X2(k, 1 + mod((i-1)/2, N));
            end
        end
        z(3, i) = 1;
        if(mod(i,2) == 0)
            r(i) = 1;
        else
            r(i) = -1;
        end
        alpha(i) = 1 / (i^0.7);
    end
    W(1, 1) = 0;
    W(2, 1) = 0;
    W(3, 1) = 0;
    for i=1:NIterations
        W(:, i+1) = W(:, i)+alpha(i)*z(:, i)*(r(i)-W(:, i)'*z(:, i));
    end
    syms x y
    rm = W(1:2, NIterations+1)'*[x; y]+ W(3, NIterations+1);

    center = floor(N / 2) + 1;
    for i=1:200
        d1rm(i) = (W(1, center)*X1(1,i)+W(2, center)*X1(2,i)) + W(3, center);
        d2rm(i) = (W(1, center)*X2(1,i)+W(2, center)*X2(2,i)) + W(3, center);
    end
    
    disp('Вероятности ошибок ЛК, основанного на процедуре Роббинса-Монро');
    fprintf('Вероятность ошибки первого рода = %f\n', size(d1rm(d1rm<0),2)/200);
    fprintf('Вероятность ошибки второго рода = %f\n', size(d2rm(d2rm>0),2)/200);
    
    drm2 = vpa(W(1:2, 10)'*[x; y]+ W(3, 10));
    drm3 = vpa(W(1:2, 100)'*[x; y]+ W(3, 100));
    drm4 = vpa(W(1:2, 1000)'*[x; y]+ W(3, 1000));
    drm5 = vpa(W(1:2, 10000)'*[x; y]+ W(3, 10000));


    figure('Name', 'Исследование скорости сходимости алгоритма', 'NumberTitle', 'off');
    hold on; 
    scatter(X1(1, :), X1(2, :), 5, 'r', 'fill');
    scatter(X2(1, :), X2(2, :), 5, 'b', 'fill');
    xlim([-3 3])
    ylim([-3 3])
    d1 = ezplot(rm, [-3, 3]);
    d2 = ezplot(drm2, [-3, 3]);
    d3 = ezplot(drm3, [-3, 3]);
    d4 = ezplot(drm4, [-3, 3]);
    d5 = ezplot(drm5, [-3, 3]);
    set(d1, 'LineColor', 'm');
    set(d2, 'LineColor', 'y');
    set(d3, 'LineColor', 'r');
    set(d4, 'LineColor', 'b');
    set(d5, 'LineColor', 'g');
    %set(d6, 'LineColor', 'o');
    hold off;
end