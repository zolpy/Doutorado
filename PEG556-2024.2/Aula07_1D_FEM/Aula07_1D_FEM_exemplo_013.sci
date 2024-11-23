clc; clear

// Dados do problema
E = 30e6;   // Módulo de elasticidade (N/m²)
A = 0.068; // Área da seção transversal (m²)
Iz = 65e-8; // Momento de inércia em z (m⁴)
Iy = 45e-8; // Momento de inércia em y (m⁴)
G = 80e6;   // Módulo de cisalhamento (N/m²)
J = 50e-8;  // Momento polar de inércia (m⁴)

// Carregamentos no nó 2
f7 = 3000;       // Força em x (N)
f8 = 500;        // Força em y (N)
f9 = 300;        // Força em z (N)
f10 = 500 / 100; // Convertendo momento para N.m (500 N.cm para N.m)
f11 = 300 / 100; // Convertendo momento para N.m (300 N.cm para N.m)
f12 = 400 / 100; // Convertendo momento para N.m (400 N.cm para N.m)

// Matrizes de rigidez
Kl = [E*A,         0,              0,               0,              0,              0;
      0,           (12*E*Iz),      (6*E*Iz),        (-12*E*Iz),     (-6*E*Iz),     G*J;
      0,           (6*E*Iz),       (12*E*Iy),       (-6*E*Iy),      (6*E*Iy),      G*J;
      (-12*E*Iz), (-6*E*Iy),      G*J,             G*J,           (-4*E*Iy),     (-6*E*Iz);
      (-6*E*Iz),   (6*E*Iy),       (-4*E*Iy),       G*J,           G*J,           (-6*E*Iz);
      G*J,         G*J,            (-6*E*Iz),       (-6*E*Iz),     G*J,           G*J];

// Vetor de carregamentos
F = [f7; f8; f9; f10; f11; f12]; // Deve ser um vetor coluna com os elementos corretos

// Resolução
u = Kl\F;

// Impressão dos resultados na notação científica correta
disp("Deslocamentos e torção do elemento:");
disp("Translação em x (m): " + msprintf('%.2e', u(1))); 
disp("Translação em y (m): " + msprintf('%.2e', u(2)));  
disp("Translação em z (m): " + msprintf('%.2e', u(3)));
disp("Rotação em x (rad): " + msprintf('%.2e', u(4)));
disp("Rotação em y (rad): " + msprintf('%.2e', u(5)));
disp("Rotação em z (rad): " + msprintf('%.2e', u(6)));
