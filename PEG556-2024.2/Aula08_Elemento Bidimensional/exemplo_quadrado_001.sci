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
L = 2; // Comprimento de cada lado do quadrado
H = 2; // Altura de cada lado do quadrado

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

f = 1; //N

F = [0;0;0;0;0;f;0]
u = inv(k_g)*F

//Displacements plotting
//plot
Y = [  0.0, 0; 
       0  , 1; 
       1  , 0;
       2  , 0; 
       1  , 0;
       1  , 1;
       1  , 2;
        ]

U = [0.5+u(1), 1+u(2);
     0,0;
     1+u(3), 0+u(4);
     1.5+u(5), 1+u(6);
     2+u(7),0;
     1+u(3),0+u(4);
     0.5+u(1), 1+u(2);
     1.5+u(5),1+u(6)];

plot(Y(:,1),Y(:,2),"g-",U(:,1),U(:,2),"b-","LineWidth",2);
title("Deslocamento da estrutura")
legend("Estrutura original","Estrutura deslocada",4)
ylabel('Distância Y (m)');
xlabel('Distância X (m)');
xgrid
     
