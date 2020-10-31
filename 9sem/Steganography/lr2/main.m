clc;
close all;
clear;

T = 128;
T1 = 64;
T2 = 192;
% ���� Jarvis
h = (1/48) * [0 0 0 7 5; 3 5 7 5 3; 1 3 5 3 1];

C = imread('lena.tif');
%C = imread('guts.jpg');
figure; imshow(C); title('�������� �����������');

Cb = getBinImageByErrorDiffusionAlg(C, h, T);
figure; imshow(Cb); title('�������������� �����������');

W = imread('ornament.tif');
figure; imshow(W); title('������������ ����������');

CW = hideInformationByConjugateErrorDiffusionAlg(C, Cb, W, h, T1, T2);
figure; imshow(CW); title('����������� �� ���������� �����������');

WR = getHidingInformation(CW, Cb);
figure; imshow(WR); title('����������� ����������');