clc;
clear;
close all;

layer = 3;
delta = 8;

C = imread('goldhill.tif');
W = imread('ornament.tif');
printTwoImages('�������� ������', C, W, '����������� �����������', '������������ �����������');

% ���-1
C_W = lsbEmbed(C, W, layer);
W_R = lsbExtract(C_W, C, layer);
printTwoImages('���-1', C_W, W_R, '����������� �� ���������� ���������', '��������������� �����������');

% ���-4
noise = randi(delta - 1, size(C));;
C_W = floor(double(C)./(2*delta)).*(2*delta) + double(W).*delta + noise;
W_R = C_W - noise - floor(double(C)./(2*delta)).*(2*delta);
W_R = W_R*255/delta;
printTwoImages('���-4', uint8(C_W), uint8(W_R), '����������� �� ���������� ���������', '��������������� �����������');

W_R_another1 = C_W - noise;
W_R_another1 = W_R_another1 / delta;
W_R_another1 = rem(W_R_another1, 2);

W_R_another2 = qimExtract(C_W, delta);

printTwoImages('���-4 (������ �������� ��������������)', uint8(W_R_another1*255), uint8(W_R_another2*255), 'Another1', 'Another2');

clear;
                