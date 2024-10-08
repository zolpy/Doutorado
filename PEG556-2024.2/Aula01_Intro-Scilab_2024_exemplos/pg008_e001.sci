clear; clc;
// a) Criar um vetor linha (A) com 10 elementos iguais a zero
A = zeros(1, 10);
disp("Vetor A:");
disp(A);

// b) Criar um vetor coluna (B) com 5 elementos iguais a um
B = ones(5, 1);
disp("Vetor B:");
disp(B);

// c) Criar um vetor linha (C) com 10 inteiros aleatórios entre 0 e 100
C = grand(1, 10, "uin", 0, 100);
disp("Vetor C:");
disp(C);
