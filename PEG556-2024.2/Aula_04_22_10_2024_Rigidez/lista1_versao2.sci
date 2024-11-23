clear; clc

// Definindo as constantes de rigidez
K1 = 200; K2 = 100; K3 = 150; K4 = 300; K5 = 400; K6 = 500;

// Montando a matriz de rigidez
K = [K1+K2 -K2 0;
     -K2 K2+K3+K4 -K4;
     0 -K4 K4+K5+K6];

// Vetor de forças
F = [400; 300; 500];

// Resolvendo o sistema de equações
U = inv(K)*F;

// Imprimindo os resultados
disp("Deslocamentos:");
disp("Ub = ", U(1));
disp("Uc = ", U(2));
disp("Ud = ", U(3));

//  "Deslocamentos:"
//  "Ub = "
//   1.7547170
//  "Uc = "
//   1.2641509
//  "Ud = "
//   0.7327044
