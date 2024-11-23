clc; clear
// Parâmetros fornecidos
E = 30e6;       // Módulo de Elasticidade (Pa)
A = 6.8;        // Área da seção transversal (m²)
Iz = 65;        // Momento de inércia em torno do eixo z (m⁴)
Iy = 45;        // Momento de inércia em torno do eixo y (m⁴)
G = 80e6;       // Módulo de cisalhamento (Pa)
J = 50;         // Momento de inércia polar (m⁴)
L = 1;          // Comprimento do elemento (m)

// Forças aplicadas no segundo nó
F = [0; 0; 0; 3000; 500; 300; 500; 300; 400];  // Vetor de forças (N)

// Montando a matriz de rigidez 6x6 para DOFs de translação e rotação
EA_L = E * A / L;
EIy_L3 = E * Iy / L^3;
EIz_L3 = E * Iz / L^3;
GJ_L = G * J / L;

// Matriz de rigidez simplificada (considerando deslocamento axial, flexão e torção)
K = [
    EA_L,  0,       0,       -EA_L,   0,       0;
    0,  12*EIz_L3,  0,        0,    -12*EIz_L3, 0;
    0,     0,    12*EIy_L3,   0,       0,    -12*EIy_L3;
   -EA_L,   0,       0,        EA_L,   0,       0;
    0, -12*EIz_L3,  0,        0,     12*EIz_L3, 0;
    0,     0,   -12*EIy_L3,   0,       0,     12*EIy_L3;
];

// Reduzindo a matriz de rigidez e vetor de força para os graus de liberdade do nó 2
K_reduced = K(4:6, 4:6);   // Removendo linhas e colunas dos DOFs restritos (nó 1)
F_reduced = F(4:6);        // Força aplicada no segundo nó

// Calculando os deslocamentos reduzidos
d_reduced = inv(K_reduced) * F_reduced;

// Montando o vetor completo de deslocamento
d = [0; 0; 0; d_reduced];

// Exibindo resultados
disp("Deslocamentos nos graus de liberdade:");
disp(d);

// Calculando a torção
torcao = GJ_L * d(6);  // Torção baseada no deslocamento angular final

disp("Torção no nó 2:");
disp(torcao);
