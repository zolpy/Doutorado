clear, clc
// Definir os valores de rigidez das molas
K1 = 200;  // mola entre A e B
K2 = 100;  // mola vertical em B
K3 = 150;  // mola entre B e C
K4 = 300;  // mola horizontal em C
K5 = 400;  // mola entre C e D
K6 = 500;  // mola entre D e E


m = [1,-1;-1,1]
MK1 = m*K1 //2x2
M1 = [MK1, zeros(2,3);zeros(3,5)]

disp(M1, "Deslocamentos nos nós B, C e D:");
