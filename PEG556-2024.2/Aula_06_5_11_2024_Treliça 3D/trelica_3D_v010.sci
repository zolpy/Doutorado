clear; clc;

// Parâmetros da treliça
E = 200e3;          // Módulo de Elasticidade em MPa (200 GPa)
d = 0.025;          // Diâmetro da barra em metros (25 mm)
A = %pi * (d/2)^2;  // Área da seção transversal em metros quadrados
F = 10e3;           // Carga aplicada em Newtons (10 kN)
height = 1;         // Altura da treliça em metros
width = 1;          // Largura da treliça em metros
length = 2;         // Comprimento da treliça em metros

// Coordenadas dos nós (x, y, z)
node = [
    0, 0, 0;
    length, 0, 0;
    0, width, 0;
    length, width, 0;
    0, 0, height;
    length, 0, height;
    0, width, height;
    length, width, height
];

// Definição dos elementos conectando os nós
element = [
    1, 2;
    1, 3;
    2, 4;
    3, 4;
    1, 5;
    2, 6;
    3, 7;
    4, 8;
    5, 6;
    5, 7;
    6, 8;
    7, 8;
    1, 6;
    2, 5;
    3, 8;
    4, 7
];

// Número total de nós e elementos
numnode = size(node, 1);
numelem = size(element, 1);

// Inicialização das matrizes de deslocamento e rigidez
U = zeros(3*numnode, 1);  // Matriz de deslocamentos (inicialmente nula)
K = zeros(3*numnode, 3*numnode);  // Matriz de rigidez global

// Loop sobre cada elemento para construir a matriz de rigidez
for e = 1:numelem
    indice = element(e, :);
    indiceB = [3*indice(1)-2, 3*indice(1)-1, 3*indice(1), 3*indice(2)-2, 3*indice(2)-1, 3*indice(2)];
    
    // Coordenadas dos nós do elemento
    x1 = node(indice(1), 1);
    y1 = node(indice(1), 2);
    z1 = node(indice(1), 3);
    x2 = node(indice(2), 1);
    y2 = node(indice(2), 2);
    z2 = node(indice(2), 3);
    
    // Comprimento do elemento e cossenos diretores
    L = sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2);
    cx = (x2 - x1) / L;
    cy = (y2 - y1) / L;
    cz = (z2 - z1) / L;
    
    // Matriz de rigidez do elemento no sistema global
    ke = (A * E / L) * [
        cx^2, cx*cy, cx*cz, -cx^2, -cx*cy, -cx*cz;
        cx*cy, cy^2, cy*cz, -cx*cy, -cy^2, -cy*cz;
        cx*cz, cy*cz, cz^2, -cx*cz, -cy*cz, -cz^2;
        -cx^2, -cx*cy, -cx*cz, cx^2, cx*cy, cx*cz;
        -cx*cy, -cy^2, -cy*cz, cx*cy, cy^2, cy*cz;
        -cx*cz, -cy*cz, -cz^2, cx*cz, cy*cz, cz^2
    ];
    
    // Montagem da matriz de rigidez global
    K(indiceB, indiceB) = K(indiceB, indiceB) + ke;
end

// Condições de contorno: nós fixos
fixed_nodes = [1, 3, 5, 7];  // Nós fixados (clamped)
for i = 1:length(fixed_nodes)
    idx = 3*fixed_nodes(i) - [2, 1, 0];
    K(idx, :) = 0;
    K(:, idx) = 0;
    K(idx, idx) = eye(3, 3);
end

// Aplicação de forças nos nós livres
F_ext = zeros(3*numnode, 1);
F_ext(3*2) = -F;    // Força aplicada no nó 2 na direção z
F_ext(3*4) = -F;    // Força aplicada no nó 4 na direção z
F_ext(3*6) = -F;    // Força aplicada no nó 6 na direção z
F_ext(3*8) = -F;    // Força aplicada no nó 8 na direção z

// Cálculo dos deslocamentos
U = K \ F_ext;

// Cálculo das tensões em cada elemento
stresses = zeros(numelem, 1);
for e = 1:numelem
    indice = element(e, :);
    x1 = node(indice(1), 1); y1 = node(indice(1), 2); z1 = node(indice(1), 3);
    x2 = node(indice(2), 1); y2 = node(indice(2), 2); z2 = node(indice(2), 3);
    L = sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2);
    cx = (x2 - x1) / L; cy = (y2 - y1) / L; cz = (z2 - z1) / L;
    
    indiceB = [3*indice(1)-2, 3*indice(1)-1, 3*indice(1), 3*indice(2)-2, 3*indice(2)-1, 3*indice(2)];
    u_element = U(indiceB);
    stress = (E / L) * [-cx, -cy, -cz, cx, cy, cz] * u_element;
    stresses(e) = stress;
end

// Exibição dos resultados
disp("Deslocamentos nos nós:");
disp(U);

disp("Tensões nos elementos:");
disp(stresses);

// Plotagem dos deslocamentos
clf;
for e = 1:numelem
    i = element(e, 1);
    j = element(e, 2);
    xi = node(i, 1) + U(3*i-2);
    yi = node(i, 2) + U(3*i-1);
    zi = node(i, 3) + U(3*i);
    xj = node(j, 1) + U(3*j-2);
    yj = node(j, 2) + U(3*j-1);
    zj = node(j, 3) + U(3*j);
    
    plot3([xi xj], [yi yj], [zi zj], 'b');
    plot3([node(i, 1) node(j, 1)], [node(i, 2) node(j, 2)], [node(i, 3) node(j, 3)], 'k--');
end
xlabel("X");
ylabel("Y");
zlabel("Z");
title("Deslocamento da Treliça com FEM");
legend(["Deslocado", "Original"]);
