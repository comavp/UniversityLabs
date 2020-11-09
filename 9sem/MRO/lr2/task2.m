clear;
clc;
close all;

% Получение данных из ЛР1
data = load('C:\MRO\lr2\data\B.mat', 'B'); B = data.B;
data = load('C:\MRO\lr2\data\M1.mat', 'M1'); M1 = data.M1;
data = load('C:\MRO\lr2\data\M2.mat', 'M2'); M2 = data.M2;
data = load('C:\MRO\lr2\data\X1.mat', 'X1'); X1 = data.X1;
data = load('C:\MRO\lr2\data\X2.mat', 'X2'); X2 = data.X2;

% Минимаксный классификатор

%Вероятности ошибочной классификации
syms lambda;
mDistance = getMahalanobisDistance(M1, M2, B);
PF1 = vpa(1-(1+erf(((0.5*mDistance+lambda)/sqrt(mDistance))/sqrt(2)))/2);
PF2 = vpa((1+erf(((-0.5*mDistance+lambda)/sqrt(mDistance))/sqrt(2)))/2);
l = solve(PF1 == PF2);
P1 = vpa(1-(1+erf(((0.5*mDistance+l)/sqrt(mDistance))/sqrt(2)))/2);
P2 = vpa((1+erf(((-0.5*mDistance+l)/sqrt(mDistance))/sqrt(2)))/2);
SumP = (P1+P2)/2;
R = P1;

disp('Минимаксный классификатор');
fprintf('Вероятность ошибочной классификации 1 =  %.4f \n(%s)\n', double(P1), PF1);
fprintf('Вероятность ошибочной классификации 2 =  %.4f \n(%s)\n', double(P2), PF2);
fprintf('Суммарная вероятность ошибочной классификации =  %.4f \n', double(SumP));
fprintf('Общий риск =  %.4f \n', double(R));

%Минимаксная решающая граница
syms d_12(x, y);
d_12 = vpa(((M1-M2)'*inv(B))*[x; y]-((1/2)*(M1+M2)'*inv(B)*(M1-M2)+l));
figure('Name', 'МинМакс', 'NumberTitle', 'off');
hold on;
ezplot(d_12, [-3, 3]);
scatter(X1(1, :), X1(2, :), 10, 'r', 'fill');
scatter(X2(1, :), X2(2, :), 10, 'b', 'fill');
hold off;

% Классификатор Неймона-Пирсона

%Вероятности ошибочной классификации
typeIErrorProbability = 0.05;
syms lambda;
mDistance = getMahalanobisDistance(M1, M2, B);
typeIIErrorProbability = vpa(1-(1+erf(((0.5*mDistance+lambda)/sqrt(mDistance))/sqrt(2)))/2);

%Решающая граница классификатора Неймона-Пирсона
syms d_12(x, y);
d_12 = vpa(((M1-M2)'*inv(B))*[x; y]-((1/2)*(M1+M2)'*inv(B)*(M1-M2)+(solve(typeIIErrorProbability==typeIErrorProbability))));
figure('Name', 'Неймона-Пирсона', 'NumberTitle', 'off');
hold on;
ezplot(d_12, [-3, 3]);
scatter(X1(1, :), X1(2, :), 10, 'r', 'fill');
scatter(X2(1, :), X2(2, :), 10, 'b', 'fill');
hold off;

disp('Классификатор Неймона-Пирсона');
fprintf('Вероятность ошибочной классификации 1 =  %d \n', typeIErrorProbability);
fprintf('Вероятность ошибочной классификации 2 =  %s \n', typeIIErrorProbability);