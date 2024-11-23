clear; clc

// Constantes das molas
k1 = 200;  // mola de A até B
k2 = 100;  // mola de B até C
k3 = 150;  // mola de B até C
k4 = 300;  // mola de A até D
k5 = 400;  // mola de C até D
k6 = 500;  // mola de D até E

// Sistema de equações de equilíbrio
// Montamos a matriz K e o vetor de forças F
K = [ k1+k4,     -k1,        -k4;
      -k1,   k1+k2+k3,   -(k2+k3);
      -k4, -(k2+k3),  k4+k5+k6];

F = [400; 300; 500]; // Sem forças externas, apenas as forças internas

// Solução para os deslocamentos
u = inv(K) * F;

// Exibindo os resultados
disp("Deslocamentos em B, C, D:", u)

//  "Vetor u:"
//   1.9208103
//   2.2044199
//   1.6316759
