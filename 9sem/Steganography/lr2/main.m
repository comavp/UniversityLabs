clc;
close all;
clear;

T = 128;
T1 = 64;
T2 = 192;
% Ядро Jarvis
h = (1/48) * [0 0 0 7 5; 3 5 7 5 3; 1 3 5 3 1];

C = imread('lena.tif');
%C = imread('guts.jpg');
figure; imshow(C); title('Исходное изображение');

Cb = getBinImageByErrorDiffusionAlg(C, h, T);
figure; imshow(Cb); title('Растрированное изображение');

W = imread('ornament.tif');
figure; imshow(W); title('Встраиваемая информация');

CW = hideInformationByConjugateErrorDiffusionAlg(C, Cb, W, h, T1, T2);
figure; imshow(CW); title('Изображение со встроенной информацией');

WR = getHidingInformation(CW, Cb);
figure; imshow(WR); title('Извлеченная информация');