function idx = findClosestCentroids(X, centroids)
K = size(centroids, 1);
idx = zeros(size(X,1), 1);
[m , ~]=size(X);
for i=1:m
    dist = zeros(K,1);
    for j=1:K
        dist(j,1) = sqrt(sum((centroids(j,:) - X(i, :)).^2));
    end
    z = find(dist == min(dist));
    idx(i,1)=z(1);
end
end