clear, clc

// Definindo parâmetros
E = 21e5; // Módulo de elasticidade (kgf/cm^2)
A1 = 1; // Área das barras 1 a 4 (cm^2)
A2 = sqrt(2); // Área das barras 5 e 6 (cm^2)
L = 21; // Comprimento das barras (cm)
F = 1000; // Força aplicada no nó superior (kgf)

// Definindo as coordenadas dos nós
nodes = [
    0, 0;  // Nó 1
    L, 0;  // Nó 2
    L, L;  // Nó 3
    0, L   // Nó 4
];

// Definindo as conexões das barras
bars = [
    1, 2;  // Barra 1
    2, 3;  // Barra 2
    3, 4;  // Barra 3
    4, 1;  // Barra 4
    1, 3;  // Barra 5 (diagonal)
    2, 4   // Barra 6 (diagonal)
];

// Função para calcular a rigidez de uma barra
function [K] = stiffness_matrix(E, A, Lx, Ly, L)
    c = Lx / L; // Coseno
    s = Ly / L; // Seno
    k = (E * A) / L;
    K = k * [
        c^2, c*s, -c^2, -c*s;
        c*s, s^2, -c*s, -s^2;
       -c^2, -c*s, c^2, c*s;
       -c*s, -s^2, c*s, s^2
    ];
endfunction

// Montando a matriz de rigidez global
K_global = zeros(8, 8);

for i = 1:size(bars, 1)
    n1 = bars(i, 1);
    n2 = bars(i, 2);
    x1 = nodes(n1, 1);
    y1 = nodes(n1, 2);
    x2 = nodes(n2, 1);
    y2 = nodes(n2, 2);
    Lx = x2 - x1;
    Ly = y2 - y1;
    L_bar = sqrt(Lx^2 + Ly^2);
    
    if i <= 4 then
        A = A1; // Barras 1 a 4
    else
        A = A2; // Barras 5 e 6
    end
    
    K = stiffness_matrix(E, A, Lx, Ly, L_bar);
    
    // Mapear para a matriz global
    dof = [2*n1-1, 2*n1, 2*n2-1, 2*n2];
    for r = 1:4
        for c = 1:4
            K_global(dof(r), dof(c)) = K_global(dof(r), dof(c)) + K(r, c);
        end
    end
end

// Condições de contorno (Nós 1 e 4 são fixos, deslocamento zero)
K_reduced = K_global(3:8, 3:8);

// Força aplicada no nó 3 (vertical)
F_global = zeros(8, 1);
F_global(6) = -F;

// Solução do sistema de equações
F_reduced = F_global(3:8);
displacement = K_reduced \ F_reduced;

// Mostrando os deslocamentos dos nós livres
disp('Deslocamentos (em cm):');
disp(displacement);


 "Deslocamentos (em cm):"
  -0.0012500
  -0.0050000
   0.0012500
  -0.0087500
   0.
  -0.0012500
