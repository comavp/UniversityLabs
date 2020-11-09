function d = diskFunc( x, p_x, p )
    n = length(p_x);
    s = log(p);
    for i=1:n
        s = s + log(1-p_x(i));
    end
    v = 0;
    for i=1:n
        v = v + x(i) * log(p_x(i)/(1-p_x(i)));
    end
    d = s + v;
end