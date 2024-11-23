clear; clc;

// Parâmetros do material e geometria
E = 200000;                // Módulo de Elasticidade (MPa)
d = 25;                    // Diâmetro (mm)
A = (%pi * d^2) / 4;      // Área (mm²)
EA = E * A;               // Rigidez axial
F = -1000;               // Força aplicada

// Definição da geometria
node = [
    0, 0, 0;    // 1
    0, 0.5, 1;  // 2
    0, 1, 0;    // 3
    1, 0, 0;    // 4
    1, 0.5, 1;  // 5
    1, 1, 0;    // 6
    2, 0, 0;    // 7
    2, 0.5, 1;  // 8
    2, 1, 0     // 9
];

element = [
    1,2; 2,3; 3,1; 4,5; 5,6; 6,4;
    7,8; 8,9; 9,7; 1,4; 2,5; 3,6;
    4,7; 5,8; 6,9; 1,6; 2,4; 3,5;
    4,9; 5,7; 6,8
];

function k = calcular_matriz_local(no1, no2, EA)
    // Calcula matriz de rigidez local
    dx = no2(1) - no1(1);
    dy = no2(2) - no1(2);
    dz = no2(3) - no1(3);
    L = sqrt(dx^2 + dy^2 + dz^2);
    c = dx/L;
    s = dy/L;
    r = dz/L;
    
    k = (EA/L) * [
        c*c,   c*s,   c*r,  -c*c,  -c*s,  -c*r;
        c*s,   s*s,   s*r,  -c*s,  -s*s,  -s*r;
        c*r,   s*r,   r*r,  -c*r,  -s*r,  -r*r;
       -c*c,  -c*s,  -c*r,   c*c,   c*s,   c*r;
       -c*s,  -s*s,  -s*r,   c*s,   s*s,   s*r;
       -c*r,  -s*r,  -r*r,   c*r,   s*r,   r*r
    ];
endfunction

function plotar_estrutura(nodes, elements, deslocamentos, cor)
    // Plota a estrutura
    for i = 1:size(elements, 1)
        no1 = nodes(elements(i,1), :);
        no2 = nodes(elements(i,2), :);
        if deslocamentos ~= [] then
            no1 = no1 + deslocamentos(elements(i,1), :);
            no2 = no2 + deslocamentos(elements(i,2), :);
        end
        plot3d([no1(1), no2(1)], [no1(2), no2(2)], [no1(3), no2(3)], cor);
    end
endfunction

// Montagem da matriz de rigidez global
n_nos = size(node, 1);
K = zeros(3*n_nos, 3*n_nos);

for e = 1:size(element, 1)
    no1 = node(element(e,1), :);
    no2 = node(element(e,2), :);
    
    // Índices globais
    idx = [
        3*element(e,1)-2:3*element(e,1),
        3*element(e,2)-2:3*element(e,2)
    ];
    
    // Matriz local
    k_local = calcular_matriz_local(no1, no2, EA);
    
    // Assemblagem
    K(idx, idx) = K(idx, idx) + k_local;
end

// Aplicação das condições de contorno
nos_fixos = 1:9;  // Primeiros 3 nós fixos
gdl_fixos = [];
for i = nos_fixos
    gdl_fixos = [gdl_fixos, 3*i-2:3*i];
end

// Forças aplicadas
F_global = zeros(3*n_nos, 1);
F_global([12,18,21,27]) = F;  // Aplicação das forças

// Solução do sistema
gdl_livres = setdiff(1:3*n_nos, gdl_fixos);
U = zeros(3*n_nos, 1);
U(gdl_livres) = K(gdl_livres,gdl_livres) \ F_global(gdl_livres);

// Reorganiza os deslocamentos
desl_nos = zeros(n_nos, 3);
for i = 1:n_nos
    desl_nos(i,:) = U(3*i-2:3*i)';
end

// Visualização
subplot(121)
plotar_estrutura(node, element, [], "blue");
title("Estrutura Original");

subplot(122)
plotar_estrutura(node, element, desl_nos*1000, "red");  // Fator de escala 1000
title("Estrutura Deformada");
