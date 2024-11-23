clear; clc
E = 1.9e6; // lb/in2
A = 8; //in2
function [y] = elength(xi, yi, xj, yj)
    y = sqrt((xj - xi)^2 + (yj - yi)^2);
endfunction
L1 = elength(0, 0, 36, 0); //onde 36 está em in
L2 = elength(36, 0, 0, 36);
L3 = elength(0, 36, 36, 36);
L4 = elength(36, 0, 36, 36);
L5 = elength(36, 0, 72, 36);
L6 = elength(36, 36, 72, 36);
disp("Comprimento dos elementos", L1, L2, L3, L4, L5, L6);
theta1 = 0;
theta2 = 90 + atan(36/36) * 180 / %pi;
theta3 = 0;
theta4 = 90;
theta5 = atan(36/36) * 180 / %pi;
theta6 = 0;
disp("Angulos dos elementos", theta1, theta2, theta3, theta4, theta5, theta6)
function [y] = estiffness(A, E, L, theta)
    x = theta * %pi / 180;
    l = cos(x);
    m = sin(x);
    y = A * E / L * [l^2 l*m -l^2 -l*m; l*m m^2 -l*m -m^2; -l^2 -l*m l^2 l*m; -l*m -m^2 l*m m^2];
endfunction
k1 = estiffness(A, E, L1, theta1);
disp(k1);
k2 = estiffness(A, E, L2, theta2);
disp(k2);
k3 = estiffness(A, E, L3, theta3);
disp(k3);
k4 = estiffness(A, E, L4, theta4);
disp(k4);
k5 = estiffness(A, E, L5, theta5);
disp(k5);
k6 = estiffness(A, E, L6, theta6);
disp(k6)
//5 nós vezes 2 graus de óliberdade,logo uma matriz 10x10
K = zeros(10, 10) 
function [y] = assembly(K, k, i, j)
    K(2*i-1, 2*i-1) = K(2*i-1, 2*i-1) + k(1, 1);
    K(2*i-1, 2*i) = K(2*i-1, 2*i) + k(1, 2);
    K(2*i-1, 2*j-1) = K(2*i-1, 2*j-1) + k(1, 3);
    K(2*i-1, 2*j) = K(2*i-1, 2*j) + k(1, 4);
    K(2*i, 2*i-1) = K(2*i, 2*i-1) + k(2, 1);
    K(2*i, 2*i) = K(2*i, 2*i) + k(2, 2);
    K(2*i, 2*j-1) = K(2*i, 2*j-1) + k(2, 3);
    K(2*i, 2*j) = K(2*i, 2*j) + k(2, 4);
    K(2*j-1, 2*i-1) = K(2*j-1, 2*i-1) + k(3, 1);
    K(2*j-1, 2*i) = K(2*j-1, 2*i) + k(3, 2);
    K(2*j-1, 2*j-1) = K(2*j-1, 2*j-1) + k(3, 3);
    K(2*j-1, 2*j) = K(2*j-1, 2*j) + k(3, 4);
    K(2*j, 2*i-1) = K(2*j, 2*i-1) + k(4, 1);
    K(2*j, 2*i) = K(2*j, 2*i) + k(4, 2);
    K(2*j, 2*j-1) = K(2*j, 2*j-1) + k(4, 3);
    K(2*j, 2*j) = K(2*j, 2*j) + k(4, 4);
    y = K;
endfunction
K = assembly(K,k1,1,2);
disp(K)
K = assembly(K,k2,2,3);
K = assembly(K,k3,3,4);
K = assembly(K,k4,2,4);
K = assembly(K,k5,2,5);
K = assembly(K,k6,4,5);
disp(K)
k = [K(3:4,3:4) K(3:4,7:10); K(7:10,3:4) K(7:10, 7:10)];
disp(k);
f = [0; 0; 0; -500; 0; -500];
u=k\f
disp(u)
U = [0; 0; u(1); u(2); 0; 0; u(3:6)];
disp("-----U-----:", U)
F = K * U;
disp("-----F-----:",F)
u1 = [U(1); U(2); U(3); U(4)];
u2 = [U(3); U(4); U(5); U(6)];
u3 = [U(5); U(6); U(7); U(8)];
u4 = [U(3); U(4); U(7); U(8)];
u5 = [U(3); U(4); U(9); U(10)];
u6 = [U(7); U(8); U(9); U(10)];
disp("u1:", u1)
function [y] = estress(E, L, theta, u)
    x = theta * %pi / 180;
    l = cos(x);
    m = sin(x);
    y = E / L * [-l -m l m] * u;
endfunction
s1 = estress(E, L1, theta1, u1);
s2 = estress(E, L2, theta2, u2);
s3 = estress(E, L3, theta3, u3);
s4 = estress(E, L4, theta4, u4);
s5 = estress(E, L5, theta5, u5);
s6 = estress(E, L6, theta6, u6);
disp("stresses", s1, s2, s3, s4, s5, s6)
//------------------------------------------------


// Definindo os parâmetros
xi = [0, 36, 0, 36, 72]; // Posições X dos nós iniciais
yi = [0, 0, 36, 36, 36]; // Posições Y dos nós iniciais

// Coordenadas dos nós após a deformação
xf = xi + [U(1), U(3), U(5), U(7), U(9)]; // deslocamento em x
yf = yi + [U(2), U(4), U(6), U(8), U(10)]; // deslocamento em y

// Estrutura original (antes da deformação)
X_original = [xi', yi'];

// Estrutura deformada (depois da deformação)
X_deformado = [xf', yf'];

// Configurando o gráfico
clf;
plot2d([0], [0], [-1, 2]); // Configura o gráfico para múltiplas curvas

// Desenhando as barras da estrutura original
for i = 1:6
    if i == 1 then
        plot([X_original(1,1), X_original(2,1)], [X_original(1,2), X_original(2,2)], '-b', "LineWidth", 2); // Elemento 1
    elseif i == 2 then
        plot([X_original(2,1), X_original(3,1)], [X_original(2,2), X_original(3,2)], '-b', "LineWidth", 2); // Elemento 2
    elseif i == 3 then
        plot([X_original(3,1), X_original(4,1)], [X_original(3,2), X_original(4,2)], '-b', "LineWidth", 2); // Elemento 3
    elseif i == 4 then
        plot([X_original(2,1), X_original(4,1)], [X_original(2,2), X_original(4,2)], '-b', "LineWidth", 2); // Elemento 4
    elseif i == 5 then
        plot([X_original(2,1), X_original(5,1)], [X_original(2,2), X_original(5,2)], '-b', "LineWidth", 2); // Elemento 5
    elseif i == 6 then
        plot([X_original(4,1), X_original(5,1)], [X_original(4,2), X_original(5,2)], '-b', "LineWidth", 2); // Elemento 6
    end
end

// Desenhando as barras da estrutura deformada
for i = 1:6
    if i == 1 then
        plot([X_deformado(1,1), X_deformado(2,1)], [X_deformado(1,2), X_deformado(2,2)], 'r--', "LineWidth", 2); // Elemento 1
    elseif i == 2 then
        plot([X_deformado(2,1), X_deformado(3,1)], [X_deformado(2,2), X_deformado(3,2)], 'r--', "LineWidth", 2); // Elemento 2
    elseif i == 3 then
        plot([X_deformado(3,1), X_deformado(4,1)], [X_deformado(3,2), X_deformado(4,2)], 'r--', "LineWidth", 2); // Elemento 3
    elseif i == 4 then
        plot([X_deformado(2,1), X_deformado(4,1)], [X_deformado(2,2), X_deformado(4,2)], 'r--', "LineWidth", 2); // Elemento 4
    elseif i == 5 then
        plot([X_deformado(2,1), X_deformado(5,1)], [X_deformado(2,2), X_deformado(5,2)], 'r--', "LineWidth", 2); // Elemento 5
    elseif i == 6 then
        plot([X_deformado(4,1), X_deformado(5,1)], [X_deformado(4,2), X_deformado(5,2)], 'r--', "LineWidth", 2); // Elemento 6
    end
end

// Configurando a legenda e os eixos
legend(["Estrutura original (antes)", "Estrutura deformada (depois)"], "in_lower_right");
title("Comparação da Estrutura Original e Deformada");
xlabel("X (polegadas)");
ylabel("Y (polegadas)");
xgrid(); // Adicionar grid ao gráfico

