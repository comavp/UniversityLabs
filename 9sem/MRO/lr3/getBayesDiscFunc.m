function syms_db = getBayesDiscFunc( m1, b1, m2, b2, p1, p2 )
syms sysm_db(x, y);
syms_db(x, y) = [x,y]*(inv(b2)-inv(b1))*[x;y] + 2*(m1'*inv(b1)-m2'*inv(b2))*[x;y] + log(norm(b1)/norm(b2))+2*log(p1/p2)-m1'*inv(b1)*m1+m2'*inv(b2)*m2;
end
