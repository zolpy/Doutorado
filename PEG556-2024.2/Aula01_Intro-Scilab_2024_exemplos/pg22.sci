// Limpar variáveis e limpar console
clear; clc;

// Definir a matriz dos coeficientes
A = [2 3 3; 4 3 2; 3 7 9];

// Definir o vetor das constantes
B = [2; 1; 5];

// Resolver o sistema linear Ax = B
X = A \ B; // Usar a operação de divisão para resolver o sistema

// Exibir a solução
disp('Solução do sistema (x, y, z):');
disp(X);
