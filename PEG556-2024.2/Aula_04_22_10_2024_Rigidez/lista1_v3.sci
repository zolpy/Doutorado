clear; clc

K1 = [200 -200; -200 200];
K2 = [100 -100; -100 100];
K3 = [150 -150; -150 150];
K4 = [300 -300; -300 300];
K5 = [400 -400; -400 400];
K6 = [500 -500; -500 500];
// Dados do problema (ajustar conforme necessário)
// Montagem da matriz de rigidez global (ajuste os índices de acordo com a conectividade)
K_global = [K1(1,1) K1(1,2) 0 0;
            K1(2,1) K1(2,2)+K2(1,1) K2(1,2) 0;
            0 K2(2,1) K2(2,2)+K3(1,1) K3(1,2);
            0 0 K3(2,1) K3(2,2)];
F = [400; 300; 500; 0; 0];
bc = [1 0 0 0 1];// Condições de contorno

// Reduzir o sistema
free_dofs = find(bc == 0);
K_reduced = K_global(free_dofs, free_dofs);
F_reduced = F(free_dofs);

// Resolver o sistema
U_reduced = inv(K_reduced) * F_reduced;

// Montar o vetor de deslocamentos completo
U = zeros(size(F));
U(free_dofs) = U_reduced;

// Exibir os resultados
disp("Deslocamentos:");
disp("Ub = ", U(2));
disp("Uc = ", U(3));
disp("Ud = ", U(4));
