
clear; clc
// Definindo o vetor F e a matriz K
F = [400; 300; 500];
K = [750 -250 -300; -250 650 -400; -300 -400 1200];

// Calculando u, onde u = inv(K) * F
u = inv(K) * F;

// Exibindo o resultado
disp("Vetor u:", u)
