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

if K==3 
    X = [X1, X2, X3];
elseif K==5
    X = [X1, X2, X3, X4, X5];
elseif K==2
    X = [X1, X2];
end
X=X';

clusters_num = K;
X_initial = X;
[m, n] = size(X);
MX = mean(X, 1);
distToCent = zeros(m, clusters_num);
idx = zeros(m, 1);
centroids = zeros(clusters_num, 2);
grMax=zeros(K-2,2);
grTyp=zeros(K-2,2);

%Step 1 M0
L = 1;
for i=1:m
    distToCent(i, L) = sqrt(sum((MX - X(i,:)).^2));
end
[~, maxIndex] = max(distToCent(:, 1));
centroids(L, :) = X(maxIndex,:);

%Step 2 M1
L = L + 1;
for i=1:m
    distToCent(i, L) = sqrt(sum((centroids(1,:) - X(i,:)).^2));
end
[maxValue, maxIndex] = max(distToCent(:, L));
centroids(L,:) = X(maxIndex,:);

printClusters(X, centroids, K, L, m, 'Минимаксная кластеризация, L = %d');

while true
    %Step 3 Recalculation
    min_d = zeros(m, 1);
    for i=1:m % for each feature vector
        for k=1:L % for each centroid
            distToCent(i, k) = sqrt(sum((centroids(k,:) - X(i, :)).^2));
        end
        [minValue, minIndex] = min(distToCent(i, 1:L)); %min distance for each feature vector
        min_d(i) = minValue;
    end
    [max_d, maxIndex] = max(min_d);

    centroid_dist = zeros(L, 1);
    for k=1:L % for each centroid
        centroid_dist(k) = sqrt(sum((centroids(k,:) - X(maxIndex, :)).^2)); %i X(maxIndex, :) - potential centroid
    end
    [minCentroidDist, minCentroidDistIndex] = min(centroid_dist);

    %typicalDist
    centroidsDist=zeros(L, L);
    for i=1:L
       for j=i+1:L
           centroidsDist(i,j)=sqrt( sum((centroids(i,:) - centroids(j,:)).^2));
       end
    end
    centroidsDist=centroidsDist(:);
    typSum=sum(centroidsDist);
    cnt=length(find(centroidsDist));
    typicalDist=typSum/cnt*0.5;
    
    if(minCentroidDist > typicalDist)
        L = L + 1;
        centroids(L, :) = X(maxIndex, :);
    else
        break;
    end          
    grMax(L-2,:)=[max_d,L];
    grTyp(L-2,:)=[typicalDist,L];
    
    printClusters(X, centroids, K, L, m, 'Минимаксная кластеризация, L = %d');
end

figure('Name', 'Зависимости от числа кластеров', 'NumberTitle', 'off');
hold on;
plot(grMax(:,2),grMax(:,1));
plot(grTyp(:,2),grTyp(:,1));
legend('Зависимость максимального (из минимальных) расстояния','Зависимость типичного расстояния');
hold off;