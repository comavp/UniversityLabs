function C_W = lsbEmbed(C, W, layer)
  tmp = bitget(C, layer);
  tmp = bitxor(tmp, W);
  C_W = bitset(C, layer, tmp);
end
