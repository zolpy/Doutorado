// Definir parâmetros
E = 200e9;          // Módulo de elasticidade (Pa)
A = 400e-6;         // Área da seção transversal (m^2)
L = 2;              // Comprimento das barras (m)

// Definir a matriz de rigidez local para uma barra
function K = barraRigidez(E, A, L, theta)
    c = cos(theta); s = sin(theta);
    K = (E * A / L) * [c^2,  c*s, -c^2, -c*s;
                       c*s,  s^2, -c*s, -s^2;
                      -c^2, -c*s,  c^2,  c*s;
                      -c*s, -s^2,  c*s,  s^2];
endfunction

// Coordenadas dos nós
nodos = [0, 0;  // Nó A
         2, 0;  // Nó B
         2, 2;  // Nó C
         0, 2]; // Nó D

// Conectividade das barras (nós conectados)
barras = [1, 2;  // Barra AB
          2, 3;  // Barra BC
          3, 4;  // Barra CD
          1, 4;  // Barra AD
          1, 3;  // Barra AC
          4, 2]; // Barra DB

// Número de nós e barras
nNodos = size(nodos, 1);
nBarras = size(barras, 1);

// Inicializar a matriz de rigidez global
Kglobal = zeros(2*nNodos, 2*nNodos);

// Calcular matriz de rigidez para cada barra e montar a global
for i = 1:nBarras
    n1 = barras(i, 1);
    n2 = barras(i, 2);
    x1 = nodos(n1, 1); y1 = nodos(n1, 2);
    x2 = nodos(n2, 1); y2 = nodos(n2, 2);
    
    Lbarra = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    theta = atan((y2 - y1) / (x2 - x1));
    
    Klocal = barraRigidez(E, A, Lbarra, theta);
    
    // Graus de liberdade globais para nós n1 e n2
    dofs = [2*n1-1, 2*n1, 2*n2-1, 2*n2];
    
    // Adicionar Klocal à matriz de rigidez global
    Kglobal(dofs, dofs) = Kglobal(dofs, dofs) + Klocal;
end
clear, clc
// Aplicar condições de contorno (nós fixos)
restricoes = [1, 2, 7, 8];  // Fixar nós A e D
Kglobal(restricoes, :) = [];
Kglobal(:, restricoes) = [];

// Vetor de forças (somente no nó B na direção y)
F = zeros(2*nNodos, 1);
F(6) = -100e3;  // Força de 100 kN para baixo no nó B

// Remover graus de liberdade restritos
F(restricoes) = [];

// Resolver para deslocamentos
desloc = Kglobal \ F;

// Exibir deslocamentos
disp("Deslocamentos nos nós livres:");
disp(desloc);
