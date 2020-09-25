function W_R = lsbExtract(C_W, C, layer)
  tmp = bitxor(C_W, C);
  W_R = bitget(tmp, layer);
end
