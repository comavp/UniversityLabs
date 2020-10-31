clear;
clc;
close all;

% Получение данных из ЛР1
data = load('C:\MRO\lr2\data\B.mat', 'B'); B = data.B;
data = load('C:\MRO\lr2\data\M1.mat', 'M1'); M1 = data.M1;
data = load('C:\MRO\lr2\data\M2.mat', 'M2'); M2 = data.M2;
data = load('C:\MRO\lr2\data\X1.mat', 'X1'); X1 = data.X1;
data = load('C:\MRO\lr2\data\X2.mat', 'X2'); X2 = data.X2;

priorProbability1 = 1/2; priorProbability2 = 1/2;

%Баесовская решающая граница
syms d_12(x, y);
digits(3);
d_12(x, y) = vpa(((M1-M2)'*inv(B))*[x; y]-((1/2)*(M1+M2)'*inv(B)*(M1-M2)+log(priorProbability1/priorProbability2)));
hold on;
ezplot(d_12, [-3, 3]);
scatter(X1(1, :), X1(2, :), 10, 'r', 'fill');
scatter(X2(1, :), X2(2, :), 10, 'b', 'fill');
hold off;

%Вероятности ошибочной классификации
mDistance = getMahalanobisDistance(M1, M2, B);
lambda = log(priorProbability1/priorProbability2)
probabilityOfMisclassification1 = 1-(1+erf(((0.5*mDistance+lambda)/sqrt(mDistance))/sqrt(2)))/2
probabilityOfMisclassification2 = (1+erf(((-0.5*mDistance+lambda)/sqrt(mDistance))/sqrt(2)))/2
totalProbabilityOfMisclassification = (probabilityOfMisclassification1+probabilityOfMisclassification2)/2
totalRisk = probabilityOfMisclassification1
