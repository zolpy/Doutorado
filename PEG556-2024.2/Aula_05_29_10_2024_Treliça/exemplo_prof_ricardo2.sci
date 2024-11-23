clear; clc
E = 21e5; //kgf/cm2
A = [1,1,1,1,sqrt(2), sqrt(2)]; //cm2
L = 21; //cm
X = [0,0; 0,L; L,0; L,L]; // coordenadas dos nós (em cm)

i = [1,1,2,2,3,3,4,4,1,1,2,2,3,3,4,4];
j = [1,2,1,2,3,4,3,4,1,3,1,3,2,4,2,4];

// Elemento 1 (nós 1 e 2)
deltaX = X(2,1) - X(1,1);
deltaY = X(2,2) - X(1,2);
L1 = sqrt(deltaX^2 + deltaY^2); // comprimento do elemento 1

C = deltaX/L1; // cosseno
S = deltaY/L1; // seno

k = [C*C, C*S, -C*C, -C*S;
     C*S, S*S, -C*S, -S*S;
    -C*C,-C*S,  C*C,  C*S;
    -C*S,-S*S,  C*S,  S*S];

cte = (E * A(1)) / L1;
k1 = cte * k;

// Elemento 2 (nós 1 e 3)
deltaX = X(3,1) - X(1,1);
deltaY = X(3,2) - X(1,2);
L2 = sqrt(deltaX^2 + deltaY^2); // comprimento do elemento 2

C = deltaX / L2; // cosseno
S = deltaY / L2; // seno

k = [C*C, C*S, -C*C, -C*S;
     C*S, S*S, -C*S, -S*S;
    -C*C,-C*S,  C*C,  C*S;
    -C*S,-S*S,  C*S,  S*S];

cte = (E * A(2)) / L2;
k2 = cte * k;

// Elemento 3 (nós 2 e 4)
deltaX = X(4,1) - X(2,1);
deltaY = X(4,2) - X(2,2);
L3 = sqrt(deltaX^2 + deltaY^2); // comprimento do elemento 3

C = deltaX / L3; // cosseno
S = deltaY / L3; // seno

k = [C*C, C*S, -C*C, -C*S;
     C*S, S*S, -C*S, -S*S;
    -C*C,-C*S,  C*C,  C*S;
    -C*S,-S*S,  C*S,  S*S];

cte = (E * A(3)) / L3;
k3 = cte * k;

// Elemento 4 (nós 3 e 4)
deltaX = X(4,1) - X(3,1);
deltaY = X(4,2) - X(3,2);
L4 = sqrt(deltaX^2 + deltaY^2); // comprimento do elemento 4

C = deltaX / L4; // cosseno
S = deltaY / L4; // seno

k = [C*C, C*S, -C*C, -C*S;
     C*S, S*S, -C*S, -S*S;
    -C*C,-C*S,  C*C,  C*S;
    -C*S,-S*S,  C*S,  S*S];

cte = (E * A(4)) / L4;
k4 = cte * k;

// Montagem da matriz de rigidez global
K = zeros(8, 8); // Matriz de rigidez global (8x8)

indices = [1 2 3 4]; // Índices globais para o elemento 1
K(indices, indices) = K(indices, indices) + k1;

indices = [1 2 5 6]; // Índices globais para o elemento 2
K(indices, indices) = K(indices, indices) + k2;

indices = [3 4 7 8]; // Índices globais para o elemento 3
K(indices, indices) = K(indices, indices) + k3;

indices = [5 6 7 8]; // Índices globais para o elemento 4
K(indices, indices) = K(indices, indices) + k4;

disp("Matriz de rigidez global K:")
disp(K)

// Condições de contorno
// Nós 1 e 3 fixos (graus de liberdade 1, 2, 5, 6)
// Elimina as linhas e colunas correspondentes às condições de contorno
K_reduced = K(3:8, 3:8);

disp("Matriz de rigidez reduzida K_reduced:")
disp(K_reduced)

// Carregamentos
F = zeros(8,1);
F(4) = 100; // Força aplicada no nó 2 no grau de liberdade 4

// Resolvendo para os deslocamentos
U = K_reduced \ F(3:8);

disp("Deslocamentos U:")
disp(U)

// Reação de apoio
R = K * [0; 0; U];
disp("Reações de apoio R:")
disp(R)

// Plotagem da estrutura deformada
deslocamentos = [0; 0; U(1:2); 0; 0; U(3:4)];
factor = 100; // Fator de escala para visualização

// Plotagem da estrutura deformada
deslocamentos = [0; 0; U(1:2); 0; 0; U(3:4)];
factor = 100; // Fator de escala para visualização

// Atualizando as coordenadas deformadas manualmente
X_deformado = X; // Inicializamos com as coordenadas originais
X_deformado(2,:) = X_deformado(2,:) + factor * [deslocamentos(3), deslocamentos(4)]; // Nó 2
X_deformado(4,:) = X_deformado(4,:) + factor * [deslocamentos(7), deslocamentos(8)]; // Nó 4

// Plotagem da estrutura original e deformada
clf;
plot(X(:,1), X(:,2), 'bo-', "LineWidth", 2); // Estrutura original
xset("hold", "on"); // Ativa o hold no Scilab para manter o gráfico original
plot(X_deformado(:,1), X_deformado(:,2), 'ro--', "LineWidth", 2); // Estrutura deformada
legend("Estrutura original", "Estrutura deformada");
title("Estrutura original e deformada");
xlabel("X (cm)");
ylabel("Y (cm)");
grid on;
xset("hold", "off"); // Desativa o hold depois de desenhar o gráfico

