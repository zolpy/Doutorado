// Limpeza do ambiente
clear; clc;

// Definição de dados de entrada
E = 30e6;           // Módulo de elasticidade em N/m^2
A = 6.8;            // Área da seção transversal em m^2
Iz = 65;            // Momento de inércia em m^4
Iy = 45;            // Momento de inércia em m^4
G = 80e6;           // Módulo de elasticidade transversal em N/m^2
J = 50;             // Constante de torção em m^4
L = 90;             // Comprimento do elemento em m

// Definição do vetor de forças
f = zeros(12, 1);   // Vetor de forças de 12 graus de liberdade
f(7) = 3000.0;
f(8) = 500;
f(9) = 300;
f(10) = 500;
f(11) = 300;
f(12) = 400;

// Parâmetros auxiliares para a matriz de rigidez
a = E * A / L;
bz = E * Iz / (L^3);
by = E * Iy / (L^3);
t = G * J / L;

// Montagem da matriz de rigidez
K = [
    a     0         0         0          0         0       -a     0         0         0         0         0;
    0  12*bz        0         0          0    6*bz*L        0 -12*bz        0         0         0    6*bz*L;
    0      0     12*by        0   -6*by*L         0        0      0   -12*by        0   -6*by*L        0;
    0      0         0        t          0         0        0      0         0        -t         0        0;
    0      0   -6*by*L        0   4*by*L^2        0        0      0   -6*by*L        0   2*by*L^2     0;
    0  6*by*L        0        0          0   4*bz*L^2       0 -6*bz*L        0         0        0   2*bz*L^2;
   -a     0         0         0         0         0         a     0         0         0        0        0;
    0 -12*bz        0         0         0   -6*bz*L         0 12*bz        0         0        0   -6*bz*L;
    0      0   -12*by         0    -6*by*L        0        0      0   -12*by         0    6*by*L       0;
    0      0         0       -t         0         0         0      0        0          t        0        0;
    0      0   -6*by*L        0   2*by*L^2        0        0      0   6*by*L         0   4*by*L^2    0;
    0 6*bz*L        0         0         0   2*bz*L^2       0 -6*bz*L       0         0        0   4*bz*L^2;
];

// Aplicação das condições de contorno
fixedNodes = [1, 2, 3, 4, 5, 6];  // Nós fixos
freeNodes = setdiff(1:12, fixedNodes); // Nós livres

// Redução da matriz K e do vetor f
K_reduced = K(freeNodes, freeNodes);
f_reduced = f(freeNodes);

// Solução do sistema para encontrar deslocamentos
U_reduced = K_reduced \ f_reduced;

// Colocando os deslocamentos nos graus de liberdade corretos
U = zeros(12, 1);
U(freeNodes) = U_reduced;
disp("Deslocamentos nos graus de liberdade:");
disp(U);

// Verificação de valores aproximados esperados
expected_d = [1.47e-5; 1.88e-7; 5.29e-9; 1.25e-7; 4.76e-8; 3.33e-7];
disp("Valores esperados para o deslocamento:");
disp(expected_d);

// Exibindo os resultados em notação científica
//disp("Deslocamentos e torção no segundo nó:");
//for i = 1:size(U, "r")
//    disp(msprintf("%.3e", U(i)));
//end
