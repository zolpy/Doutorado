clear, clc
// Código para análise da treliça triangular usando MEF
// Propriedades do material e geometria
E = 200e9;  // Módulo de elasticidade em Pa
d = 0.025;  // Diâmetro em m
A = %pi * (d^2) / 4;  // Área da seção transversal

// Coordenadas dos nós (x, y, z)
nodes = [
    0, 0, 0;      // 1 (base esquerda)
    1, 0, 0;      // 2 (base meio-esquerda)
    2, 0, 0;      // 3 (base meio-direita)
    3, 0, 0;      // 4 (base direita)
    0, 0, 1;      // 5 (topo esquerdo)
    1, 0, 1;      // 6 (topo meio-esquerdo)
    2, 0, 1;      // 7 (topo meio-direito)
    3, 0, 1;      // 8 (topo direito)
    0.5, 1, 0.5;  // 9  (ponto central esquerdo)
    1.5, 1, 0.5;  // 10 (ponto central meio)
    2.5, 1, 0.5   // 11 (ponto central direito)
];

// Conectividade dos elementos [nó_inicial, nó_final]
elements = [
    // Base horizontal
    1, 2; 2, 3; 3, 4;
    // Topo horizontal
    5, 6; 6, 7; 7, 8;
    // Verticais
    1, 5; 2, 6; 3, 7; 4, 8;
    // Diagonais frontais
    1, 6; 2, 7; 3, 8;
    5, 2; 6, 3; 7, 4;
    // Conexões centrais
    1, 9; 2, 9; 3, 10; 4, 10;
    5, 9; 6, 9; 7, 10; 8, 10;
    9, 10; 10, 11
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
load_nodes = [2, 3, 9, 10, 11];  // Nós onde as cargas são aplicadas
for i = load_nodes
    F(3*i-1) = -10000;  // Força na direção y (vertical)
end

// Condições de contorno
// Engaste nos apoios (nós 1 e 4)
fixed_dofs = [1:3, 10:12];  // Restringe todos os graus de liberdade dos nós 1 e 4
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
           [nodes(node1,3), nodes(node2,3)], 'b-');
end
title('Estrutura Original');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

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
    
    plot3d([x1_def, x2_def], [y1_def, y2_def], [z1_def, z2_def], 'r-');
end
title('Estrutura Deformada (fator de escala = 100)');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
