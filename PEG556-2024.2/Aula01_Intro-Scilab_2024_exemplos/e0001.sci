clear; clc
// Definindo os vetores A, B, X e Y
A = [2 3 4 6 7];
B = [1 6 3];
X = [1; 2; 3; 4; 5];  // X é um vetor coluna
Y = [2; 4; 6; 8; 10];  // Y é um vetor coluna

// a) Encontrar os elementos de A que não estão em B
diferenca = setdiff(A, B);
disp("Elementos de A que não estão em B:");
disp(diferenca);

// b) Calcular Z = X + Y
Z = X + Y;
disp("Vetor Z:");
disp(Z);

// c) Calcular W1 = A*X e W2 = Y*A
W1 = A * X;
disp("W1 = A*X:");
disp(W1);

W2 = Y * A;
disp("W2 = Y*A:");
disp(W2);

// d) Calcular as transposições de A e B
A_transp = A';
B_transp = B';
disp("Transposição de A:");
disp(A_transp);
disp("Transposição de B:");
disp(B_transp);

// e) Calcular Z1 = X*Y' e Z2 = X'*Y
Z1 = X * Y';  // Multiplicação de X por Y transposto
Z2 = X' * Y;  // Multiplicação de X transposto por Y

disp("Z1 = X * Y(linha):");
disp(Z1);
disp("Z2 = X(Linha) * Y:");
disp(Z2);
