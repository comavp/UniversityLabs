function [CW] = lsb_embed(C, b, seed)
  [N1, N2] = size(C);
  C = reshape(C, 1, N1 * N2);
  CW = C;
  Nb = length(b);
  if seed < 0
    CW(1:Nb) = C(1:Nb) - mod(C(1:Nb), 2) + b;
  else
    rng(seed);
    ind = randperm(N1 * N2, Nb);
    CW(ind) = C(ind) - mod(C(ind), 2) + b;
  endif
  CW = reshape(CW, N1, N2);
endfunction
