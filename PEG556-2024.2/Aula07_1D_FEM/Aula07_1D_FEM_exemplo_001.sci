// Parâmetros fornecidos
E = 30e6;       // Módulo de Young (Pa)
A = 6.8;        // Área da seção transversal (m²)
lz = 65;        // Comprimento em z (m)
ly = 45;        // Comprimento em y (m)
G = 80e6;       // Módulo de cisalhamento (Pa)
J = 50;         // Momento de inércia polar (m^4)

// Forças aplicadas no nó 2
F = [0; 0; 0; 3000; 500; 300; 500; 300; 400];  // Vetor de forças (N)

// Montando a matriz de rigidez para um elemento de barra com 2 nós
// Apenas para exemplo, assumimos uma matriz de rigidez 6x6 para DOFs de translação e rotação

k = E * A / lz; // Constante de rigidez axial
kG = G * J / ly; // Constante de rigidez de torção

// Matriz de rigidez simplificada (6x6 para 2 nós com 3 DOFs por nó)
K = [
    k,  0,    0,   -k,  0,    0;
    0,  12*E*lz^3, 6*E*lz^2, 0, -12*E*lz^3, 6*E*lz^2;
    0,  6*E*lz^2,  4*E*lz,   0, -6*E*lz^2,  2*E*lz;
    -k, 0,    0,   k,   0,    0;
    0,  -12*E*lz^3, -6*E*lz^2, 0, 12*E*lz^3, -6*E*lz^2;
    0,  6*E*lz^2,  2*E*lz,   0, -6*E*lz^2,  4*E*lz
];

// Aplicando as condições de contorno
// Nós restringidos no nó 1, então DOFs 1, 2 e 3 são zero
K_reduced = K(4:6, 4:6);   // Removendo linhas e colunas dos DOFs restritos
F_reduced = F(4:6);        // Força aplicada no segundo nó

// Calculando os deslocamentos reduzidos
d_reduced = inv(K_reduced) * F_reduced;

// Montando o vetor completo de deslocamento (donde os deslocamentos no nó restrito são zeros)
d = [0; 0; 0; d_reduced];

// Exibindo resultados
disp("Deslocamentos nos graus de liberdade:");
disp(d);

// Calculando a torção
torcao = G * J / ly * d(6);  // Torção com base no último DOF

disp("Torção no nó 2:");
disp(torcao);
