clear; clc

// Conversão de unidades para SI
in_to_m = 0.0254; // 1 polegada = 0.0254 metros
lb_to_N = 4.44822; // 1 lb = 4.44822 N
psi_to_Pa = 6894.76; // 1 lb/in² = 6894.76 Pa

// Convertendo as propriedades do material para SI
E = 1.9e6 * psi_to_Pa; // Convertendo de lb/in² para Pa
A = 8 * (in_to_m)^2; // Convertendo de in² para m²

mprintf(" E = %.2f [lb/in² para Pa] \n A = %.2f [in² para m²]\n\n", E, A);

function [y] = elength(xi, yi, xj, yj)
    y = sqrt((xj - xi)^2 + (yj - yi)^2);
endfunction

// Convertendo comprimentos para metros
L1 = elength(0, 0, 36, 0) * in_to_m;
L2 = elength(36, 0, 0, 36) * in_to_m;
L3 = elength(0, 36, 36, 36) * in_to_m;
L4 = elength(36, 0, 36, 36) * in_to_m;
L5 = elength(36, 0, 72, 36) * in_to_m;
L6 = elength(36, 36, 72, 36) * in_to_m;

disp("Comprimento dos elementos (m):");
disp([L1; L2; L3; L4; L5; L6]);
mprintf("\n")

theta1 = 0;
theta2 = 90 + atan(36/36) * 180 / %pi;
theta3 = 0;
theta4 = 90;
theta5 = atan(36/36) * 180 / %pi;
theta6 = 0;

disp("Ângulos  (°):");
disp([theta1; theta2; theta3; theta4; theta5; theta6]);
mprintf("\n")

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

//Matriz de zeros de K
K = zeros(10, 10);
disp("Matriz de zeros de K:", K)

function [y] = assembly(K, k, i, j)
    K(2*i-1:2*i, 2*i-1:2*i) = K(2*i-1:2*i, 2*i-1:2*i) + k(1:2,1:2);
    K(2*i-1:2*i, 2*j-1:2*j) = K(2*i-1:2*i, 2*j-1:2*j) + k(1:2,3:4);
    K(2*j-1:2*j, 2*i-1:2*i) = K(2*j-1:2*j, 2*i-1:2*i) + k(3:4,1:2);
    K(2*j-1:2*j, 2*j-1:2*j) = K(2*j-1:2*j, 2*j-1:2*j) + k(3:4,3:4);
    y = K;
endfunction

mprintf("\n")
K = assembly(K, k1, 1, 2);
disp("Completando a Matriz Global com os valores da local k1")
disp(K)
mprintf("\n")

K = assembly(K, k2, 2, 3);
disp("Completando a Matriz Global com os valores da local k2")
disp(K)
mprintf("\n")

K = assembly(K, k3, 3, 4);
disp("Completando a Matriz Global com os valores da local k3")
disp(K)
mprintf("\n")

K = assembly(K, k4, 2, 4);
disp("Completando a Matriz Global com os valores da local k4")
disp(K)
mprintf("\n")

K = assembly(K, k5, 2, 5);
disp("Completando a Matriz Global com os valores da local k5")
disp(K)
mprintf("\n")

K = assembly(K, k6, 4, 5);
disp("Completando a Matriz Global com os valores da local k6")
disp(K)
mprintf("\n")

//Cortando linhas e colunas
k = [K(3:4,3:4) K(3:4,7:10); K(7:10,3:4) K(7:10, 7:10)];
disp("Cortando linhas e colunas")
disp(k)
mprintf("\n")

// Convertendo força para N
f = [0; 0; 0; -500 * lb_to_N; 0; -500 * lb_to_N];
disp("Matriz de Força f")
disp(f)
mprintf("\n")

u = k\f;
disp("Matriz de u")
disp(u)
mprintf("\n")

U = [0; 0; u(1); u(2); 0; 0; u(3:6)];
disp("Deslocamentos (m):");
disp(U);
mprintf("\n")

F = K * U;
disp("Forças (N):");
disp(F);
mprintf("\n")

// Plotagem da estrutura
// Coordenadas originais em metros
xi = [0, 36, 0, 36, 72] * in_to_m;
yi = [0, 0, 36, 36, 36] * in_to_m;

// Fator de escala para visualização da deformação
scale_factor = 100;

// Coordenadas deformadas
xf = xi + scale_factor * [U(1), U(3), U(5), U(7), U(9)];
yf = yi + scale_factor * [U(2), U(4), U(6), U(8), U(10)];

// Elementos da estrutura
elementos = [1,2; 2,3; 3,4; 2,4; 2,5; 4,5];

// Configurando o gráfico
clf();
f = scf();

// Plotando estrutura original
for i = 1:size(elementos, 1)
    no1 = elementos(i,1);
    no2 = elementos(i,2);
    plot([xi(no1), xi(no2)], [yi(no1), yi(no2)], 'b-', 'LineWidth', 2);
end

// Plotando estrutura deformada
for i = 1:size(elementos, 1)
    no1 = elementos(i,1);
    no2 = elementos(i,2);
    plot([xf(no1), xf(no2)], [yf(no1), yf(no2)], 'r--', 'LineWidth', 2);
end

// Plotando os nós
plot(xi, yi, 'bo', 'MarkerSize', 8);
plot(xf, yf, 'ro', 'MarkerSize', 8);

// Configurações do gráfico
legend(['Estrutura Original', 'Estrutura Deformada (escala ' + string(scale_factor) + 'x)']);
title('Comparação da Estrutura Original e Deformada');
xlabel('X (metros)');
ylabel('Y (metros)');
xgrid(1);

// Ajustando os limites do gráfico
margin = 0.2;
ax = gca();
ax.data_bounds = [min(min(xi), min(xf))-margin, min(min(yi), min(yf))-margin;
                 max(max(xi), max(xf))+margin, max(max(yi), max(yf))+margin];
