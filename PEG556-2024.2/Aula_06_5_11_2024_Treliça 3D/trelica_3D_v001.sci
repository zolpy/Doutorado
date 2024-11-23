clear; clc
// Definindo constantes e propriedades do material
E = 200e9; // Módulo de elasticidade em Pascals (200 GPa)
A = %pi * (0.025)^2; // Área da seção transversal (25 mm de diâmetro)

// Definindo nós e conectividade dos elementos da treliça
nodes = [0 0; 1 0; 2 0; 0.5 1; 1.5 1; 1 2]; // Coordenadas dos nós (m)
elements = [1 2; 2 3; 1 4; 2 4; 2 5; 3 5; 4 5; 4 6; 5 6]; // Conectividade dos elementos

// Definindo as condições de contorno
loads = [0 -10000; 0 0; 0 0; 0 0; 0 -10000; 0 -10000]; // Cargas aplicadas (N)
fixed_dofs = [1 2 3]; // Graus de liberdade restritos (nós engastados)

// Função para calcular a matriz de rigidez de um elemento
function Ke = stiffness_matrix(E, A, node1, node2)
    L = norm(node2 - node1); // Comprimento do elemento
    c = (node2(1) - node1(1)) / L;
    s = (node2(2) - node1(2)) / L;
    Ke = (E * A / L) * [c^2 c*s -c^2 -c*s; c*s s^2 -c*s -s^2; -c^2 -c*s c^2 c*s; -c*s -s^2 c*s s^2];
endfunction

// Montando a matriz de rigidez global
n_dof = 2 * size(nodes, 1);
K_global = zeros(n_dof, n_dof);
for i = 1:size(elements, 1)
    node1 = nodes(elements(i, 1), :);
    node2 = nodes(elements(i, 2), :);
    Ke = stiffness_matrix(E, A, node1, node2);
    dofs = [2*elements(i, 1)-1, 2*elements(i, 1), 2*elements(i, 2)-1, 2*elements(i, 2)];
    K_global(dofs, dofs) = K_global(dofs, dofs) + Ke;
end

// Aplicando as condições de contorno
free_dofs = setdiff(1:n_dof, fixed_dofs);
K_ff = K_global(free_dofs, free_dofs);
F = loads(:); // Vetor de forças
Ff = F(free_dofs);

// Calculando os deslocamentos
U = zeros(n_dof, 1);
U(free_dofs) = K_ff \ Ff;

// Calculando as tensões nos elementos
stress = zeros(size(elements, 1), 1);
for i = 1:size(elements, 1)
    node1 = nodes(elements(i, 1), :);
    node2 = nodes(elements(i, 2), :);
    L = norm(node2 - node1);
    c = (node2(1) - node1(1)) / L;
    s = (node2(2) - node1(2)) / L;
    dofs = [2*elements(i, 1)-1, 2*elements(i, 1), 2*elements(i, 2)-1, 2*elements(i, 2)];
    u_elem = U(dofs);
    stress(i) = (E / L) * [-c -s c s] * u_elem;
end

// Exibindo resultados
disp("Deslocamentos nos nós:");
disp(U);

disp("Tensões nos elementos (Pa):");
disp(stress);

// Plotando os deslocamentos
clf();
for i = 1:size(elements, 1)
    node1 = nodes(elements(i, 1), :);
    node2 = nodes(elements(i, 2), :);
    plot([node1(1), node2(1)], [node1(2), node2(2)], "k-"); // Elementos originais
    node1_disp = node1 + U(2*elements(i, 1)-1:2*elements(i, 1))';
    node2_disp = node2 + U(2*elements(i, 2)-1:2*elements(i, 2))';
    plot([node1_disp(1), node2_disp(1)], [node1_disp(2), node2_disp(2)], "r--"); // Elementos deslocados
end
title("Deformação da Treliça");
xlabel("x (m)");
ylabel("y (m)");
legend(["Posição Original", "Posição Deformada"]);
xgrid(1);
