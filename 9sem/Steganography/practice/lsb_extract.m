function [bR] = lsb_extract(CW, Nb, seed)
  [N1 N2] = size(CW);
  CW = reshape(CW, 1, N1*N2);
  if seed < 0
    bR = mod(CW(1:Nb), 2);
  endif
endfunction
