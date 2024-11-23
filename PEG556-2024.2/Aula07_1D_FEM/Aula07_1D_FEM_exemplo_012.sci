clear;clc
// Dados do problema
E = 30e6;  // Módulo de elasticidade (Pa)
A = 6.8;   // Área da seção transversal (cm2)
Iz = 65;   // Momento de inércia em z (cm4)
Iy = 45;   // Momento de inércia em y (cm4)
G = 80e6;  // Módulo de cisalhamento (Pa)
J = 50;    // Momento polar de inércia (cm4)

// Carregamentos no nó 2
f7 = 3000; // Força em x (N)
f8 = 500;  // Força em y (N)
f9 = 300;  // Força em z (N)
f10 = 500; // Momento em x (N.cm)
f11 = 300; // Momento em y (N.cm)
f12 = 400; // Momento em z (N.cm)

// Matrizes de rigidez
Kl = [E*A/100, 0, 0, 0, 0, 0;
     0, 12*E*Iz/100^3, 0, 0, 0, -6*E*Iz/100^2;
     0, 0, 12*E*Iy/100^3, 0, 6*E*Iy/100^2, 0;
     0, 0, 0, G*J/100, 0, 0;
     0, 0, 6*E*Iy/100^2, 0, 4*E*Iy/100, 0;
     0, -6*E*Iz/100^2, 0, 0, 0, 4*E*Iz/100];

// Vetores de deslocamento e rotação
d = [f7; f8; f9; f10; f11; f12];

// Resolução
u = Kl\d;

// Impressão dos resultados
disp("Deslocamentos e torção do elemento:");
disp("Translação em x (cm): " + string(u(1)));
disp("Translação em y (cm): " + string(u(2)));  
disp("Translação em z (cm): " + string(u(3)));
disp("Rotação em x (rad): " + string(u(4)));
disp("Rotação em y (rad): " + string(u(5)));
disp("Rotação em z (rad): " + string(u(6)));
