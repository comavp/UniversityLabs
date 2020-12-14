function [] = printClusters(X, centroids, K, L, m, message)

for i=1:m % for each feature vector
    for k=1:L % for each centroid
        distFromXToCent(i, k) = sqrt(sum((centroids(k,:) - X(i, :)).^2));
    end
    [nearestValue, nearestIndex] = min(distFromXToCent(i, :)); %min distance for each feature vector
    idx(i,1)=nearestIndex;
end

figure('Name', sprintf(message, L), 'NumberTitle', 'off');
xlim([-3 3]);
ylim([-3 3]);
hold on;
colors = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];
for i=1:L
    scatter(X(idx(:)==i, 1), X(idx(:)==i, 2), 7, colors(i), 'fill');
    scatter(centroids(i, 1), centroids(i, 2), 25, colors(L - i + 1), 'o');
end
hold off;
end