clear, clc
// Definindo as rigidezes das molas
K1 = 200; // Kgf/mm
K2 = 100; // Kgf/mm
K3 = 150; // Kgf/mm
K4 = 300; // Kgf/mm
K5 = 400; // Kgf/mm
K6 = 500; // Kgf/mm

// Criando as matrizes de rigidez locais
K_local1 = [K1, -K1; -K1, K1];
K_local2 = [K2, -K2; -K2, K2];
K_local3 = [K3, -K3; -K3, K3];
K_local4 = [K4, -K4; -K4, K4];
K_local5 = [K5, -K5; -K5, K5];
K_local6 = [K6, -K6; -K6, K6];

disp("K_1", K_local1);
disp("K_2", K_local2);
disp("K_3", K_local3);
disp("K_4", K_local4);
disp("K_5", K_local5);
disp("K_6", K_local6);


// Montando a matriz de rigidez global
K_global = zeros(5, 5); // 5 nós (A, B, C, D, E)
disp("K_global",K_global)

// A e E são nós fixos, então suas linhas e colunas são zeradas
K_global(1, 1) = K1; // K_A (A)
disp("K_global(1, 1)",K_global(1, 1))

K_global(1, 2) = -K1; // -K_A (A, B)
disp("K_global(1, 2)",K_global(1, 2))

K_global(2, 1) = -K1; // -K_A (B, A)
disp("K_global(2, 1)",K_global(2, 1))

K_global(2, 2) = K1 + K2 + K3 + K4; // K_B (B)
disp("K_global(2, 2)",K_global(2, 2))

K_global(2, 3) = -K2 - K3; // -K_C (B, C)
disp("K_global(2, 3)",K_global(2, 3))

K_global(2, 4) = -K4; // -K_D (B, D)
disp("K_global(2, 4)",K_global(2, 4))

K_global(3, 2) = -K2 - K3; // -K_C (C, B)
disp("K_global(3, 2)",K_global(3, 2))

K_global(3, 3) = K2 + K3 + K5; // K_C (C)
disp("K_global(3, 3)",K_global(3,3))

K_global(3, 4) = -K5; // -K_D (C, D)
disp("K_global(3, 4)",K_global(3, 4))

K_global(4, 2) = -K4; // -K_D (D, B)
disp("K_global(4, 2)",K_global(4, 2))

K_global(4, 3) = -K5; // -K_D (D, C)
disp("K_global(4, 3)",K_global(4, 3))

K_global(4, 4) = K4 + K5 + K6; // K_D (D)
disp("K_global(4, 4)",K_global(4, 4))

K_global(4, 5) = -K6; // -K_E (D, E)
disp("K_global(4, 5)",K_global(4, 5))

K_global(5, 4) = -K6; // -K_E (E, D)
disp("K_global(5, 4)",K_global(5, 4))

K_global(5, 5) = K6; // K_E (E)
disp("K_global(5, 5)",K_global(5, 5))

// Removendo as linhas e colunas correspondentes aos nós fixos (A e E)
K_reduced = K_global(2:4, 2:4); // 3x3
disp("K_reduced",K_reduced)

// Definindo o vetor de forças aplicadas
F = [0; 400; 300; 500]; // Forças aplicadas em B e C
disp("F", F)

// Ajustando o vetor de forças
F_reduced = F(2:4); // Removendo forças em A e E
disp("F_reduced", F_reduced)

// Resolvendo o sistema de equações K * U = F
U_reduced = inv(K_reduced) * F_reduced;
disp("U_reduced",U_reduced)

// Exibindo os resultados
disp("Deslocamentos nos nós B, C e D:");
disp(U_reduced);


  "U_reduced"
   1.9655172
   2.1172414
   1.6137931
  "Deslocamentos nos nós B, C e D:"
   1.9655172
   2.1172414
   1.6137931
