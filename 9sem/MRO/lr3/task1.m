clear;
clc;
close all;

% Получение данных из ЛР1
data = load('C:\UniversityLabs\9sem\MRO\lr3\data\B.mat', 'B'); B = data.B;
data = load('C:\UniversityLabs\9sem\MRO\lr3\data\X1.mat', 'X1'); X1 = data.X1;
data = load('C:\UniversityLabs\9sem\MRO\lr3\data\X2.mat', 'X2'); X2 = data.X2;
data = load('C:\UniversityLabs\9sem\MRO\lr3\data\B1.mat', 'B1'); B1 = data.B1;
data = load('C:\UniversityLabs\9sem\MRO\lr3\data\B2.mat', 'B2'); B2 = data.B2;
data = load('C:\UniversityLabs\9sem\MRO\lr3\data\M1.mat', 'M1'); M1 = data.M1;
data = load('C:\UniversityLabs\9sem\MRO\lr3\data\M2.mat', 'M2'); M2 = data.M2;
data = load('C:\UniversityLabs\9sem\MRO\lr3\data\Y1.mat', 'Y1'); Y1 = data.Y1;
data = load('C:\UniversityLabs\9sem\MRO\lr3\data\Y2.mat', 'Y2'); Y2 = data.Y2;

p1 = 0.5;
p2 = 0.5;
digits(3);

%Классификатор, максимизирующий критерий Фишера
%Равные корреляционные матрицы
disp('Равные корреляционные матрицы');
syms fisher1(x, y);
fisher1(x, y) = vpa(getFisherDiscFunc(M1, M2, B, B, X1, X2));
fprintf('Классификатор Фишера: %s\n', fisher1(x, y));
syms bayes1(x, y);
bayes1(x, y) = vpa(getBayesDiscFunc(M1, B, M2, B, p1, p2));
fprintf('Классификатор Байеса: %s\n\n', bayes1(x, y));

%Неравные корреляционные матрицы
disp('Неравные корреляционные матрицы');
syms fisher2(x, y);
fisher2(x, y) = vpa(getFisherDiscFunc(M1, M2, B1, B2, Y1, Y2));
fprintf('Классификатор Фишера: %s\n', fisher2(x, y));
syms bayes2(x, y);
bayes2(x, y) = vpa(getBayesDiscFunc(M1, B1, M2, B2, p1, p2));
fprintf('Классификатор Байеса: %s\n', bayes2(x, y));

%Графики при равных корреляционных матриц
figure('Name', 'Равные корреляционные матрицы', 'NumberTitle', 'off');
hold on;
scatter(X1(1, :), X1(2, :), 10, 'red', 'fill');
scatter(X2(1, :), X2(2, :), 10, 'blue', 'fill');
fisher1_plot = ezplot(fisher1, [-3, 3]);
bayes1_plot = ezplot(bayes1, [-3, 3]);
set(fisher1_plot, 'LineColor', 'black');
set(bayes1_plot, 'LineColor', 'magenta');
hold off;

%Графики при неравных корреляционных матриц
figure('Name', 'Неравные корреляционные матрицы', 'NumberTitle', 'off');
hold on;
scatter(Y1(1, :), Y1(2, :), 10, 'red', 'fill');
scatter(Y2(1, :), Y2(2, :), 10, 'blue', 'fill');
fisher2_plot = ezplot(fisher2, [-3, 3]);
bayes2_plot = ezplot(bayes2, [-3, 3]);
set(fisher2_plot, 'LineColor', 'black');
set(bayes2_plot, 'LineColor', 'magenta');
hold off;