clear, clc

// Constantes das molas
k1 = 200;  // mola de A até B
k2 = 100;  // mola de B até C
k3 = 150;  // mola de B até C
k4 = 300;  // mola de A até D
k5 = 400;  // mola de C até D
k6 = 500;  // mola de D até E

// Matriz de rigidez K considerando os deslocamentos em B, C, D
K = [ k1+k2+k3, -(k2+k3),     0;
     -(k2+k3),  k2+k3+k5,   -k5;
      0,       -k5,   k4+k5+k6];

// Vetor de forças externas
F = [400; 300; 500]  // Forças externas zero

// Solução para os deslocamentos u em B, C, D
u = inv(K) * F;

// Exibindo o resultado
disp("Deslocamentos em B, C, D:", u)

//  "Deslocamentos em B, C, D:"
//   1.9019608
//   1.8235294
//   1.0245098
