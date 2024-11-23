clc; clear;

// Definindo as constantes
E = 200; // Módulo de elasticidade
nu = 0.3; // Coeficiente de Poisson
t = 1; // Espessura
F = 1; // Força aplicada

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

// Definindo as dimensões da treliça
L = 1; // Comprimento de cada lado do quadrado
H = 1; // Altura de cada lado do quadrado

// Inicializando a matriz global de rigidez
K_global = zeros(8, 8); // Para dois quadrados com 4 nós cada

// Calculando a matriz de rigidez para cada elemento e somando na matriz global
K_elem = stiffness_matrix(E, nu, t, L, H);

// Adicionando contribuições dos elementos à matriz global
K_global(1:4, 1:4) = K_global(1:4, 1:4) + K_elem; // Elemento 1
K_global(5:8, 5:8) = K_global(5:8, 5:8) + K_elem; // Elemento 2

// Aplicando condições de contorno (engastamento na parede)
K_global(1,:) = 0; K_global(:,1) = 0; // Engastamento no nó 1
K_global(2,:) = 0; K_global(:,2) = 0; // Engastamento no nó 2

// Exibindo a matriz de rigidez global
disp("Matriz de Rigidez Global:");
disp(K_global);

// Definindo a força aplicada nos nós livres (apenas no nó 3 por exemplo)
F_vector = zeros(8, 1);
F_vector(3) = F; // Aplicando força no nó livre

// Resolvendo o sistema K * U = F para encontrar os deslocamentos U
U = K_global \ F_vector;

// Exibindo os deslocamentos
disp("Deslocamentos:");
disp(U);

// Plotando a estrutura original e a deslocada
//clf(); // Limpa a figura atual

// Coordenadas dos nós da estrutura original
X_original = [0, L, L, 0; 
              0, L, L, 0]';
Y_original = [0, 0, H, H;
              H + U(3), H + U(4), H + U(5), H + U(6)]';

// Plotando a estrutura original
plot(X_original(:,1), Y_original(:,1), "g-", "LineWidth", 2);
plot(X_original(:,2), Y_original(:,2), "g-", "LineWidth", 2);

// Plotando a estrutura deslocada
X_deslocada = X_original + [U(1), U(3); U(5), U(7)]'; // Adiciona deslocamentos X
Y_deslocada = Y_original + [U(2), U(4); U(6), U(8)]'; // Adiciona deslocamentos Y

plot(X_deslocada(:,1), Y_deslocada(:,1), "b-", "LineWidth", 2);
plot(X_deslocada(:,2), Y_deslocada(:,2), "b-", "LineWidth", 2);

// Configurações do gráfico
title("Deslocamento da Estrutura");
legend("Estrutura Original", "Estrutura Deslocada", 'Location', 'northeast');
ylabel('Distância Y (m)');
xlabel('Distância X (m)');
xgrid();
