// Dados do problema com L = 1 para uma solução aproximada
E = 30e6;       // Módulo de elasticidade em psi
A = 6.8;        // Área da seção transversal em polegadas^2
Iz = 65;        // Momento de inércia em relação ao eixo z em polegadas^4
Iy = 45;        // Momento de inércia em relação ao eixo y em polegadas^4
G = 80e6;       // Módulo de cisalhamento em psi
J = 50;         // Constante de torção em polegadas^4
L = 1;          // Comprimento da barra assumido como 1 (valor arbitrário)

// Cargas aplicadas no segundo nó (em libras)
f = zeros(12,1);   // Vetor de forças
f(7) = 3000;
f(8) = 500;
f(9) = 300;
f(10) = 500;
f(11) = 300;
f(12) = 400;

// Matriz de rigidez do elemento em 3D para um elemento barra
// Componentes axiais, de flexão e torção
k_axial = E * A / L;
k_flex_y = 12 * E * Iz / L^3;
k_flex_z = 12 * E * Iy / L^3;
k_torsion = G * J / L;

// Montagem da matriz de rigidez do elemento (12x12)
K = zeros(12,12);

// Posição da rigidez axial
K(1,1) = k_axial;    K(1,7) = -k_axial;
K(7,1) = -k_axial;   K(7,7) = k_axial;

// Rigidez à flexão em y
K(2,2) = k_flex_y;   K(2,8) = -k_flex_y;
K(8,2) = -k_flex_y;  K(8,8) = k_flex_y;

// Rigidez à flexão em z
K(3,3) = k_flex_z;   K(3,9) = -k_flex_z;
K(9,3) = -k_flex_z;  K(9,9) = k_flex_z;

// Rigidez à torção
K(4,4) = k_torsion;  K(4,10) = -k_torsion;
K(10,4) = -k_torsion; K(10,10) = k_torsion;

// Considerando as restrições (primeiro nó fixo)
K_reduced = K(7:12, 7:12);
f_reduced = f(7:12);

// Calculando os deslocamentos do segundo nó
u_reduced = K_reduced \ f_reduced;

// Exibindo os resultados
disp("Deslocamentos e torção no segundo nó:");
disp(u_reduced);
