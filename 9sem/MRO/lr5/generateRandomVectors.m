function X = gennormvec(M, B, n, N)
X = zeros(n, N);
A = zeros(2, 2);

A(1, 1) = sqrt(B(1, 1));
A(1, 2) = 0;
A(2, 1) = B(1, 2) / sqrt(B(1, 1));
A(2, 2) = sqrt(B(2, 2) - B(1, 2)^2/B(1, 1));

R = normrnd(0,1,n,N);

for k=1:n
    for i=1:N
        Sum = 0;
        for l=1:2
            Sum = Sum + A(k, l) * R(l, i);
        end
        X(k, i) = Sum + M(k);
    end
end