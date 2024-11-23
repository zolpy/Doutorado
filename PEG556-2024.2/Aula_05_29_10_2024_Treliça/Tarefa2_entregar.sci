clear, clc
// Definir parâmetros do problema
E = 1.9e5; // Módulo de elasticidade em lb/in²
A = 8; // Área transversal em in²
L = 36; // Comprimento em in (para as barras horizontais)

nodes = [0 0; 0 36; 36 36; 72 36; 36 0]; // Coordenadas dos nós

elements = [1 2; 2 3; 3 4; 4 5; 2 5; 1 5]; // Conectividade das barras

// Montar a matriz de rigidez global
n_nodes = size(nodes, 'r');
n_elements = size(elements, 'r');
K_global = zeros(2 * n_nodes, 2 * n_nodes);

for i = 1:n_elements
    node1 = elements(i, 1);
    node2 = elements(i, 2);
    
    x1 = nodes(node1, 1);
    y1 = nodes(node1, 2);
    x2 = nodes(node2, 1);
    y2 = nodes(node2, 2);
    
    L_e = sqrt((x2 - x1)^2 + (y2 - y1)^2); // Comprimento da barra
    c = (x2 - x1) / L_e;
    s = (y2 - y1) / L_e;
    
    k_local = (E * A / L_e) * [c^2, c*s, -c^2, -c*s;
                                c*s, s^2, -c*s, -s^2;
                               -c^2, -c*s, c^2, c*s;
                               -c*s, -s^2, c*s, s^2];
    
    index = [2*node1-1, 2*node1, 2*node2-1, 2*node2];
    K_global(index, index) = K_global(index, index) + k_local;
end

// Aplicar as condições de contorno (nós fixos)
// Nós 1 e 3 estão fixos, então os deslocamentos são zero nesses nós
fixed_dofs = [1 2 5 6];
free_dofs = setdiff(1:2*n_nodes, fixed_dofs);

K_reduced = K_global(free_dofs, free_dofs);

// Definir o vetor de forças aplicadas (cargas nos nós 4 e 5)
F = zeros(2 * n_nodes, 1);
F(7) = 500; // Força no nó 4 na direção y
F(9) = 500; // Força no nó 5 na direção y

F_reduced = F(free_dofs);

// Resolver para os deslocamentos
displacements = zeros(2 * n_nodes, 1);
displacements(free_dofs) = K_reduced \ F_reduced;

// Calcular tensões nas barras
for i = 1:n_elements
    node1 = elements(i, 1);
    node2 = elements(i, 2);
    
    x1 = nodes(node1, 1);
    y1 = nodes(node1, 2);
    x2 = nodes(node2, 1);
    y2 = nodes(node2, 2);
    
    L_e = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    c = (x2 - x1) / L_e;
    s = (y2 - y1) / L_e;
    
    u = [displacements(2*node1-1); displacements(2*node1);
         displacements(2*node2-1); displacements(2*node2)];
    
    stress = E / L_e * [-c -s c s] * u;
    disp(['Tensão na barra ', string(i), ': ', string(stress), ' psi']);
end
////----------------------------------

// Definir as coordenadas dos nós originais (estrutura original)
X = [0 0; 0 36; 36 36; 72 36; 36 0]; // Coordenadas dos nós (X, Y) em polegadas

// Definir os deslocamentos nos nós (calculados anteriormente)
// Supondo que "displacements" já foi calculado como vetor de deslocamentos para cada nó
displacements = displacements * 100; // Amplificar deslocamentos para visualização (se necessário)

// Estrutura deformada: calcular novas coordenadas adicionando os deslocamentos
X_deformado = X; // Copiar as coordenadas originais

for i = 1:size(X, 'r')
    X_deformado(i, 1) = X(i, 1) + displacements(2*i-1); // Coordenada X
    X_deformado(i, 2) = X(i, 2) + displacements(2*i);   // Coordenada Y
end

// Plotagem dos dois gráficos sobrepostos (antes e depois)
clf;
plot(X(:,1), X(:,2), 'bo-', "LineWidth", 2); // Estrutura original (azul)

// Manter o gráfico anterior
gca().auto_clear = "off"; 

plot(X_deformado(:,1), X_deformado(:,2), 'ro--', "LineWidth", 2); // Estrutura deformada (vermelho)

// Conectar os nós originais para desenhar as barras da estrutura original
for i = 1:size(X, 'r') - 1
    plot([X(i,1) X(i+1,1)], [X(i,2) X(i+1,2)], 'b-', "LineWidth", 2);
end

// Conectar os nós deformados para desenhar as barras da estrutura deformada
for i = 1:size(X_deformado, 'r') - 1
    plot([X_deformado(i,1) X_deformado(i+1,1)], [X_deformado(i,2) X_deformado(i+1,2)], 'r--', "LineWidth", 2);
end

// Configurar a legenda e os eixos
legend(["Estrutura original (antes)", "Estrutura deformada (depois)"], "in_lower_right"); // Posiciona a legenda no canto inferior direito
//opções:in_upper_right, in_upper_left, in_lower_left, in_lower_right

title("Comparação da Estrutura Original e Deformada");
xlabel("X (polegadas)");
ylabel("Y (polegadas)");
xgrid(); // Adicionar grid ao gráfico


// Restaurar o comportamento normal do gráfico
gca().auto_clear = "on";


