clear;clc
// Dados do problema
E = 30e6;  // Módulo de elasticidade (Pa)
A = 6.8;   // Área da seção transversal (cm2)
Iz = 65;   // Momento de inércia em z (cm4)
Iy = 45;   // Momento de inércia em y (cm4)
G = 80e6;  // Módulo de cisalhamento (Pa)
J = 50;    // Momento polar de inércia (cm4)
L  =90;

// Carregamentos no nó 2
f7 = 3000; // Força em x (N)
f8 = 500;  // Força em y (N)
f9 = 300;  // Força em z (N)
f10 = 500; // Momento em x (N.cm)
f11 = 300; // Momento em y (N.cm)
f12 = 400; // Momento em z (N.cm)

a = (E*A)/L;
bz = (E*Iz)/L^3;
by= (E*Iy)/L^3;
t= (G*J)/L;

K=[ a  0      0      0  0        0        -a  0       0      0  0        0 ;
     0  12*bz  0      0  0        6*bz*L    0 -12*bz   0      0  0        6*bz*L;
     0  0      12*by  0 -6*bz*L   0         0  0      -12*by  0 -6*by*L   0 ;
     0  0      0      t  0        0         0  0       0     -t  0        0 ;
     0  0     -6*by*L 0  4*by*L^2 0         0  0      -6*by*L 0  2*by*L^2 0 ;
     0  6*by*L 0      0  0        4*bz*L^2  0 -6*bz*L  0      0  0        2*bz*L^2 ;
    -a  0      0      0  0        0         a  0       0      0  0        0 ;
     0 -12*bz  0      0  0       -6*bz*L    0  12*bz   0      0  0       -6*bz*L;
     0  0     -12*by  0 -6*by*L   0         0  0       12*by  0  6*by*L   0 ;
     0  0      0     -t  0        0         0  0       0      t  0        0 ;
     0  0     -6*by*L 0  2*by*L^2 0         0  0       6*by*L 0  4*by*L^2 0 ;
     0  6*bz*L 0      0  0        2*bz*L^2  0 -6*bz*L  0      0  0        4*bz*L^2 ];

// Vetor de carregamentos
F = [0;0;0;0;0;0;f7; f8; f9; f10; f11; f12];


// Resolução
u = K\F;

mprintf("Matriz u\n")
disp(u)
// Impressão dos resultados
//disp("Deslocamentos e torção do elemento:");
//disp("Translação em x (cm): " + string(u(1)));
//disp("Translação em y (cm): " + string(u(2)));  
//disp("Translação em z (cm): " + string(u(3)));
//disp("Rotação em x (rad): " + string(u(4)));
//disp("Rotação em y (rad): " + string(u(5)));
//disp("Rotação em z (rad): " + string(u(6)));      
//disp("Rotação em x (rad): " + string(u(7)));
//disp("Rotação em y (rad): " + string(u(8)));
//disp("Rotação em z (rad): " + string(u(9)));
