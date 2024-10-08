clear; clc
// Definindo as matrizes A e B
A = [1 2 3; 4 5 6];  // A é 2x3
B = [7; 8; 9];       // B é 3x1

// a) Calcular A * B (2x3 * 3x1 é possível)
resultado1 = A * B;  
disp('Resultado de A * B:');
disp(resultado1);
disp(' ');  // Linha em branco

// b) Calcular B' * A(1,:)
resultado2 = B' * A(1,:)';  // Multiplicação de B' (1x3) com A(1,:) (1x3)
disp('Resultado de B'' * A(1,:)'':');
disp(resultado2);
disp(' ');  // Linha em branco

// c) Calcular A * zeros(dimensão de A')
// Corrigir a multiplicação A * zeros para garantir dimensões corretas (A é 2x3)
dim_A = size(A);  // Dimensão de A
resultado3 = A * zeros(dim_A(2), dim_A(1));  // Multiplicando A (2x3) por zeros(3x2)
disp('Resultado de A * zeros(dimension of A''):');
disp(resultado3);
disp(' ');  // Linha em branco


// d) Calcular A' * ones(dimensão de A)
dim_A = size(A);  // Obtendo a dimensão de A
resultado4 = A' * ones(dim_A(1), dim_A(2));  // Multiplicação de A' (3x2) com ones(2x3)
disp('Resultado de A'' * ones(dimension of A):');
disp(resultado4);
disp(' ');  // Linha em branco

// e) Calcular A * ones(dimension of A') + Identidade(2)
// Corrigir a multiplicação de A * ones para garantir dimensões corretas
dim_A = size(A);  // Dimensão de A
resultado5 = A * ones(dim_A(2), dim_A(1)) + eye(2, 2);  // A (2x3) e ones(3x2)
disp('Resultado de A * ones(dimension of A'') + Identity(2):');
disp(resultado5);
disp(' ');  // Linha em branco


