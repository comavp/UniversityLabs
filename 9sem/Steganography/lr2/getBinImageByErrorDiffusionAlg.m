function [Cb] = getBinImageByErrorDiffusionAlg(C, h, T)
% Push-model

[N1, N2] = size(C);
[M1, M2] = size(h);
Ctmp = zeros(N1+2, N2+4);
Ctmp(1:N1, 3:N2+2) = C;
Cb = zeros(size(Ctmp));
u = Ctmp;

for n1 = 1:N1
    for n2 = 3:N2+2
        if u(n1, n2) >= T
            Cb(n1, n2) = 1;
        else
            Cb(n1, n2) = 0;
        end
        e = 255 * Cb(n1, n2) - u(n1, n2);
        for m1 = 1:M1
            for m2 = 1:M2
                u(n1+m1-1, n2+m2-3) =  u(n1+m1-1, n2+m2-3) - e*h(m1, m2);
            end
        end
    end
end

Cb = Cb(3:N1+2, 3:N2+2);