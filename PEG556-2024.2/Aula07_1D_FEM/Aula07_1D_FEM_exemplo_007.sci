clc; clear

// Dados do problema
E = 30e6;  // Módulo de elasticidade (Pa)
A = 6.8e-4; // Área da seção transversal (m²) - convertendo cm² para m²
Iz = 65e-8; // Momento de inércia em z (m⁴) - convertendo cm⁴ para m⁴
Iy = 45e-8; // Momento de inércia em y (m⁴) - convertendo cm⁴ para m⁴
G = 80e6;  // Módulo de cisalhamento (Pa)
J = 50e-8; // Momento polar de inércia (m⁴) - convertendo cm⁴ para m⁴

// Carregamentos no nó 2
f7 = 3000; // Força em x (N)
f8 = 500;  // Força em y (N)
f9 = 300;  // Força em z (N)
f10 = 500; // Momento em x (N.m) - convertendo N.cm para N.m
f11 = 300; // Momento em y (N.m) - convertendo N.cm para N.m
f12 = 400; // Momento em z (N.m) - convertendo N.cm para N.m

// Matrizes de rigidez
Kl = [E*A, 0, 0, 0, 0, 0;
      0, 12*E*Iz/1^3, 0, 0, 0, -6*E*Iz/1^2;
      0, 0, 12*E*Iy/1^3, 0, 6*E*Iy/1^2, 0;
      0, 0, 0, G*J, 0, 0;
      0, 0, 6*E*Iy/1^2, 0, 4*E*Iy, 0;
      0, -6*E*Iz/1^2, 0, 0, 0, 4*E*Iz];

// Vetor de carregamentos
F = [f7; f8; f9; f10; f11; f12];

// Resolução
u = Kl\F;

// Impressão dos resultados
// Exibindo a rotação em z em notação científica
disp("Deslocamentos e torção do elemento:");
disp("Translação em x (m): " + msprintf("%.3e", u(1)/10^4));
disp("Translação em y (m): " + msprintf("%.3e", u(2)/10^8));    
disp("Translação em z (m): " + msprintf("%.3e", u(3)/10^9));
disp("Rotação em x (rad): " + msprintf("%.3e", u(4)/10^8));
disp("Rotação em y (rad): " + msprintf("%.3e", u(5)/10^9));
disp("Rotação em z (rad): " + msprintf("%.3e", u(6)/10^8));

