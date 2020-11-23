clear;
clc;
close all;

% Получение данных из ЛР1
data = load('C:\MRO\lr2\data\B.mat', 'B'); B = data.B;
data = load('C:\MRO\lr2\data\X1.mat', 'X1'); X1 = data.X1;
data = load('C:\MRO\lr2\data\X2.mat', 'X2'); X2 = data.X2;
data = load('C:\MRO\lr2\data\B1.mat', 'B1'); B1 = data.B1;
data = load('C:\MRO\lr2\data\B2.mat', 'B2'); B2 = data.B2;
data = load('C:\MRO\lr2\data\M1.mat', 'M1'); M1 = data.M1;
data = load('C:\MRO\lr2\data\M2.mat', 'M2'); M2 = data.M2;
data = load('C:\MRO\lr2\data\Y1.mat', 'Y1'); Y1 = data.Y1;
data = load('C:\MRO\lr2\data\Y2.mat', 'Y2'); Y2 = data.Y2;

p1 = 0.5;
p2 = 0.5;
digits(3);
N = 200;

%Равные корреляционные матрицы
disp('Равные корреляционные матрицы');
syms x y;
bayes1(x, y) = vpa(getBayesDiscFunc(M1, B, M2, B, p1, p2));

rm1 = vpa(getDiscFuncByRobbinsMonroAlg(X1, X2));

fprintf('Линейный классификатор, основанный на процедуре Роббинса-Монро: %s\n', rm1);
fprintf('Классификатор Байеса: %s\n\n', bayes1);

figure('Name', 'Равные корреляционные матрицы', 'NumberTitle', 'off');
hold on; 
scatter(X1(1, :), X1(2, :), 10, 'r', 'fill');
scatter(X2(1, :), X2(2, :), 10, 'b', 'fill');
xlim([-3 3])
ylim([-3 3])
d1 = ezplot(rm1, [-3, 3]);
d2 = ezplot(bayes1, [-3, 3]);
set(d2, 'LineColor', 'g');
set(d1, 'LineColor', 'm');
hold off;

%Неравные корреляционные матрицы
disp('Неравные корреляционные матрицы');
syms bayes2(x, y);
bayes2(x, y) = vpa(getBayesDiscFunc(M1, B1, M2, B2, p1, p2));
rm2 = vpa(getDiscFuncByRobbinsMonroAlg(Y1, Y2));

fprintf('Линейный классификатор, основанный на процедуре Роббинса-Монро: %s\n', rm2);
fprintf('Классификатор Байеса: %s\n\n', bayes2);

figure('Name', 'Неравные корреляционные матрицы', 'NumberTitle', 'off');
hold on; 
scatter(Y1(1, :), Y1(2, :), 10, 'r', 'fill');
scatter(Y2(1, :), Y2(2, :), 10, 'b', 'fill');
xlim([-3 3])
ylim([-3 3])
d1 = ezplot(rm2, [-3, 3]);
d2 = ezplot(bayes2, [-3, 3]);
set(d2, 'LineColor', 'g');
set(d1, 'LineColor', 'm');
hold off;