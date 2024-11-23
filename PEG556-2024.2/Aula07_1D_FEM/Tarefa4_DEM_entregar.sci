clear; clc;

// Dados do problema
E = 30e6;  // Módulo de elasticidade (Pa)
A = 6.8; // Área da seção transversal (m²) - convertendo cm² para m²
Iz = 65; // Momento de inércia em z (m⁴) - convertendo cm⁴ para m⁴
Iy = 45; // Momento de inércia em y (m⁴) - convertendo cm⁴ para m⁴
G = 80e6;  // Módulo de cisalhamento (Pa)
J = 50; // Momento polar de inércia (m⁴) - convertendo cm⁴ para m⁴
L = 1;    


// Carregamentos no nó 2
f7 = 3000; // Força em x (N)
f8 = 500;  // Força em y (N)
f9 = 300;  // Força em z (N)
f10 = 500; // Momento em x (N.m) - convertendo N.cm para N.m
f11 = 300; // Momento em y (N.m) - convertendo N.cm para N.m
f12 = 400; // Momento em z (N.m) - convertendo N.cm para N.m

// Cálculo dos parâmetros para a matriz de rigidez
a = (E * A) / L;
bz = (E * Iz) / L^3;
by = (E * Iy) / L^3;
t = (G * J) / L;

// Matriz de rigidez completa (12x12)
K = [
    a,  0,      0,      0,  0,        0,        -a,  0,       0,      0,  0,        0 ;
    0,  12*bz,  0,      0,  0,        6*bz*L,    0, -12*bz,   0,      0,  0,        6*bz*L;
    0,  0,      12*by,  0, -6*by*L,   0,         0,  0,      -12*by,  0, -6*by*L,   0 ;
    0,  0,      0,      t,  0,        0,         0,  0,       0,     -t,  0,        0 ;
    0,  0,     -6*by*L, 0,  4*by*L^2, 0,         0,  0,      -6*by*L, 0,  2*by*L^2, 0 ;
    0,  6*bz*L, 0,      0,  0,        4*bz*L^2,  0, -6*bz*L,  0,      0,  0,        2*bz*L^2 ;
   -a,  0,      0,      0,  0,        0,         a,  0,       0,      0,  0,        0 ;
    0, -12*bz,  0,      0,  0,       -6*bz*L,    0,  12*bz,   0,      0,  0,       -6*bz*L;
    0,  0,     -12*by,  0, -6*by*L,   0,         0,  0,       12*by,  0,  6*by*L,   0 ;
    0,  0,      0,     -t,  0,        0,         0,  0,       0,      t,  0,        0 ;
    0,  0,     -6*by*L, 0,  2*by*L^2, 0,         0,  0,       6*by*L, 0,  4*by*L^2, 0 ;
    0,  6*bz*L, 0,      0,  0,        2*bz*L^2,  0, -6*bz*L,  0,      0,  0,        4*bz*L^2
];

// Vetor de carregamentos
F = [0; 0; 0; 0; 0; 0; f7; f8; f9; f10; f11; f12];

// Reduzindo a matriz K e o vetor F para os graus de liberdade do nó 2
K_reduced = K(7:12, 7:12);
F_reduced = F(7:12);

// Resolvendo para os deslocamentos e torções do nó 2
u_reduced = K_reduced \ F_reduced;

// Exibindo os resultados em notação científica
//disp("Deslocamentos e torção no segundo nó:");
//for i = 1:size(u_reduced, "r")
//    disp(msprintf("%.3e", u_reduced(i)));
//end

// Impressão dos resultados
// Exibindo a rotação em z em notação científica
mprintf("\n")
disp("Deslocamentos e torção do elemento:");
disp("Translação em x (m): " + msprintf("%.3e", u_reduced(1)));
disp("Translação em y (m): " + msprintf("%.3e", u_reduced(2)));    
disp("Translação em z (m): " + msprintf("%.3e", u_reduced(3)));
mprintf("\n")
disp("Rotação em x (rad): " + msprintf("%.3e", u_reduced(4)));
disp("Rotação em y (rad): " + msprintf("%.3e", u_reduced(5)));
disp("Rotação em z (rad): " + msprintf("%.3e", u_reduced(6)));




