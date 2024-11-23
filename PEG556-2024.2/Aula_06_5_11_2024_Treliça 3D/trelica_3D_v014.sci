clear; clc
// Parâmetros do material e geometria
E = 200e9;  // Módulo de elasticidade (Pa)
d = 0.025;  // Diâmetro das barras (m)
A = %pi * (d^2) / 4;  // Área da seção transversal das barras (m²)

// Coordenadas dos nós (x, y, z)
nodes = [
    0, 0, 0;    // 1 (base esquerda)
    2, 0, 0;    // 2 (base direita)
    1, 1, 0;    // 3 (topo frontal)
    0, 0, 2;    // 4 (base esquerda traseira)
    2, 0, 2;    // 5 (base direita traseira)
    1, 1, 2;    // 6 (topo traseiro)
    1, 0, 0;    // 7 (meio base frontal)
    1, 0, 2;    // 8 (meio base traseira)
];

// Conexões entre os nós (elementos)
elements = [
    1, 7; 7, 2;   // Base frontal
    1, 3; 2, 3;   // Laterais frontais
    7, 3;         // Vertical meio frontal
    4, 8; 8, 5;   // Base traseira
    4, 6; 5, 6;   // Laterais traseiras
    8, 6;         // Vertical meio traseiro
    1, 4;         // Lateral esquerda
    2, 5;         // Lateral direita
    3, 6;         // Topo entre frentes
    7, 8;         // Meio entre frentes
    1, 8; 7, 4;   // Diagonais esquerda
    7, 5; 2, 8    // Diagonais direita
];

// Número de nós e elementos
n_nodes = size(nodes, 1);
n_elements = size(elements, 1);

// Matriz de rigidez global
K = zeros(3*n_nodes, 3*n_nodes);

// Montagem da matriz de rigidez global
for e = 1:n_elements
    n1 = elements(e, 1);
    n2 = elements(e, 2);
    
    x1 = nodes(n1, 1); y1 = nodes(n1, 2); z1 = nodes(n1, 3);
    x2 = nodes(n2, 1); y2 = nodes(n2, 2); z2 = nodes(n2, 3);
    
    L = sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2);
    
    cx = (x2 - x1) / L;
    cy = (y2 - y1) / L;
    cz = (z2 - z1) / L;
    
    T = [cx cy cz 0 0 0; 0 0 0 cx cy cz];
    
    ke_local = (E * A / L) * [1 -1; -1 1];
    ke = T' * ke_local * T;
    
    dofs = [3*n1 - 2 : 3*n1  3*n2 - 2 : 3*n2];
    K(dofs, dofs) = K(dofs, dofs) + ke;
end

// Vetor de forças
F = zeros(3*n_nodes, 1);
load_nodes = [7, 2, 8, 5];  // Nós onde as cargas são aplicadas
for i = load_nodes
    F(3*i - 1) = -10000;  // Força na direção y (vertical)
end

// Condições de contorno (restrição completa no nó 1)
fixed_dofs = [1:3];  // Primeiro nó é fixo
free_dofs = setdiff(1 : 3 * n_nodes, fixed_dofs);

// Solução do sistema
U = zeros(3 * n_nodes, 1);
U(free_dofs) = K(free_dofs, free_dofs) \ F(free_dofs);

// Função para plotagem da treliça
function plot_truss(nodes, elements, U, scale_factor)
    clf();
    for e = 1:size(elements, 1)
        n1 = elements(e, 1);
        n2 = elements(e, 2);
        
        // Coordenadas antes da deformação
        x_orig = [nodes(n1, 1); nodes(n2, 1)];
        y_orig = [nodes(n1, 2); nodes(n2, 2)];
        z_orig = [nodes(n1, 3); nodes(n2, 3)];
        
        // Coordenadas após a deformação
        x_def = [nodes(n1, 1) + scale_factor * U(3*n1 - 2);
                 nodes(n2, 1) + scale_factor * U(3*n2 - 2)];
        y_def = [nodes(n1, 2) + scale_factor * U(3*n1 - 1);
                 nodes(n2, 2) + scale_factor * U(3*n2 - 1)];
        z_def = [nodes(n1, 3) + scale_factor * U(3*n1);
                 nodes(n2, 3) + scale_factor * U(3*n2)];
        
        // Plot original (preto)
        param3d(x_orig, y_orig, z_orig, [0 0]);
        h = gce();
        h.thickness = 2;
        
        // Plot deformado (vermelho)
        param3d(x_def, y_def, z_def, [5 0]);
        h = gce();
        h.thickness = 2;
        h.foreground = 5;  // Cor vermelha
    end
endfunction

// Plotagem da estrutura
scf(1);
subplot(211);
plot_truss(nodes, elements, U, 0);  // Estrutura Original
title('Estrutura Original');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

subplot(212);
plot_truss(nodes, elements, U, 100);  // Estrutura Deformada
title('Estrutura Deformada (fator de escala = 100)');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

// Cálculo das tensões em cada elemento
stresses = zeros(n_elements, 1);
for e = 1:n_elements
    n1 = elements(e, 1);
    n2 = elements(e, 2);
    
    x1 = nodes(n1, 1); y1 = nodes(n1, 2); z1 = nodes(n1, 3);
    x2 = nodes(n2, 1); y2 = nodes(n2, 2); z2 = nodes(n2, 3);
    
    L = sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2);
    
    cx = (x2 - x1) / L;
    cy = (y2 - y1) / L;
    cz = (z2 - z1) / L;
    
    u1 = U(3*n1 - 2); v1 = U(3*n1 - 1); w1 = U(3*n1);
    u2 = U(3*n2 - 2); v2 = U(3*n2 - 1); w2 = U(3*n2);
    
    epsilon = (cx * (u2 - u1) + cy * (v2 - v1) + cz * (w2 - w1)) / L;
    stresses(e) = E * epsilon;
end

// Exibição dos resultados
max_displacement = max(abs(U)) * 1000;  // em mm
max_stress = max(abs(stresses)) / 1e6;  // em MPa
disp(['Deslocamento máximo = ' string(max_displacement) ' mm']);
disp(['Tensão máxima = ' string(max_stress) ' MPa']);
