// Dados do problema
E = 30e6;   // Módulo de elasticidade (N/m²)
A = 0.068; // Área da seção transversal (m²)
Iz = 65e-8; // Momento de inércia em z (m⁴)
Iy = 45e-8; // Momento de inércia em y (m⁴)
G = 80e6;   // Módulo de cisalhamento (N/m²)
J = 50e-8;  // Momento polar de inércia (m⁴)

// Carregamentos no nó 2
f7 = 3000;   // Força em x (N)
f8 = 500;    // Força em y (N) 
f9 = 300;    // Força em z (N)
f10 = 50000; // Momento em x (N.m)
f11 = 30000; // Momento em y (N.m) 
f12 = 40000; // Momento em z (N.m)

// Matrizes de rigidez
Kl = [E*A, 0, 0, 0, 0, 0;
     0, 12*E*Iz, 0, 0, 0, -6*E*Iz;
     0, 0, 12*E*Iy, 0, 6*E*Iy, 0;
     0, 0, 0, G*J, 0, 0;
     0, 0, 6*E*Iy, 0, 4*E*Iy, 0;
     0, -6*E*Iz, 0, 0, 0, 4*E*Iz];

// Vetor de carregamentos
F = [f7; f8; f9; f10; f11; f12];

// Resolução
u = Kl\F;

// Impressão dos resultados
disp("Deslocamentos e torção do elemento:");
disp("Translação em x (m): " + string(u(1)));
disp("Translação em y (m): " + string(u(2)));  
disp("Translação em z (m): " + string(u(3)));
disp("Rotação em x (rad): " + string(u(4)));
disp("Rotação em y (rad): " + string(u(5)));
disp("Rotação em z (rad): " + string(u(6)));
