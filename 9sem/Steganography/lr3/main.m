clear;
clc;
close all;

imageName = 'peppers.pgm';
coxImageName = 'cox_peppers.pgm';
algName = 'cox';
pathToLibrary = 'watermarking_library\';
pathToData = 'data\';

Embed(imageName, coxImageName, algName, pathToLibrary, pathToData);
Extract(imageName, coxImageName, algName, pathToLibrary, pathToData);

originalImage = double(imread([pathToData imageName]));
coxImage = double(imread([pathToData coxImageName]));

[cmpResults, parameters] = cropImageWithDataReplacement(coxImage, originalImage);
figure('Name', 'Обрезка с заменой данными из исходного контейнера', 'NumberTitle', 'off');
plot(parameters, cmpResults, 'black-o');
title('Зависимость от доли вырезаемой площади');

[cmpResults, parameters] = addGaussianBlur(coxImage);
figure('Name', 'Гауссовское размытие', 'NumberTitle', 'off');
plot(parameters, cmpResults, 'g-o');
title('Зависимость от среднеквадритичного отклонения');

[cmpResults, parameters] = sharpening(coxImage);
figure('Name', 'Повышение резкости', 'NumberTitle', 'off');
plot(parameters, cmpResults, 'b-o');
title('Зависимость от размера окна');
 
[cmpResults, parameters] = addNoise(coxImage);
figure('Name', 'Аддитивное зашумление', 'NumberTitle', 'off');
plot(parameters, cmpResults, 'r-o');
title('Зависимость от дисперсии шума');