clear, clc
// Definir os valores de rigidez das molas
K1 = 200;  // mola entre A e B
K2 = 100;  // mola vertical em B
K3 = 150;  // mola entre B e C
K4 = 300;  // mola horizontal em C
K5 = 400;  // mola entre C e D
K6 = 500;  // mola entre D e E

// Montar a matriz de rigidez global (5x5)
K_global = [
    K1,   -K1,    0,     0,     0;
   -K1, K1+K2+K3, -K3,    0,     0;
    0,   -K3, K3+K4+K5, -K5,    0;
    0,     0,   -K5,  K5+K6, -K6;
    0,     0,     0,   -K6,   K6
];

// Exibir a matriz de rigidez global
disp( "Matriz de Rigidez Global (5x5):", K_global);

// Definir os nós fixos (nó A = 1 e nó E = 5)
nos_fixos = [1, 5];

// Remover as linhas e colunas correspondentes aos nós fixos
K_reduzida = K_global;
K_reduzida(nos_fixos, :) = [];  // Remove as linhas dos nós fixos
K_reduzida(:, nos_fixos) = [];  // Remove as colunas dos nós fixos

disp("")
// Exibir a matriz de rigidez reduzida (3x3)
disp("Matriz de Rigidez Reduzida (3x3):", K_reduzida);

// Vetor de forças nos nós B, C, D
F = [400; 300; 500];  // Forças aplicadas em B, C, D

// Resolver o sistema de equações
U = K_reduzida \ F;  // Deslocamentos U_B, U_C, U_D

disp("")
// Exibir os deslocamentos
disp("Deslocamentos nos nós B, C e D:", U);


//  "Matriz de Rigidez Global (5x5):"
//   200.  -200.   0.     0.     0.  
//  -200.   450.  -150.   0.     0.  
//   0.    -150.   850.  -400.   0.  
//   0.     0.    -400.   900.  -500.
//   0.     0.     0.    -500.   500.
//  ""
//  "Matriz de Rigidez Reduzida (3x3):"
//   450.  -150.   0.  
//  -150.   850.  -400.
//   0.    -400.   900.
//  ""
//  "Deslocamentos nos nós B, C e D:"
//   1.2400794
//   1.0535714
//   1.0238095

