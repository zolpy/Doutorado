clear; clc
//E = 1.9e6; // lb/in^2
//A = 8; // in^2

// Parâmetros em polegadas e libras
E_lb = 1.9e6; // Módulo de elasticidade em lb/in^2
A_in = 8; // Área da seção em in^2

// Conversão para SI (Pa e m²)
E = E_lb * 6894.76; // E em Pa
A = A_in * 0.00064516; // A em m²


function [y] = elength(xi, yi, xj, yj)
    y = sqrt((xj - xi)^2 + (yj - yi)^2);
endfunction

L1 = elength(0, 0, 36, 0); // 36 em polegadas
L2 = elength(36, 0, 0, 36);
L3 = elength(0, 36, 36, 36);
L4 = elength(36, 0, 36, 36);
L5 = elength(36, 0, 72, 36);
L6 = elength(36, 36, 72, 36);
disp("Comprimento dos elementos:");
disp([L1; L2; L3; L4; L5; L6]);

theta1 = 0;
theta2 = 90 + atan(36/36) * 180 / %pi;
theta3 = 0;
theta4 = 90;
theta5 = atan(36/36) * 180 / %pi;
theta6 = 0;
disp("Ângulos dos elementos:");
disp([theta1; theta2; theta3; theta4; theta5; theta6]);

function [y] = estiffness(A, E, L, theta)
    x = theta * %pi / 180;
    l = cos(x);
    m = sin(x);
    y = A * E / L * [l^2 l*m -l^2 -l*m; l*m m^2 -l*m -m^2; -l^2 -l*m l^2 l*m; -l*m -m^2 l*m m^2];
endfunction

k1 = estiffness(A, E, L1, theta1);
k2 = estiffness(A, E, L2, theta2);
k3 = estiffness(A, E, L3, theta3);
k4 = estiffness(A, E, L4, theta4);
k5 = estiffness(A, E, L5, theta5);
k6 = estiffness(A, E, L6, theta6);

K = zeros(10, 10);

function [K] = assembly(K, k, i, j)
    K(2*i-1:2*i, 2*i-1:2*i) = K(2*i-1:2*i, 2*i-1:2*i) + k(1:2,1:2);
    K(2*i-1:2*i, 2*j-1:2*j) = K(2*i-1:2*i, 2*j-1:2*j) + k(1:2,3:4);
    K(2*j-1:2*j, 2*i-1:2*i) = K(2*j-1:2*j, 2*i-1:2*i) + k(3:4,1:2);
    K(2*j-1:2*j, 2*j-1:2*j) = K(2*j-1:2*j, 2*j-1:2*j) + k(3:4,3:4);
endfunction

K = assembly(K, k1, 1, 2);
K = assembly(K, k2, 2, 3);
K = assembly(K, k3, 3, 4);
K = assembly(K, k4, 2, 4);
K = assembly(K, k5, 2, 5);
K = assembly(K, k6, 4, 5);
disp("Matriz de rigidez global K:");
disp(K);

k = [K(3:4,3:4) K(3:4,7:10); K(7:10,3:4) K(7:10, 7:10)];
f = [0; 0; 0; -500; 0; -500];
u = k \ f;
disp("Deslocamentos nodais u:");
disp(u);

U = [0; 0; u(1); u(2); 0; 0; u(3:6)];
disp("Deslocamentos completos U:");
disp(U);

F = K * U;
disp("Forças nodais F:");
disp(F);

//-------------------------------------------------
// Parâmetros do material e geometria
E = 2.1e11; // Módulo de elasticidade em Pa (exemplo para aço)
A = 0.01;   // Área da seção transversal em m²
L = [36, 36, 36, 36, 72, 72]; // Comprimentos das barras em metros
F = [1000, 2000, 1500, 2500, 1800, 2200]; // Forças em Newton aplicadas em cada barra (exemplo)

// Cálculo das deformações em cada barra
U = zeros(1, length(F));
for i = 1:length(F)
    k = E * A / L(i); // Rigidez de cada barra
    U(i) = F(i) / k;  // Deslocamento (deformação) em metros para cada barra
end

// Fator de ampliação para a visualização dos deslocamentos
scale_factor = 1000; // ajuste conforme necessário para ver a deformação

// Coordenadas iniciais dos nós (X e Y)
xi = [0, 36, 0, 36, 72]; // Posições X dos nós iniciais
yi = [0, 0, 36, 36, 36]; // Posições Y dos nós iniciais

// Coordenadas deformadas dos nós (com amplificação)
xf = xi + scale_factor * [U(1), U(2), U(3), U(4), U(5)];
yf = yi + scale_factor * [U(1), U(2), U(3), U(4), U(5)];

// Estrutura original (antes da deformação)
X_original = [xi', yi'];

// Estrutura deformada (depois da deformação)
X_deformado = [xf', yf'];

// Configuração do gráfico
clf;
plot2d([0], [0], [-1, 2]); // Configura o gráfico para múltiplas curvas

// Desenhando as barras da estrutura original
for i = 1:6
    if i == 1 then
        plot([X_original(1,1), X_original(2,1)], [X_original(1,2), X_original(2,2)], '-b', "LineWidth", 2);
    elseif i == 2 then
        plot([X_original(2,1), X_original(3,1)], [X_original(2,2), X_original(3,2)], '-b', "LineWidth", 2);
    elseif i == 3 then
        plot([X_original(3,1), X_original(4,1)], [X_original(3,2), X_original(4,2)], '-b', "LineWidth", 2);
    elseif i == 4 then
        plot([X_original(2,1), X_original(4,1)], [X_original(2,2), X_original(4,2)], '-b', "LineWidth", 2);
    elseif i == 5 then
        plot([X_original(2,1), X_original(5,1)], [X_original(2,2), X_original(5,2)], '-b', "LineWidth", 2);
    elseif i == 6 then
        plot([X_original(4,1), X_original(5,1)], [X_original(4,2), X_original(5,2)], '-b', "LineWidth", 2);
    end
end

// Desenhando as barras da estrutura deformada
for i = 1:6
    if i == 1 then
        plot([X_deformado(1,1), X_deformado(2,1)], [X_deformado(1,2), X_deformado(2,2)], 'r--', "LineWidth", 2);
    elseif i == 2 then
        plot([X_deformado(2,1), X_deformado(3,1)], [X_deformado(2,2), X_deformado(3,2)], 'r--', "LineWidth", 2);
    elseif i == 3 then
        plot([X_deformado(3,1), X_deformado(4,1)], [X_deformado(3,2), X_deformado(4,2)], 'r--', "LineWidth", 2);
    elseif i == 4 then
        plot([X_deformado(2,1), X_deformado(4,1)], [X_deformado(2,2), X_deformado(4,2)], 'r--', "LineWidth", 2);
    elseif i == 5 then
        plot([X_deformado(2,1), X_deformado(5,1)], [X_deformado(2,2), X_deformado(5,2)], 'r--', "LineWidth", 2);
    elseif i == 6 then
        plot([X_deformado(4,1), X_deformado(5,1)], [X_deformado(4,2), X_deformado(5,2)], 'r--', "LineWidth", 2);
    end
end

// Configurando a legenda e os eixos
legend(["Estrutura original (antes)", "Estrutura deformada (depois)"], "in_lower_right");
title("Comparação da Estrutura Original e Deformada com Escala de Deformação");
xlabel("X (metros)");
ylabel("Y (metros)");
xgrid(); // Adicionar grid ao gráfico
gcf();
