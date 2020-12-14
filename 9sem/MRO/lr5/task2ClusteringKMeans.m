close all;
clear;
clc;

M1 = [ 0; 1];
M2 = [-1; -1];
M3 = [1; 0];
M4 = [-1; -2];
M5 = [0; 0];

R1=[0.1 0.0;0.0 0.075];
R2=[0.1 0.0;0.0 0.1];
R3=[0.05 0.0;0.1 0.05];
R4=[0.1 0.05;0.0 0.075];
R5=[0.05 0;0.05 0.05];

n = 2;
N = 50;
K = 5;

X1 = generateRandomVectors(M1, R1, n, N);
X2 = generateRandomVectors(M2, R2, n, N);
X3 = generateRandomVectors(M3, R3, n, N);
X4 = generateRandomVectors(M4, R4, n, N);
X5 = generateRandomVectors(M5, R5, n, N);

figure('Name', 'Исходные данные', 'NumberTitle', 'off');
xlim([-3 3]);
ylim([-3 3]);
hold on;
scatter(X1(1, :), X1(2, :), 7, 'red', 'fill');
scatter(X2(1, :), X2(2, :), 7, 'green', 'fill');
scatter(X3(1, :), X3(2, :), 7, 'blue', 'fill');
scatter(X4(1, :), X4(2, :), 7, 'cyan', 'fill');
scatter(X5(1, :), X5(2, :), 7, 'magenta', 'fill');
hold off;

X = [X1, X2, X3, X4, X5];
X = X';

if K==3 
    initial_centroids = [X(1,:); X(2,:); X(3,:)];
elseif K==5
    % good clustering
    initial_centroids = [X(70,:);X(11,:);X(52,:);X(53,:);X(54,:)];
    % bad clustering
    %initial_centroids = [X(1,:); X(2,:); X(3,:); X(4,:); X(5,:)];
end

[centroids, idx, graf] = runkMeans(X, initial_centroids);

figure;
plot(graf(:,2),graf(:,1));title('Зависимость числа векторов, сменивших номер, от итерации');


