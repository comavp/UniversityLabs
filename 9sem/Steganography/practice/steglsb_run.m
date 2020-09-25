clc;
clear;
close all;

C = imread('goldhill.tif');
seed = -2;
b = randi([0,1], 1, 10000);

CW = lsb_embed(C, b, seed);

bR = lsb_extract(CW, length(b), seed);

assert(uint8(b), bR);

seed = 1;
CW = lsb_embed(C, length(b), seed);

plusminus_embed(C, b, seed);
