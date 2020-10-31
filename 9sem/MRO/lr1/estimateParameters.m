function [M, B] = estimateParameters(X)  
    N = size(X, 2);
    M = (sum(X') / N)';
    B = zeros (2, 2);
    for i=1:N
        deltaXM = X(:, i) - M;
        B = B + deltaXM * deltaXM';
    end
    B = B / N;
end