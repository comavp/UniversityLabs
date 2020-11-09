clear;
clc;
close all;

N = 200;

% Получение данных из ЛР1
data =  load('C:\MRO\lr2\data\letter1.mat', 'l1'); binVec1 = data.l1;
data = load('C:\MRO\lr2\data\letter2.mat', 'l2'); binVec2 = data.l2;

letter1 = [0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.3 0.3 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7];
letter2 = [0.7 0.7 0.7 0.7 0.7 0. 0.7 0.7 0.7 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3];

mLetter1 = sum(sum(log((letter1 ./ (1 - letter1)) .* ((1 - letter2) ./ (letter2))) .* letter2));
mLetter2 = sum(sum(log((letter1 ./ (1 - letter1)) .* ((1 - letter2) ./ (letter2))) .* letter1));

dLetter1 = sum(sum(log((letter1 ./ (1 - letter1)) .* ((1 - letter2) ./ (letter2))) .^ 2 .* letter2 .* (1 - letter2)));
dLetter2 = sum(sum(log((letter1 ./ (1 - letter1)) .* ((1 - letter2) ./ (letter2))) .^ 2 .* letter1 .* (1 - letter1)));

analyticProbabilityOfMisclassification1 = 0.5-erf((-mLetter1/sqrt(dLetter1))/sqrt(2))/2;
analyticProbabilityOfMisclassification2 = 0.5+erf((-mLetter2/sqrt(dLetter2))/sqrt(2))/2;

experimentallyProbabilityOfMisclassification1 = 0;
for i=1:N   
   experimentallyProbabilityOfMisclassification1 = experimentallyProbabilityOfMisclassification1+1-heaviside(diskFunc(binVec2(:, i), letter2, 1/2) - diskFunc(binVec2(:, i), letter1, 1/2));  
end
experimentallyProbabilityOfMisclassification1 = experimentallyProbabilityOfMisclassification1/N;
experimentallyProbabilityOfMisclassification2 = 0;
for i=1:N   
   experimentallyProbabilityOfMisclassification2 = experimentallyProbabilityOfMisclassification2+1-heaviside(diskFunc(binVec1(:, i), letter1, 1/2) - diskFunc(binVec1(:, i), letter2, 1/2)); 
end
experimentallyProbabilityOfMisclassification2 = experimentallyProbabilityOfMisclassification2/N;

disp('Аналитически:');
fprintf('Вероятность ошибочной классификации 1 =  %.4f \n', double(analyticProbabilityOfMisclassification1));
fprintf('Вероятность ошибочной классификации 2 =  %.4f \n', double(analyticProbabilityOfMisclassification2));
disp('Экспериментально:');
fprintf('Вероятность ошибочной классификации 1 =  %.4f \n', double(experimentallyProbabilityOfMisclassification1));
fprintf('Вероятность ошибочной классификации 2 =  %.4f \n', double(experimentallyProbabilityOfMisclassification2));

%Погрешность оценок
error1=sqrt((1-experimentallyProbabilityOfMisclassification1)/(N*experimentallyProbabilityOfMisclassification1));
fprintf('Погрешность 1 =  %.4f \n', double(error1));
error2=sqrt((1-experimentallyProbabilityOfMisclassification2)/(N*experimentallyProbabilityOfMisclassification2));
fprintf('Погрешность 2 =  %.4f \n', double(error2));

%Теоретический размер выборки
eps = 0.05;
Neps = (experimentallyProbabilityOfMisclassification1*(1-experimentallyProbabilityOfMisclassification1))/(experimentallyProbabilityOfMisclassification1^2*eps^2);
Neps = round(Neps);
fprintf('Размер выборки =  %d \n', Neps);
