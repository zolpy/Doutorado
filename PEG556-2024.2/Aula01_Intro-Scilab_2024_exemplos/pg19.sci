clear;clc
// Gerar duas matrizes aleatórias A e B de ordem 5, com elementos variando de 1 a 10
A = grand(5, 5, 'uin', 1, 10);  // Matriz A com números inteiros aleatórios entre 1 e 10
B = grand(5, 5, 'uin', 1, 10);  // Matriz B com números inteiros aleatórios entre 1 e 10

// Exibir as matrizes A e B
disp('Matriz A:');
disp(A);
disp('Matriz B:');
disp(B);

// Cálculo de C = A + B
C = A + B;
disp('Matriz C (A + B):');
disp(C);

// Cálculo de D = A * B'
D = A * B';
disp('Matriz D (A * B''):');
disp(D);

// Cálculo de E = 10 * A + 5 * B
E = 10 * A + 5 * B;
disp('Matriz E (10 * A + 5 * B):');
disp(E);

// Cálculo de F = det(A) - det(B)
det_A = det(A);  // Determinante de A
det_B = det(B);  // Determinante de B
F = det_A - det_B;
disp('Resultado de F (det(A) - det(B)):');
disp(F);
