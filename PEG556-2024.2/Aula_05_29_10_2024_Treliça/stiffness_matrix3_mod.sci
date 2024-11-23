clear, clc

// Definindo parâmetros
E = 21e5; // Módulo de elasticidade (kgf/cm^2)
A1 = 1; // Área das barras 1 a 4 (cm^2)
A2 = sqrt(2); // Área das barras 5 e 6 (cm^2)
L = 21; // Comprimento das barras horizontais e verticais (cm)
F = 1000; // Força aplicada no nó superior (kgf)

// Definindo as coordenadas dos nós
nodes = [
    0, 0;  // Nó 1
    0, L;  // Nó 2
    L, 0;  // Nó 3
    L, L   // Nó 4
];

// Definindo as conexões das barras (elementos da treliça)
bars = [
    4, 1;  // Barra 1 (vertical esquerda)
    1, 2;  // Barra 2 (horizontal inferior)
    2, 3;  // Barra 3 (vertical direita)
    3, 4;  // Barra 4 (horizontal superior)
    1, 3;  // Barra 5 (diagonal crescente)
    2, 4   // Barra 6 (diagonal decrescente)
];

// Função para calcular a matriz de rigidez de uma barra
function [K] = stiffness_matrix(E, A, Lx, Ly, L)
    c = Lx / L; // Coseno do ângulo da barra
    s = Ly / L; // Seno do ângulo da barra
    k = (E * A) / L;
    K = k * [
        c^2, c*s, -c^2, -c*s;
        c*s, s^2, -c*s, -s^2;
       -c^2, -c*s, c^2, c*s;
       -c*s, -s^2, c*s, s^2
    ];
endfunction

// Montagem da matriz de rigidez global
K_global = zeros(8, 8);  // Matriz de rigidez global 8x8 (2 graus de liberdade por nó)
disp("")
disp('K_global:');
disp(K_global)
disp("")


for i = 1:size(bars, 1)
    n1 = bars(i, 1);
    n2 = bars(i, 2);
    x1 = nodes(n1, 1);
    y1 = nodes(n1, 2);
    x2 = nodes(n2, 1);
    y2 = nodes(n2, 2);
    Lx = x2 - x1;
    Ly = y2 - y1;
    L_bar = sqrt(Lx^2 + Ly^2); // Comprimento da barra
    
    // Definindo a área da barra
    if i <= 4 then
        A = A1; // Barras 1 a 4
    else
        A = A2; // Barras 5 e 6
    end
    
    // Calculando a matriz de rigidez da barra
    K = stiffness_matrix(E, A, Lx, Ly, L_bar);
    
    // Mapeando os graus de liberdade para a matriz global
    dof = [2*n1-1, 2*n1, 2*n2-1, 2*n2];  // Graus de liberdade dos nós envolvidos
    for r = 1:4
        for c = 1:4
            K_global(dof(r), dof(c)) = K_global(dof(r), dof(c)) + K(r, c);
        end
    end
end

disp("")
disp("K_global: ", K_global)
disp("")

// Aplicação de condições de contorno (fixar nós 1 e 4)
K_reduced = K_global(3:8, 3:8); // Remover graus de liberdade dos nós fixos
disp("")
disp('K_reduced:');
disp(K_reduced)
disp("")

// Vetor de forças
F_global = zeros(8, 1);
F_global(6) = -F;  // Aplicando a força no nó 3 (vertical)
disp("")
disp('F_global:');
disp(F_global)
disp("")

F_reduced = F_global(3:8);  // Reduzir vetor de forças para o sistema reduzido

// Resolver o sistema linear para obter os deslocamentos
displacements = K_reduced \ F_reduced;
displacements1 = inv(K_reduced)*F_reduced

// Mostrando os deslocamentos dos nós 2 e 3
//disp('Deslocamentos (em cm):');
//disp(displacements);

// Mostrando os deslocamentos dos nós 2 e 3
disp('Deslocamentos (em cm):');
disp(displacements1);


// Após obter os deslocamentos, pode-se calcular as reações nos apoios (se necessário)
