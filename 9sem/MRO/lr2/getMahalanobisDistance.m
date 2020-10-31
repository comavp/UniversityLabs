function [distance] = getMahalanobisDistance(M1, M2, B)

distance = (M2-M1)'*inv(B)*(M2-M1);

end