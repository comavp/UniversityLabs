function [CW] = hideInformationByConjugateErrorDiffusionAlg(C, Cb, W, h, T1, T2)
% Pull-model

[N1, N2] = size(C);
[M1, M2] = size(h);
Ctmp = zeros(N1+2, N2+4);
Ctmp(1:N1, 3:N2+2) = C;
e = zeros(size(Ctmp));
u = zeros(size(Ctmp));

for n1 = 3:N1+2
    for n2 = 3:N2+2
        u(n1, n2) = Ctmp(n1, n2);
        for m1 = 1:M1
            for m2 = 1:M2
                u(n1, n2) = u(n1, n2) - h(m1, m2)*e(n1-m1+1, n2-m2+3);
            end
        end        
        if ((u(n1, n2) >= T1) && (xor(W(n1-2, n2-2), Cb(n1-2, n2-2) == 1)))
            CW(n1, n2) = 1;
        elseif ((u(n1, n2) < T1) && (xor(W(n1-2, n2-2), Cb(n1-2, n2-2) == 1)))
            CW(n1, n2) = 0;
        elseif((u(n1, n2) >= T2) && (xor(W(n1-2, n2-2), Cb(n1-2, n2-2) == 0)))
            CW(n1, n2) = 1;
        elseif((u(n1, n2) < T2) && (xor(W(n1-2, n2-2), Cb(n1-2, n2-2) == 0)))
            CW(n1, n2) = 0;
        end
        e(n1, n2) = 255 * CW(n1, n2) - u(n1, n2);
    end
end
CW = CW(3:N1+2, 3:N2+2);