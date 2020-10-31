%Случай двух классов (равные корреляционные матрицы)
M1=[-1; 1];
M2=[ 0; -1];
R1 = [1 0.1; 0.1 0.3];
R2 = R1;

p = 20;
N = 200;

fileData = load('data_equal_1');
X1 = fileData.X1;
fileData = load('data_equal_2');
X2 = fileData.X2;

%Байесовская дискриминантная функция
d = 0.5*(M2-M1)'*inv(R1)*(M2-M1);
v = (M2-M1)'*inv(R1);

syms y0 y1
d12(y0, y1) = v(1)*y0 + v(2)*y1 - d;

%Дискриминантная функция Неймана-Пирсона
p0dat = 0.05;
c = 1.645;
p = 20;

%lambda = -0.5*p + c*sqrt(p);
%syms y0 y1
%d12NP(y0, y1) = v(1)*y0 + v(2)*y1 - d - lambda;

%Отображение
for i=1:N
    X(1, i) = -3 + 6*i/N;
    X(2, i) = (d - v(2)*X(1, i)) / v(1);
    %XNP(2, i) = (d - lambda - v(2)*X(1, i)) / v(1);
end

figure
scatter(X1(1, :),X1(2, :), 10, 'red', 'fill');
hold on
scatter(X2(1, :),X2(2, :), 10, 'blue', 'fill');
hold on
scatter(X(1, :),X(2, :), 5, 'green', 'fill');
hold on
%scatter(X(1, :),XNP(2, :), 1, 'red', 'fill');
xlim([-5 5])
ylim([-5 5])

%Вероятность Байесовской классификации
p = 20;
lambda = 0;

t = (0.5*p + lambda)/sqrt(p);
p1 = 1 - (1 + erf(t/sqrt(2)))/2;

t = (-0.5*p + lambda)/sqrt(p);
p2 = (1 + erf(t/sqrt(2)))/2;

pp = (p1 + p2)/2;

%Оценка вероятностей
p1est = 0;
for i=1:N
   p1est = p1est + heaviside(d12(X1(1,i), X1(2,i))); 
end
p1est = p1est / N;

p2est = 0;
for i=1:N
   p2est = p2est + 1 - heaviside(d12(X2(1,i), X2(2,i))); 
end
p2est = p2est / N;

%Теоретический размер выборки
eps = 0.05;
Neps = (p1est*(1-p1est))/(p1est^2*eps^2);




