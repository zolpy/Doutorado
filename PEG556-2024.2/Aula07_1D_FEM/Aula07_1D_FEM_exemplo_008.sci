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
disp("Deslocamentos e torção do elemento:");
disp("Translação em x (m): " + string(u(1), 'e')); // Exibindo em notação científica
disp("Translação em y (m): " + string(u(2), 'e'));  
disp("Translação em z (m): " + string(u(3), 'e'));
disp("Rotação em x (rad): " + string(u(4), 'e'));
disp("Rotação em y (rad): " + string(u(5), 'e'));
disp("Rotação em z (rad): " + string(u(6), 'e'));
/*
disp("Deslocamentos e torção do elemento:");
disp("Translação em x (cm): " + string(u(1) * 1e-7)); // Convertendo para cm
disp("Translação em y (cm): " + string(u(2) * 1e-9));  
disp("Translação em z (cm): " + string(u(3) * 1e-8));
disp("Rotação em x (rad): " + string(u(4) * 1e-9));
disp("Rotação em y (rad): " + string(u(5) * 1e-9));
disp("Rotação em z (rad): " + string(u(6) * 1e-9));
// Impressão dos resultados na notação científica correta
/*
disp("Deslocamentos e torção do elemento:");
disp("Translação em x (m): " + string(u(1), '%.2e')); // Exibindo em notação científica
disp("Translação em y (m): " + string(u(2), '%.2e'));  
disp("Translação em z (m): " + string(u(3), '%.2e'));
disp("Rotação em x (rad): " + string(u(4), '%.2e'));
disp("Rotação em y (rad): " + string(u(5), '%.2e'));
disp("Rotação em z (rad): " + string(u(6), '%.2e'));
*/
