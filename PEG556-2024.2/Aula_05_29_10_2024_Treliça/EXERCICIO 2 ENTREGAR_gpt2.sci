clear; clc;

// Parâmetros em polegadas e libras
E_lb = 1.9e6; // Módulo de elasticidade em lb/in^2
A_in = 8; // Área da seção em in^2

// Conversão para SI (Pa e m²)
E = E_lb * 6894.76; // E em Pa
A = A_in * 0.00064516; // A em m²

// Função para calcular o comprimento entre dois pontos
function [y] = elength(xi, yi, xj, yj)
    y = sqrt((xj - xi)^2 + (yj - yi)^2);
endfunction

// Comprimentos dos elementos em metros
L1 = elength(0, 0, 0.9144, 0);   // 36 polegadas = 0.9144 metros
L2 = elength(0.9144, 0, 0, 0.9144);
L3 = elength(0, 0.9144, 0.9144, 0.9144);
L4 = elength(0.9144, 0, 0.9144, 0.9144);
L5 = elength(0.9144, 0, 1.8288, 0.9144); // 72 polegadas = 1.8288 metros
L6 = elength(0.9144, 0.9144, 1.8288, 0.9144);
disp("Comprimento dos elementos em metros:");
disp([L1; L2; L3; L4; L5; L6]);

// Ângulos dos elementos
theta1 = 0;
theta2 = 90 + atan(36 / 36) * 180 / %pi;
theta3 = 0;
theta4 = 90;
theta5 = atan(36 / 36) * 180 / %pi;
theta6 = 0;
disp("Ângulos dos elementos em graus:");
disp([theta1; theta2; theta3; theta4; theta5; theta6]);

// Função para calcular a rigidez
function [y] = estiffness(A, E, L, theta)
    x = theta * %pi / 180;
    l = cos(x);
    m = sin(x);
    y = A * E / L * [l^2 l*m -l^2 -l*m; l*m m^2 -l*m -m^2; -l^2 -l*m l^2 l*m; -l*m -m^2 l*m m^2];
endfunction

// Matrizes de rigidez dos elementos
k1 = estiffness(A, E, L1, theta1);
k2 = estiffness(A, E, L2, theta2);
k3 = estiffness(A, E, L3, theta3);
k4 = estiffness(A, E, L4, theta4);
k5 = estiffness(A, E, L5, theta5);
k6 = estiffness(A, E, L6, theta6);

// Matriz de rigidez global
K = zeros(10, 10);

function [K] = assembly(K, k, i, j)
    K(2*i-1:2*i, 2*i-1:2*i) = K(2*i-1:2*i, 2*i-1:2*i) + k(1:2, 1:2);
    K(2*i-1:2*i, 2*j-1:2*j) = K(2*i-1:2*i, 2*j-1:2*j) + k(1:2, 3:4);
    K(2*j-1:2*j, 2*i-1:2*i) = K(2*j-1:2*j, 2*i-1:2*i) + k(3:4, 1:2);
    K(2*j-1:2*j, 2*j-1:2*j) = K(2*j-1:2*j, 2*j-1:2*j) + k(3:4, 3:4);
endfunction

K = assembly(K, k1, 1, 2);
K = assembly(K, k2, 2, 3);
K = assembly(K, k3, 3, 4);
K = assembly(K, k4, 2, 4);
K = assembly(K, k5, 2, 5);
K = assembly(K, k6, 4, 5);
disp("Matriz de rigidez global K:");
disp(K);

// Submatriz de rigidez para resolver deslocamentos
k = [K(3:4, 3:4) K(3:4, 7:10); K(7:10, 3:4) K(7:10, 7:10)];
f = [0; 0; 0; -2224; 0; -2224]; // Converteu 500 lb para 2224 N
u = k \ f;
disp("Deslocamentos nodais u:");
disp(u);

U = [0; 0; u(1); u(2); 0; 0; u(3:6)];
disp("Deslocamentos completos U:");
disp(U);

F = K * U;
disp("Forças nodais F:");
disp(F);

// Parâmetros do material e geometria
L = [0.9144, 0.9144, 0.9144, 0.9144, 1.8288, 1.8288]; // Comprimentos em metros
F = [1000, 2000, 1500, 2500, 1800, 2200]; // Forças em Newton

// Deformações
U = zeros(1, length(F));
for i = 1:length(F)
    k = E * A / L(i);
    U(i) = F(i) / k;
end

scale_factor = 1000;
xi = [0, 0.9144, 0, 0.9144, 1.8288];
yi = [0, 0, 0.9144, 0.9144, 0.9144];
xf = xi + scale_factor * [U(1), U(2), U(3), U(4), U(5)];
yf = yi + scale_factor * [U(1), U(2), U(3), U(4), U(5)];

// Plot da Estrutura
// Definindo os parâmetros
xi = [0, 36, 0, 36, 72]; // Posições X dos nós iniciais
yi = [0, 0, 36, 36, 36]; // Posições Y dos nós iniciais

// Fator de escala para amplificar a deformação
scale_factor = 50; // Ajuste este valor para melhor visualização

// Coordenadas dos nós após a deformação com fator de escala
xf = xi + scale_factor * [U(1), U(3), U(5), U(7), U(9)]; // deslocamento em x
yf = yi + scale_factor * [U(2), U(4), U(6), U(8), U(10)]; // deslocamento em y

// Estrutura original (antes da deformação)
X_original = [xi', yi'];

// Estrutura deformada (depois da deformação)
X_deformado = [xf', yf'];

// Configurando o gráfico
clf;
f = scf();
f.color_map = coolcolormap(32);

// Definindo os limites dos eixos para incluir toda a estrutura
margin = 10; // margem em polegadas
xmin = min(min(xi), min(xf)) - margin;
xmax = max(max(xi), max(xf)) + margin;
ymin = min(min(yi), min(yf)) - margin;
ymax = max(max(yi), max(yf)) + margin;

// Criando as conexões entre os nós (elementos)
elementos = [1,2; 2,3; 3,4; 2,4; 2,5; 4,5]; // Define as conexões entre os nós

// Plotando a estrutura original
for i = 1:size(elementos, 1)
    no1 = elementos(i,1);
    no2 = elementos(i,2);
    plot([X_original(no1,1), X_original(no2,1)], [X_original(no1,2), X_original(no2,2)], 'b-', 'LineWidth', 2);
end

// Plotando a estrutura deformada
for i = 1:size(elementos, 1)
    no1 = elementos(i,1);
    no2 = elementos(i,2);
    plot([X_deformado(no1,1), X_deformado(no2,1)], [X_deformado(no1,2), X_deformado(no2,2)], 'r--', 'LineWidth', 2);
end

// Plotando os nós
plot(xi, yi, 'bo', 'MarkerSize', 8, 'LineWidth', 2); // nós originais
plot(xf, yf, 'ro', 'MarkerSize', 8, 'LineWidth', 2); // nós deformados

// Configurando o gráfico
a = gca();
a.tight_limits = "on";
a.data_bounds = [xmin, ymin; xmax, ymax];
a.box = "on";
xgrid(1);

// Adicionando legendas e títulos
legend(['Estrutura Original', 'Estrutura Deformada'], "in_lower_right");
title('Comparação da Estrutura Original e Deformada');
xlabel('X (polegadas)');
ylabel('Y (polegadas)');

// Adicionando texto informativo sobre o fator de escala
text = sprintf('Fator de escala da deformação: %dx', scale_factor);
xstring(xmin + margin, ymax - margin, text);
