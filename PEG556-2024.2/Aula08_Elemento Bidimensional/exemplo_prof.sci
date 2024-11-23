// Limpeza de variáveis e da tela
clear; clc;

// Inicialização da matriz de rigidez local
k = ones(6, 6); // Matriz de rigidez 6x6 com elementos iguais a 1

// Índices para a montagem da matriz de rigidez global
i = [1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 5 6 6 6 6 6 6];
j = [1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6];

// Primeira submatriz de rigidez global
k1 = sparse([i(:), j(:)], k, [10, 10]);

// Definindo os graus de liberdade para a segunda submatriz
v1 = [i(1:12), i(13:36) + 2];
v2 = [j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2];
k2 = sparse([v1(:), v2(:)], k, [10, 10]);

// Definindo os graus de liberdade para a terceira submatriz
v1 = i + 4;
v2 = j + 4;
k3 = sparse([v1(:), v2(:)], k, [10, 10]);

// Montagem da matriz de rigidez global
k_g = k1 + k2 + k3;

mprintf("\n Matriz k1\n")
k1 = full(k1)
disp(k1)
mprintf("\n")

mprintf("\n Matriz k2\n")
k2 = full(k2)
disp(k2)
mprintf("\n")

mprintf("\n Matriz k3\n")
k3 = full(k3)
disp(k3)
mprintf("\n")

mprintf("\n Matriz k_g\n")
k_g1 = full(k_g)
disp(k_g1)
mprintf("\n")

// Restrições de graus de liberdade (DoFs) 3, 4 e 10
k_g(10, :) = []; // Remove a linha 10
k_g(:, 10) = []; // Remove a coluna 10
k_g(3:4, :) = []; // Remove as linhas 3 e 4
k_g(:, 3:4) = []; // Remove as colunas 3 e 4

// Exibindo a matriz de rigidez global reduzida
//disp(k_g, "Matriz de Rigidez Global com DoFs Restritos:");
//disp(full(k_g))

mprintf("\n Matriz k_g\n")
k_g2 = full(k_g)
disp(k_g2)
mprintf("\n")

//mprintf("\n")
//disp(k_g1, "Matriz de Rigidez Global com DoFs Restritos:");
