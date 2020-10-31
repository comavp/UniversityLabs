clear;
clc;
close all;

n = 2;
N = 200;
X1 = zeros(n, N);

M1 = [0 1]';
M2 = [-1 -1]';
M3 = [1 0]';
B = [0.25 0; 0 0.25];
B1 = [0.1 0; 0 0.1];
B2 = [0.32 0; 0.5 0.78];
B3 = [0.1 0; 0.23 0.12];

X1 = generateRandomVectors(n, N, M1, B);
X2 = generateRandomVectors(n, N, M2, B);
bDistance = getBhattacharyyaDistance(M1, M2, B, B);
mDistance = getMahalanobisDistance(M1, M2, B);
[M1_Point_1, B_Point_1] = estimateParameters(X1);
[M2_Point_1, B_Point_2] = estimateParameters(X2);

Y1 = generateRandomVectors(n, N, M1, B1);
Y2 = generateRandomVectors(n, N, M2, B2);
Y3 = generateRandomVectors(n, N, M3, B3);
bDistance_12 = getBhattacharyyaDistance(M1, M2, B1, B2);
bDistance_13 = getBhattacharyyaDistance(M1, M3, B1, B3);
bDistance_23 = getBhattacharyyaDistance(M2, M3, B2, B3);
[M1_Point_2, B1_Point] = estimateParameters(Y1);
[M2_Point_2, B2_Point] = estimateParameters(Y2);
[M3_Point, B3_Point] = estimateParameters(Y3);

figure;
hold on;
scatter(X1(1, :),X1(2, :), 10, 'r', 'fill');
scatter(X2(1, :), X2(2, :), 10, 'b', 'fill');
hold off;
xlim([-3 3]);
ylim([-3 3]);

figure;
hold on;
scatter(Y1(1, :),Y1(2, :), 10, 'r', 'fill');
scatter(Y2(1, :),Y2(2, :), 10, 'g', 'fill');
scatter(Y3(1, :),Y3(2, :), 10, 'b', 'fill');
hold off;
xlim([-3 3]);
ylim([-3 3]);

letter1 = [0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7];
letter2 = [0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3];
l1 = getVectorModifications(letter1, 200);
l2 = getVectorModifications(letter2, 200);
letter1Image = uint8(255 * reshape((sum(l1') / size(l1, 2))',9,9)');
letter2Image = uint8(255 * reshape((sum(l2') / size(l2, 2))',9,9)');

figure;
subplot(1, 2, 1); imshow(letter1Image);
subplot(1, 2, 2); imshow(letter2Image);

save('X1.mat', 'X1'); save('X2.mat', 'X2');
save('Y1.mat', 'Y1'); save('Y2.mat', 'Y2'); save('Y3.mat', 'Y3');
save('letter1.mat', 'l1'); save('letter2.mat', 'l2');
save('M1.mat', 'M1'); save('M2.mat', 'M2'); save('M3.mat', 'M3');
save('B.mat', 'B'); save('B1.mat', 'B1'); save('B2.mat', 'B2'); save('B3.mat', 'B3');