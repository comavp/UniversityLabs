function [distance] = getBhattacharyyaDistance(M1, M2, B1, B2)

distance = (1/4)*(M2 - M1)'*inv((B2+B1)/2)*(M2 - M1)+(1/2)*log(det((B2+B1)/2)/sqrt(det(B2)*det(B1)));
                    
end
