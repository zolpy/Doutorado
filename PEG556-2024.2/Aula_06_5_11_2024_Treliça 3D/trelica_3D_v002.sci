clear; clc
// Parâmetros do material e da seção transversal
E = 200e9; // Módulo de Elasticidade em Pa (200 GPa)
A = 0.01;  // Área da seção transversal em m² (ajustável)

// Definindo nós (coordenadas x, y, z)
nodes = [0 0 0; 1 0 0; 1 1 0; 0 1 0; // Nível inferior
         0 0 1; 1 0 1; 1 1 1; 0 1 1]; // Nível superior

// Definindo elementos (conectividade entre nós)
elements = [1 2; 2 3; 3 4; 4 1; // Base inferior
            5 6; 6 7; 7 8; 8 5; // Base superior
            1 5; 2 6; 3 7; 4 8; // Colunas verticais
            1 6; 2 7; 3 8; 4 5]; // Diagonais

// Condições de contorno: Nós fixos (engastes) nos nós da base inferior (x, y, z)
fixed_dofs = [1, 2, 3, 4]; // Índices dos nós fixos

// Aplicando forças externas (em N) nos nós superiores
loads = zeros(size(nodes, 1), 3); // Inicializando vetor de forças
loads(6, 3) = -1000; // Carga de 1000 N no nó 6, direção z
loads(7, 3) = -1000; // Carga de 1000 N no nó 7, direção z

// Função para calcular a matriz de rigidez de um elemento
function Ke = element_stiffness(E, A, node1, node2)
    L = norm(node2 - node1); // Comprimento do elemento
    direction = (node2 - node1) / L;
    Cx = direction(1); Cy = direction(2); Cz = direction(3);
    K_local = (E * A / L) * [Cx^2 Cx*Cy Cx*Cz -Cx^2 -Cx*Cy -Cx*Cz;
                             Cx*Cy Cy^2 Cy*Cz -Cx*Cy -Cy^2 -Cy*Cz;
                             Cx*Cz Cy*Cz Cz^2 -Cx*Cz -Cy*Cz -Cz^2;
                            -Cx^2 -Cx*Cy -Cx*Cz Cx^2 Cx*Cy Cx*Cz;
                            -Cx*Cy -Cy^2 -Cy*Cz Cx*Cy Cy^2 Cy*Cz;
                            -Cx*Cz -Cy*Cz -Cz^2 Cx*Cz Cy*Cz Cz^2];
    Ke = K_local;
endfunction

// Montagem da matriz de rigidez global
n_dof = 3 * size(nodes, 1);
K_global = zeros(n_dof, n_dof);
for i = 1:size(elements, 1)
    node1 = nodes(elements(i, 1), :);
    node2 = nodes(elements(i, 2), :);
    Ke = element_stiffness(E, A, node1, node2);
    dofs = [3*elements(i, 1)-2 : 3*elements(i, 1), 3*elements(i, 2)-2 : 3*elements(i, 2)];
    K_global(dofs, dofs) = K_global(dofs, dofs) + Ke;
end

// Aplicando as condições de contorno
all_dofs = 1:n_dof;
fixed_dofs = unique([3*fixed_dofs-2, 3*fixed_dofs-1, 3*fixed_dofs]); // Fixando x, y, z dos nós da base inferior
free_dofs = setdiff(all_dofs, fixed_dofs);

F = loads(:); // Vetor de forças
Ff = F(free_dofs);
K_ff = K_global(free_dofs, free_dofs);

// Calculando deslocamentos
U = zeros(n_dof, 1);
U(free_dofs) = K_ff \ Ff;

// Calculando as tensões nos elementos
stress = zeros(size(elements, 1), 1);
for i = 1:size(elements, 1)
    node1 = nodes(elements(i, 1), :);
    node2 = nodes(elements(i, 2), :);
    L = norm(node2 - node1);
    direction = (node2 - node1) / L;
    dofs = [3*elements(i, 1)-2 : 3*elements(i, 1), 3*elements(i, 2)-2 : 3*elements(i, 2)];
    u_elem = U(dofs);
    stress(i) = (E / L) * [-direction direction] * u_elem;
end

// Exibindo resultados
disp("Deslocamentos nos nós:");
disp(matrix(U, 3, size(nodes, 1))');

disp("Tensões nos elementos (Pa):");
disp(stress);

// Plotando a estrutura e a deformação
clf();
for i = 1:size(elements, 1)
    node1 = nodes(elements(i, 1), :);
    node2 = nodes(elements(i, 2), :);
    plot3([node1(1), node2(1)], [node1(2), node2(2)], [node1(3), node2(3)], "k-"); // Estrutura original
    node1_disp = node1 + U(3*elements(i, 1)-2:3*elements(i, 1))';
    node2_disp = node2 + U(3*elements(i, 2)-2:3*elements(i, 2))';
    plot3([node1_disp(1), node2_disp(1)], [node1_disp(2), node2_disp(2)], [node1_disp(3), node2_disp(3)], "r--"); // Estrutura deformada
end
xlabel("x (m)");
ylabel("y (m)");
zlabel("z (m)");
legend(["Estrutura Original", "Estrutura Deformada"]);
title("Análise de Treliça 3D com FEM");
