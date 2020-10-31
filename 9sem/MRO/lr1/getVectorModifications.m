function X = getVectorModifications(L, N)
    W = size(L, 2);
    X = zeros(W, N);
    for i=1:N
        tmpX = fix(rand(size(L)) ./ (1 - L));
        tmpX(find(tmpX)) = 1;
        X(:, i) = tmpX;
    end
end