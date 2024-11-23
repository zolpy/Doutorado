// Análise da treliça triangular
E = 200e9;  // Módulo de elasticidade (Pa)
d = 0.025;  // Diâmetro (m)
A = %pi * (d^2) / 4;  // Área da seção

// Definição dos nós
// Formato: [x, y, z]
nodes = [
    // Base (z = 0)
    0, 0, 0;    // 1
    1, 0, 0;    // 2
    2, 0, 0;    // 3
    // Topo (z = 1)
    0.5, 1, 0;  // 4
    1.5, 1, 0;  // 5
    // Pontos traseiros (y = 1)
    0, 0, 1;    // 6
    1, 0, 1;    // 7
    2, 0, 1     // 8
];

// Elementos conectando os nós
elements = [
    // Base frontal
    1, 2; 2, 3;
    // Base traseira
    6, 7; 7, 8;
    // Verticais frontais
    1, 4; 2, 5; 3, 5;
    // Verticais traseiras
    6, 4; 7, 5; 8, 5;
    // Diagonais laterais
    1, 7; 2, 6;
    2, 8; 3, 7;
    // Conexões transversais
    4, 5
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
load_nodes = [2, 3, 4, 5, 7];
for i = load_nodes
    F(3*i-1) = -10000;  // Força na direção y (vertical)
end

// Condições de contorno - nós engastados
fixed_nodes = [1, 6];  // Primeiro e último nós
fixed_dofs = [];
for i = fixed_nodes
    fixed_dofs = [fixed_dofs; (3*i-2):(3*i)];
end
free_dofs = setdiff(1:3*n_nodes, fixed_dofs);

// Resolução do sistema
U = zeros(3*n_nodes,1);
U(free_dofs) = K(free_dofs,free_dofs)\F(free_dofs);

// Plotagem da estrutura
function plot_truss(nodes, elements, deform, scale_factor)
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
        
        plot3d(x, y, z, 'b-', 'LineWidth', 2);
        a = gca();
        a.box = "on";
        a.isoview = "on";
    end
endfunction

// Criar figura com duas subfiguras
scf();
subplot(211);
plot_truss(nodes, elements, %f, 0);
title('Estrutura Original');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

subplot(212);
plot_truss(nodes, elements, %t, 100);
title('Estrutura Deformada (fator de escala = 100)');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

// Calcular e mostrar deslocamentos máximos
max_displacement = max(abs(U));
disp(['Deslocamento máximo = ' string(max_displacement*1000) ' mm']);

// Calcular tensões
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
