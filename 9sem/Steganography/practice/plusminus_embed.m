function [CW] = plusminus_embed(C, b, seed)
  [N1, N2] = size(C);
  C = reshape(C, 1, N1 * N2);
  CW = C;
  Nb = length(b);
  if seed < 0
    ind = 1:Nb
  else
    %rng(seed);
    ind = randperm(N1 * N2, Nb);
  endif
  C1b = mod(C(ind), 2);
  notB = find(C1b ~= b);
  tmp = randi([0,1], 1, length(notB);
  CW(notB) = CW(notB) + (-1).^tmp;
  CW = reshape(CW, N1, N2);
endfunction
