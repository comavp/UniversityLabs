function [WR] = getHidingInformation(CW, Cb)

WR = xor(CW, Cb);