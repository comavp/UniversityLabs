function [X] = generateRandomVectors(n, N, M, B)
  
A = zeros(2, 2);
A(1, 1) = sqrt(B(1, 1));
A(1, 2) = 0;
A(2, 1) = B(1, 2) / sqrt(B(1, 1));
A(2, 2) = sqrt(B(2, 2) - B(1, 2)^2/B(1, 1));

E = zeros(n, N);
X = zeros(n, N);

for l=1:n
    for i=1:N
        for j=1:12
            E(l, i) = E(l, i) + (rand() - 0.5);
        end
    end
end

for k=1:n
    for i=1:N
        Sum = 0;
        for l=1:2
            Sum = Sum + A(k, l) * E(l, i);
        end
        X(k, i) = Sum + M(k);
    end
end

end
