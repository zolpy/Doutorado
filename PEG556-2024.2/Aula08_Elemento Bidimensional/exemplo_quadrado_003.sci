clc; clear;

// Definindo as constantes
E = 200; // Módulo de elasticidade
nu = 0.3; // Coeficiente de Poisson
t = 1; // Espessura
F = 1; // Força aplicada (negativa para baixo)

// Função para calcular a matriz de rigidez de um elemento retangular
function K = stiffness_matrix(E, nu, t, L, H)
    // Cálculo da área
    A = L * H; // Área do elemento retangular
    
    // Coeficientes da matriz de rigidez
    cte = (E * t) / (1 - nu^2);
    
    // Matriz de rigidez para um elemento retangular (8 DoFs)
    K = cte * [1, -1, -1, 1;
                -1, 1, 1, -1;
                -1, 1, 1, -1;
                1, -1, -1, 1];
endfunction

// Definindo as dimensões dos quadrados
L = 1; // Comprimento de cada lado do quadrado
H = 1; // Altura de cada lado do quadrado

// Inicializando a matriz global de rigidez
K_global = zeros(12, 12); // Para seis nós com dois graus de liberdade cada

// Calculando a matriz de rigidez para cada elemento e somando na matriz global
K_elem_1 = stiffness_matrix(E, nu, t, L, H); // Elemento inferior esquerdo
K_elem_2 = stiffness_matrix(E, nu, t, L, H); // Elemento inferior direito

// Adicionando contribuições dos elementos à matriz global
K_global(1:4, 1:4) = K_global(1:4, 1:4) + K_elem_1; // Elemento inferior esquerdo
K_global(5:8, 5:8) = K_global(5:8, 5:8) + K_elem_2; // Elemento inferior direito

// Aplicando condições de contorno (engastamento nos nós 1 e 2)
K_global(1,:) = 0; K_global(:,1) = 0; // Engastamento no nó 1
K_global(2,:) = 0; K_global(:,2) = 0; // Engastamento no nó 2

// Exibindo a matriz de rigidez global
disp("Matriz de Rigidez Global:");
disp(K_global);

// Definindo a força aplicada no nó correspondente ao ponto (2, 1)
// O nó correspondente ao ponto (2, 1) é o nó **5**, que é o segundo grau de liberdade do nó.
F_vector = zeros(12, 1);
F_vector(10) = F; // Aplicando força verticalmente para baixo no nó livre (nó Y do nó 5)

// Resolvendo o sistema K * U = F para encontrar os deslocamentos U
U = K_global \ F_vector;

// Exibindo os deslocamentos
disp("Deslocamentos:");
disp(U);

// Plotando a estrutura original e a deslocada
clf(); // Limpa a figura atual

// Coordenadas dos nós da estrutura original
X_original = [0, L, L*2; 
              L*2, L*2, L]';
Y_original = [0, H*2; 
              H*2, H]';

// Plotando a estrutura original
plot(X_original(:,[1:3]), Y_original(:,[1:3]), "g-", "LineWidth", 2);

// Plotando a estrutura deslocada
X_deslocada = [0 + U(1), L + U(3), L*2 + U(7)];
Y_deslocada = [0 + U(2), H + U(4), H + U(10)];

plot(X_deslocada(:,[1:3]), Y_deslocada(:,[1:3]), "b-", "LineWidth", 2);

// Configurações do gráfico
title("Deslocamento da Estrutura");
legend("Estrutura Original", "Estrutura Deslocada", 'Location', 'northeast');
ylabel('Distância Y (m)');
xlabel('Distância X (m)');
xgrid();
