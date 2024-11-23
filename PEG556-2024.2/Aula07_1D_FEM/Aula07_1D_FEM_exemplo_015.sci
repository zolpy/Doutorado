clc; clear
// Parâmetros do problema
E = 30e6;      // Módulo de Young (N/m^2)
A = 6.8;       // Área da seção transversal (m^2)
Iz = 65;       // Momento de inércia em torno do eixo z (m^4)
Iy = 45;       // Momento de inércia em torno do eixo y (m^4)
G = 80e6;      // Módulo de cisalhamento (N/m^2)
J = 50;        // Momento polar de inércia (m^4)
L = 1;         // Comprimento do elemento (m) - ajuste conforme necessário

// Cargas aplicadas no nó 2
f = zeros(12,1);
f(7) = 3000;
f(8) = 500;
f(9) = 300;
f(10) = 500;
f(11) = 300;
f(12) = 400;

// Cálculo dos termos da matriz de rigidez
k_axial = E * A / L;
k_torsion = G * J / L;
k_flex_y = E * Iz / (L^3);
k_flex_z = E * Iy / (L^3);

// Construção da matriz de rigidez
K = zeros(12,12);

// Elementos da matriz de rigidez axial
K(1,1) = k_axial;
K(7,7) = k_axial;
K(1,7) = -k_axial;
K(7,1) = -k_axial;

// Elementos da matriz de rigidez de torção
K(4,4) = k_torsion;
K(10,10) = k_torsion;
K(4,10) = -k_torsion;
K(10,4) = -k_torsion;

// Elementos da matriz de rigidez para flexão em y
K(3,3) = 12 * k_flex_y;
K(9,9) = 12 * k_flex_y;
K(3,9) = -12 * k_flex_y;
K(9,3) = -12 * k_flex_y;
K(5,5) = 4 * L^2 * k_flex_y;
K(11,11) = 4 * L^2 * k_flex_y;
K(3,11) = 6 * L * k_flex_y;
K(11,3) = 6 * L * k_flex_y;
K(9,11) = -6 * L * k_flex_y;
K(11,9) = -6 * L * k_flex_y;

// Elementos da matriz de rigidez para flexão em z
K(2,2) = 12 * k_flex_z;
K(8,8) = 12 * k_flex_z;
K(2,8) = -12 * k_flex_z;
K(8,2) = -12 * k_flex_z;
K(6,6) = 4 * L^2 * k_flex_z;
K(12,12) = 4 * L^2 * k_flex_z;
K(2,12) = 6 * L * k_flex_z;
K(12,2) = 6 * L * k_flex_z;
K(8,12) = -6 * L * k_flex_z;
K(12,8) = -6 * L * k_flex_z;

// Cálculo dos deslocamentos para os graus de liberdade não restringidos (nó 2)
K_reduced = K(7:12,7:12);
u_reduced = K_reduced \ f(7:12);

// Exibição dos resultados
disp("Deslocamentos e torções nos graus de liberdade não restringidos (nó 2):");
for i = 1:6
    disp("u(" + string(i+6) + ") = " + string(u_reduced(i)));
end
