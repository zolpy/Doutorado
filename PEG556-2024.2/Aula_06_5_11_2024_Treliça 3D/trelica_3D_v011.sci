clear; clc
// Definição das propriedades do material e seção
E = 200e9;  // Módulo de elasticidade em Pa
A = %pi * (0.025^2)/4;  // Área da seção transversal em m²

// Coordenadas dos nós (x, y, z)
nodes = [
    0, 0, 0;      // Nó 1 (apoio)
    2, 0, 0;      // Nó 2 (apoio)
    0, 1, 0;      // Nó 3
    1, 1, 0;      // Nó 4
    2, 1, 0;      // Nó 5
    0.5, 0, 0;    // Nó 6
    1.5, 0, 0;    // Nó 7
];

// Conectividade dos elementos [nó_inicial, nó_final]
elements = [
    1, 3;    // Elemento 1
    1, 6;    // Elemento 2
    6, 3;    // Elemento 3
    6, 4;    // Elemento 4
    3, 4;    // Elemento 5
    4, 5;    // Elemento 6
    6, 7;    // Elemento 7
    7, 4;    // Elemento 8
    7, 5;    // Elemento 9
    7, 2;    // Elemento 10
    2, 5;    // Elemento 11
];

// Número de nós e elementos
n_nodes = size(nodes, 1);
n_elements = size(elements, 1);

// Matriz de rigidez global
K = zeros(3*n_nodes, 3*n_nodes);

// Montagem da matriz de rigidez global
for i = 1:n_elements
    // Nós do elemento atual
    node1 = elements(i,1);
    node2 = elements(i,2);
    
    // Coordenadas dos nós
    x1 = nodes(node1,1); y1 = nodes(node1,2); z1 = nodes(node1,3);
    x2 = nodes(node2,1); y2 = nodes(node2,2); z2 = nodes(node2,3);
    
    // Comprimento do elemento
    L = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
    
    // Cossenos diretores
    l = (x2-x1)/L;
    m = (y2-y1)/L;
    n = (z2-z1)/L;
    
    // Matriz de transformação
    T = [l m n 0 0 0;
         0 0 0 l m n];
    
    // Matriz de rigidez do elemento no sistema local
    k = (E*A/L) * [1 -1; -1 1];
    
    // Matriz de rigidez do elemento no sistema global
    ke = T' * k * T;
    
    // Índices para montagem
    idx1 = [3*node1-2:3*node1];
    idx2 = [3*node2-2:3*node2];
    idx = [idx1 idx2];
    
    // Soma à matriz global
    K(idx,idx) = K(idx,idx) + ke;
end

// Vetor de forças
F = zeros(3*n_nodes,1);

// Aplicação das cargas (10 kN = 10000 N)
F(3*4-2) = 0;     // Nó 4, direção x
F(3*4-1) = -10000; // Nó 4, direção y
F(3*4) = 0;       // Nó 4, direção z

F(3*6-2) = 0;     // Nó 6, direção x
F(3*6-1) = -10000; // Nó 6, direção y
F(3*6) = 0;       // Nó 6, direção z

F(3*7-2) = 0;     // Nó 7, direção x
F(3*7-1) = -10000; // Nó 7, direção y
F(3*7) = 0;       // Nó 7, direção z

// Condições de contorno (apoios)
fixed_dofs = [1:3, 4:6]; // Nós 1 e 2 fixos (todos os graus de liberdade)
free_dofs = setdiff(1:3*n_nodes, fixed_dofs);

// Resolução do sistema
U = zeros(3*n_nodes,1);
U(free_dofs) = K(free_dofs,free_dofs) \ F(free_dofs);

// Cálculo das tensões nos elementos
stresses = zeros(n_elements,1);
for i = 1:n_elements
    node1 = elements(i,1);
    node2 = elements(i,2);
    
    x1 = nodes(node1,1); y1 = nodes(node1,2); z1 = nodes(node1,3);
    x2 = nodes(node2,1); y2 = nodes(node2,2); z2 = nodes(node2,3);
    
    L = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
    
    l = (x2-x1)/L;
    m = (y2-y1)/L;
    n = (z2-z1)/L;
    
    // Deslocamentos nodais do elemento
    u1 = U(3*node1-2:3*node1);
    u2 = U(3*node2-2:3*node2);
    
    // Deformação axial
    epsilon = (l*u2(1) + m*u2(2) + n*u2(3) - l*u1(1) - m*u1(2) - n*u1(3))/L;
    
    // Tensão
    stresses(i) = E * epsilon;
end

// Plot da estrutura original e deformada
scf(1);
clf();

// Fator de escala para visualização dos deslocamentos
scale = 50;

// Plot da estrutura original
for i = 1:n_elements
    node1 = elements(i,1);
    node2 = elements(i,2);
    
    x = [nodes(node1,1); nodes(node2,1)];
    y = [nodes(node1,2); nodes(node2,2)];
    
    plot(x, y, 'b-', 'LineWidth', 2);
    if i == 1 then
        a = gca();
        a.tight_limits = "on";
        a.data_bounds = [min(nodes(:,1))-0.2, min(nodes(:,2))-0.2; max(nodes(:,1))+0.2, max(nodes(:,2))+0.2];
        xlabel('X (m)');
        ylabel('Y (m)');
        title('Estrutura Original (azul) e Deformada (vermelho)');
    end
end

// Plot da estrutura deformada
for i = 1:n_elements
    node1 = elements(i,1);
    node2 = elements(i,2);
    
    x = [nodes(node1,1) + scale*U(3*node1-2); nodes(node2,1) + scale*U(3*node2-2)];
    y = [nodes(node1,2) + scale*U(3*node1-1); nodes(node2,2) + scale*U(3*node2-1)];
    
    plot(x, y, 'r-', 'LineWidth', 1);
end

// Impressão das tensões
disp('Tensões nos elementos (MPa):');
for i = 1:n_elements
    printf('Elemento %d: %.2f MPa\n', i, stresses(i)/1e6);
end

// Impressão dos deslocamentos máximos
disp('Deslocamentos máximos:');
printf('X max: %.2f mm\n', max(abs(U(1:3:$)))*1000);
printf('Y max: %.2f mm\n', max(abs(U(2:3:$)))*1000);
printf('Z max: %.2f mm\n', max(abs(U(3:3:$)))*1000);
xgrid;
