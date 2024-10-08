clear; clc
// Definindo o vetor X
X = [2 4 6 7 8];

// a) Adicionar o valor 10 ao final do vetor X
X = [X 10];
disp("Vetor X após adicionar o valor 10:");
disp(X);
disp(" ");  // Adiciona uma linha em branco

// b) Remover o quinto elemento do vetor X
X(5) = [];  // Remove o elemento na posição 5
disp("Vetor X após remover o quinto elemento:");
disp(X);
disp(" ");  // Adiciona uma linha em branco

// c) Atribuir o valor zero aos elementos entre as posições 1 e 4
X(1:4) = 0;
disp("Vetor X com elementos entre as posições 1 e 4 igual a zero:");
disp(X);
disp(" ");  // Adiciona uma linha em branco

// d) Agrupar os vetores X' e C = ones(5,1)
C = ones(5, 1);  // Vetor coluna com cinco elementos iguais a 1
agrupado = [X' C];  // Agrupar X transposto e C
disp("Agrupamento de Transposta de X e C:");
disp(agrupado);
disp(" ");  // Adiciona uma linha em branco
