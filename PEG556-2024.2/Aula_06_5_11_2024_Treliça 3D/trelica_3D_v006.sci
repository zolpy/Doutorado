clear; clc
// Código para análise 3D de treliça usando MEF
// Propriedades do material e geometria
E = 200e9;  // Módulo de elasticidade em Pa
d = 0.025;  // Diâmetro em m
A = %pi * (d^2) / 4;  // Área da seção transversal

// Coordenadas dos nós (x, y, z)
nodes = [
    0, 0, 0;    // 1
    1, 0, 0;    // 2
    2, 0, 0;    // 3
    0, 1, 0;    // 4
    1, 1, 0;    // 5
    2, 1, 0;    // 6
    0, 0, 1;    // 7
    1, 0, 1;    // 8
    2, 0, 1;    // 9
    0, 1, 1;    // 10
    1, 1, 1;    // 11
    2, 1, 1     // 12
];

// Conectividade dos elementos [nó_inicial, nó_final]
elements = [
    // Base inferior
    1, 2; 2, 3; 4, 5; 5, 6;
    1, 4; 2, 5; 3, 6;
    // Base superior
    7, 8; 8, 9; 10, 11; 11, 12;
    7, 10; 8, 11; 9, 12;
    // Elementos verticais
    1, 7; 2, 8; 3, 9; 4, 10; 5, 11; 6, 12;
    // Elementos diagonais
    1, 8; 2, 7; 2, 9; 3, 8;
    4, 11; 5, 10; 5, 12; 6, 11
];

// Número de nós e elementos
n_nodes = size(nodes, 1);
n_elements = size(elements, 1);

// Matriz de rigidez global
K = zeros(3*n_nodes, 3*n_nodes);

// Montagem da matriz de rigidez global
for e = 1:n_elements
    // Nós do elemento atual
    node1 = elements(e,1);
    node2 = elements(e,2);
    
    // Coordenadas
    x1 = nodes(node1,1); y1 = nodes(node1,2); z1 = nodes(node1,3);
    x2 = nodes(node2,1); y2 = nodes(node2,2); z2 = nodes(node2,3);
    
    // Comprimento do elemento
    L = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
    
    // Cossenos diretores
    cx = (x2-x1)/L;
    cy = (y2-y1)/L;
    cz = (z2-z1)/L;
    
    // Matriz de transformação
    T = [
        cx, cy, cz, 0, 0, 0;
        0, 0, 0, cx, cy, cz
    ];
    
    // Matriz de rigidez do elemento no sistema local
    ke_local = (E*A/L) * [1, -1; -1, 1];
    
    // Matriz de rigidez do elemento no sistema global
    ke = T' * ke_local * T;
    
    // Mapeamento dos graus de liberdade
    dofs = [
        3*node1-2; 3*node1-1; 3*node1;
        3*node2-2; 3*node2-1; 3*node2
    ];
    
    // Montagem na matriz global
    K(dofs,dofs) = K(dofs,dofs) + ke;
end

// Vetor de forças
F = zeros(3*n_nodes,1);
// Aplicação das cargas verticais de 10kN
load_nodes = [2, 3, 4, 5, 6];  // Nós onde as cargas são aplicadas
for i = load_nodes
    F(3*i) = -10000;  // Força na direção z
end

// Condições de contorno
// Engaste no primeiro nó (todos os graus de liberdade restritos)
fixed_dofs = [1; 2; 3];
free_dofs = setdiff(1:3*n_nodes, fixed_dofs);

// Resolução do sistema
U = zeros(3*n_nodes,1);
U(free_dofs) = K(free_dofs,free_dofs)\F(free_dofs);

// Cálculo das tensões nos elementos
stresses = zeros(n_elements,1);
for e = 1:n_elements
    node1 = elements(e,1);
    node2 = elements(e,2);
    
    // Coordenadas
    x1 = nodes(node1,1); y1 = nodes(node1,2); z1 = nodes(node1,3);
    x2 = nodes(node2,1); y2 = nodes(node2,2); z2 = nodes(node2,3);
    
    L = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
    
    // Cossenos diretores
    cx = (x2-x1)/L;
    cy = (y2-y1)/L;
    cz = (z2-z1)/L;
    
    // Deslocamentos nos nós do elemento
    u1 = U(3*node1-2); v1 = U(3*node1-1); w1 = U(3*node1);
    u2 = U(3*node2-2); v2 = U(3*node2-1); w2 = U(3*node2);
    
    // Deformação axial
    epsilon = (cx*(u2-u1) + cy*(v2-v1) + cz*(w2-w1))/L;
    
    // Tensão
    stresses(e) = E * epsilon;
end

// Plotagem da estrutura
scf();
subplot(211);
// Estrutura original
for e = 1:n_elements
    node1 = elements(e,1);
    node2 = elements(e,2);
    plot3d([nodes(node1,1), nodes(node2,1)], ...
           [nodes(node1,2), nodes(node2,2)], ...
           [nodes(node1,3), nodes(node2,3)]);
end
title('Estrutura Original');

subplot(212);
// Estrutura deformada
factor = 100;  // Fator de escala para visualização
for e = 1:n_elements
    node1 = elements(e,1);
    node2 = elements(e,2);
    
    // Coordenadas deformadas
    x1_def = nodes(node1,1) + U(3*node1-2)*factor;
    y1_def = nodes(node1,2) + U(3*node1-1)*factor;
    z1_def = nodes(node1,3) + U(3*node1)*factor;
    
    x2_def = nodes(node2,1) + U(3*node2-2)*factor;
    y2_def = nodes(node2,2) + U(3*node2-1)*factor;
    z2_def = nodes(node2,3) + U(3*node2)*factor;
    
    plot3d([x1_def, x2_def], [y1_def, y2_def], [z1_def, z2_def]);
end
title('Estrutura Deformada (fator de escala = 100)');
