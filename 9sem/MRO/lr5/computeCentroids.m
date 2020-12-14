function centroids = computeCentroids(X, idx, K)
[~, n] = size(X);
centroids = zeros(K, n);
for k=1:K
    Xk = X(idx==k,:);
    S = sum(Xk);
    cnt = length(Xk);
    centroids(k,:)=S./cnt;
end