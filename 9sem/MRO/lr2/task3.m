clear;
clc;
close all;

N = 200;
priorProbability1 = 1/3; priorProbability2 = 1/3; priorProbability3 = 1/3;
digits(3);

% Получение данных из ЛР1
data =  load('C:\MRO\lr2\data\B1.mat', 'B1'); B1 = data.B1;
data = load('C:\MRO\lr2\data\B2.mat', 'B2'); B2 = data.B2;
data = load('C:\MRO\lr2\data\B3.mat', 'B3'); B3 = data.B3;
data = load('C:\MRO\lr2\data\M1.mat', 'M1'); M1 = data.M1;
data = load('C:\MRO\lr2\data\M2.mat', 'M2'); M2 = data.M2;
data = load('C:\MRO\lr2\data\M3.mat', 'M3'); M3 = data.M3;
data = load('C:\MRO\lr2\data\Y1.mat', 'Y1'); Y1 = data.Y1;
data = load('C:\MRO\lr2\data\Y2.mat', 'Y2'); Y2 = data.Y2;
data = load('C:\MRO\lr2\data\Y3.mat', 'Y3'); Y3 = data.Y3;

%Решающие границы Баесовского классификатора
syms d_12(x, y)
d_12(x, y) = vpa([x,y]*(inv(B2)-inv(B1))*[x;y]+2*(M1'*inv(B1)-M2'*inv(B2))*[x;y]+log(norm(B1)/norm(B2))+2*log(priorProbability1/priorProbability2)-M1'*inv(B1)*M1+M2'*inv(B2)*M2);
syms d_23(x, y)
d_23(x, y) = vpa([x,y]*(inv(B3)-inv(B2))*[x;y]+2*(M2'*inv(B2)-M3'*inv(B3))*[x;y]+log(norm(B2)/norm(B3))+2*log(priorProbability2/priorProbability3)-M2'*inv(B2)*M2+M3'*inv(B3)*M3);
syms d_31(x, y)
d_31(x, y) = vpa([x,y]*(inv(B3)-inv(B1))*[x;y]+2*(M1'*inv(B1)-M3'*inv(B3))*[x;y]+log(norm(B1)/norm(B3))+2*log(priorProbability1/priorProbability3)-M1'*inv(B1)*M1+M3'*inv(B3)*M3);

hold on;
scatter(Y1(1, :), Y1(2, :), 5, 'red', 'fill');
scatter(Y2(1, :), Y2(2, :), 5, 'blue', 'fill');
scatter(Y3(1, :), Y3(2, :), 5, 'green', 'fill');
rb = ezplot(d_12, [-3, 3]);
bg = ezplot(d_23, [-3, 3]);
gr = ezplot(d_31, [-3, 3]);
set(rb, 'LineColor', 'y');
set(bg, 'LineColor', 'c');
set(gr, 'LineColor', 'm');
hold off;