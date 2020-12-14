function [centroids, idx, graf] = runkMeans(X, initial_centroids)
%k-Means algorithm
[m , ~] = size(X); % n - dimension of features (2 in this case)
K = size(initial_centroids, 1);
centroids = initial_centroids;
idx = zeros(m, 1);
lastCent = initial_centroids;
lastIdx = idx;
graf = zeros(0, 2);
i=1;
while true    
    %Step 1
    idx = findClosestCentroids(X, centroids);  
    %Step 2
    centroids = computeCentroids(X, idx, K);
    printClusters(X, centroids, K, K, m, 'Кластеризация алгоритмом K групповых средних, K = %d');
    if centroids==lastCent
        break;
    end

    graf=cat(1,graf,[length(find(idx~=lastIdx)),i]);
        
    lastCent=centroids;
    lastIdx=idx;
    i=i+1;        
    %fprintf('Итерация номер %d\n', i);
end

fprintf('Количество итераций алгоритма: %d\n', i);
end