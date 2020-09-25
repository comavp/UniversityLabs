function W_R = qimExtract(C_W, delta)
  tmp = rem(C_W, 2*delta);
  [a b] = size(C_W);
  W_R = zeros(a, b);
  W_R(tmp >= delta) = 1;
end