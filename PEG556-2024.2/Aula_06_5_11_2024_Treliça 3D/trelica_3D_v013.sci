clear; clc
// Análise da treliça triangular
E = 200e9;  // Módulo de elasticidade (Pa)
d = 0.025;  // Diâmetro (m)
A = %pi * (d^2) / 4;  // Área da seção

// Definição dos nós
// Formato: [x, y, z]
nodes = [
    // Seção triangular frontal
    0, 0, 0;      // 1 (base esquerda)
    2, 0, 0;      // 2 (base direita)
    1, 1, 0;      // 3 (topo)
    // Seção triangular traseira
    0, 0, 2;      // 4 (base esquerda)
    2, 0, 2;      // 5 (base direita)
    1, 1, 2;      // 6 (topo)
    // Pontos intermediários
    1, 0, 0;      // 7 (meio base frontal)
    1, 0, 2;      // 8 (meio base traseira)
];

// Elementos conectando os nós
elements = [
    // Triângulo frontal
    1, 7; 7, 2;   // Base
    1, 3; 2, 3;   // Laterais
    7, 3;         // Vertical meio
    // Triângulo traseiro
    4, 8; 8, 5;   // Base
    4, 6; 5, 6;   // Laterais
    8, 6;         // Vertical meio
    // Conexões longitudinais
    1, 4;         // Lateral esquerda
    2, 5;         // Lateral direita
    3, 6;         // Topo
    7, 8;         // Meio
    // Diagonais
    1, 8; 7, 4;   // Lado esquerdo
    7, 5; 2, 8    // Lado direito
];

// Número de nós e elementos
n_nodes = size(nodes, 1);
n_elements = size(elements, 1);

// Matriz de rigidez global
K = zeros(3*n_nodes, 3*n_nodes);

// Montagem da matriz de rigidez
for e = 1:n_elements
    n1 = elements(e,1);
    n2 = elements(e,2);
    
    x1 = nodes(n1,1); y1 = nodes(n1,2); z1 = nodes(n1,3);
    x2 = nodes(n2,1); y2 = nodes(n2,2); z2 = nodes(n2,3);
    
    L = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
    
    cx = (x2-x1)/L;
    cy = (y2-y1)/L;
    cz = (z2-z1)/L;
    
    T = [cx cy cz 0 0 0; 0 0 0 cx cy cz];
    
    ke_local = (E*A/L) * [1 -1; -1 1];
    ke = T' * ke_local * T;
    
    dofs = [3*n1-2:3*n1 3*n2-2:3*n2];
    K(dofs,dofs) = K(dofs,dofs) + ke;
end

// Forças aplicadas
F = zeros(3*n_nodes,1);
// Cargas verticais de 10kN
load_nodes = [7, 2, 8, 5];  // Nós onde as cargas são aplicadas
for i = load_nodes
    F(3*i-1) = -10000;  // Força na direção y (vertical)
end

// Condições de contorno - nó engastado
fixed_dofs = [1:3];  // Primeiro nó totalmente restrito
free_dofs = setdiff(1:3*n_nodes, fixed_dofs);

// Resolução do sistema
U = zeros(3*n_nodes,1);
U(free_dofs) = K(free_dofs,free_dofs)\F(free_dofs);

// Função para plotagem
function plot_truss(nodes, elements, deform, scale_factor)
    clf();
    f = gcf();
    f.color_map = cool(64);  // Substituição de coolcolormap por cool
    
    for e = 1:size(elements,1)
        n1 = elements(e,1);
        n2 = elements(e,2);
        
        if ~deform then
            x = [nodes(n1,1); nodes(n2,1)];
            y = [nodes(n1,2); nodes(n2,2)];
            z = [nodes(n1,3); nodes(n2,3)];
        else
            x = [nodes(n1,1) + scale_factor*U(3*n1-2);
                 nodes(n2,1) + scale_factor*U(3*n2-2)];
            y = [nodes(n1,2) + scale_factor*U(3*n1-1);
                 nodes(n2,2) + scale_factor*U(3*n2-1)];
            z = [nodes(n1,3) + scale_factor*U(3*n1);
                 nodes(n2,3) + scale_factor*U(3*n2)];
        end
        
        param3d(x, y, z);
        h = gce();
        h.thickness = 2;
    end
    
    a = gca();
    a.box = "on";
    a.isoview = "on";
    a.rotation_angles = [45 45];  // Ajuste para orientação diagonal como uma ponte
endfunction

// Plotagem
scf(1);
subplot(211);
plot_truss(nodes, elements, %f, 0);
title('Estrutura Original');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

subplot(212);
plot_truss(nodes, elements, %t, 100);
title('Estrutura Deformada (fator de escala = 100)');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

// Cálculo e exibição dos resultados
max_displacement = max(abs(U));
disp(['Deslocamento máximo = ' string(max_displacement*1000) ' mm']);

// Cálculo das tensões
stresses = zeros(size(elements,1),1);
for e = 1:size(elements,1)
    n1 = elements(e,1);
    n2 = elements(e,2);
    
    x1 = nodes(n1,1); y1 = nodes(n1,2); z1 = nodes(n1,3);
    x2 = nodes(n2,1); y2 = nodes(n2,2); z2 = nodes(n2,3);
    
    L = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
    
    cx = (x2-x1)/L;
    cy = (y2-y1)/L;
    cz = (z2-z1)/L;
    
    u1 = U(3*n1-2); v1 = U(3*n1-1); w1 = U(3*n1);
    u2 = U(3*n2-2); v2 = U(3*n2-1); w2 = U(3*n2);
    
    epsilon = (cx*(u2-u1) + cy*(v2-v1) + cz*(w2-w1))/L;
    stresses(e) = E * epsilon;
end

disp(['Tensão máxima = ' string(max(abs(stresses))/1e6) ' MPa']);
