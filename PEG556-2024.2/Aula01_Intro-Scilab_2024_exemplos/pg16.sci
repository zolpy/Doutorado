clear; clc

// Matriz inicial
A = [2 4 6; 8 10 12; 1 2 3];

// Atribui zeros à terceira linha
A(3,:) = [0 0 0];  // Isto deve alterar apenas a terceira linha
disp('Matriz A após atribuir zeros à terceira linha:');
disp(A);
disp(' ');
//--------------------------------
A(2,:) = A(2,:) * 10;  // Multiplica a segunda linha por 10
disp('Matriz A após multiplicar a segunda linha por 10:');
disp(A);
disp(' ');
//--------------------------------
A(3,:) = [];  // Remove a terceira linha
disp('Matriz A após remover a terceira linha:');
disp(A);
disp(' ');
//--------------------------------
B = [4 6 8];  // Definir o vetor B
A = [A; B];  // Adiciona o vetor B como nova linha
disp('Matriz A após adicionar o vetor B como última linha:');
disp(A);
