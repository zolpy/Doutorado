clear. clc

// Definir os intervalos de X e Y
X = -5:1:5; // Valores de X de -5 a 5
Y = -4:1:4; // Valores de Y de -4 a 4

// Criar a grade de pontos (meshgrid)
[X_grid, Y_grid] = meshgrid(X, Y);

// Calcular os valores de Z
Z = X_grid.^2 - Y_grid.^2;

// Criar o gráfico de malha
mesh(X_grid, Y_grid, Z);

// Configurações do gráfico
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Gráfico de Superfície Z = X^2 - Y^2');


