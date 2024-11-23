// Limpeza de variáveis e da tela
clear; clc;

// Inicialização da matriz de rigidez local
//k = ones(6, 6); // Matriz de rigidez 6x6 com elementos iguais a 1

E =10; nu=0.3; t=1;

function k = calcula_ke(x1, y1, x2, y2, x3, y3, E, t, nu)
    // Cálculo da área do triângulo
    Area = [x1 y1 1; x2 y2 1; x3 y3 1];
    A = abs(0.5 * det(Area));

    // Constantes
    cte1 = (E * t) / (4 * A * (1 - nu^2));
    cte2 = (E * t) / (8 * A * (1 + nu));

    // Diferenças de coordenadas
    x21 = x2 - x1; x31 = x3 - x1; x32 = x3 - x2;
    y21 = y2 - y1; y31 = y3 - y1; y32 = y3 - y2;

    // Cálculo da submatriz ke_1
    ke_1 = cte1 * [
        y32^2,     -nu*y32*x32,    -y32*y31,      nu*y32*x31,      y32*y21,      -nu*y32*x21;
        -nu*y32*x32, x32^2,        nu*x32*y31,   -x32*x31,        -nu*x32*y21,  x32*x21;
        -y32*y31,   nu*x32*y31,    y31^2,        -nu*y31*x31,     -y31*y21,     nu*y31*x21;
        nu*y32*x31, -x32*x31,      -nu*y31*x31,  x31^2,           nu*x31*y21,   -x31*x21;
        y32*y21,    -nu*x32*y21,   -y31*y21,     nu*x31*y21,      y21^2,        -nu*y21*x21;
        -nu*y32*x21, x32*x21,      nu*y31*x21,   -x31*x21,        -nu*y21*x21,  x21^2
    ];

    // Cálculo da submatriz ke_2
    ke_2 = cte2 * [
        x32^2,       -x32*y32,      -x32*x31,     x32*y31,       x32*x21,      -x32*y21;
        -x32*y32,    y32^2,         y32*x31,      -y32*y31,      -y32*x21,     y32*y21;
        -x32*x31,    y32*x31,       x31^2,        -x31*y31,      -x31*x21,     x31*y21;
        x32*y31,     -y32*y31,      -x31*y31,     y31^2,         y31*x21,      -y31*y21;
        x32*x21,     -y32*x21,      -x31*x21,     y31*x21,       x21^2,        -x21*y21;
        -x32*y21,    y32*y21,       x31*y21,      -y31*y21,      -x21*y21,     y21^2
    ];

    // Matriz de rigidez elementar
    k = ke_1 + ke_2;
endfunction

// Índices para a montagem da matriz de rigidez global
i = [1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 5 6 6 6 6 6 6];
j = [1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6];


// Primeira submatriz de rigidez global
elemento1 = calcula_ke(0.5, 1, 0, 0, 1, 0, E, t, nu)
k1 = sparse([i(:), j(:)], elemento1, [10, 10]);
//mprintf("\n k1\n")
//disp(full(k1))
//mprintf("\n")

// Definindo os graus de liberdade para a segunda submatriz
elemento2 = calcula_ke(0.5, 1, 1, 0, 1.5, 1, E, t, nu)
v1 = [i(1:12), i(13:36) + 2];
v2 = [j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2];
k2 = sparse([v1(:), v2(:)], elemento2, [10, 10]);
//mprintf("\n k2\n")
//disp(full(k2))
//mprintf("\n")


elemento3 = calcula_ke(1, 0, 2, 0, 1.5, 1, E, t, nu)
// Definindo os graus de liberdade para a terceira submatriz
v1 = i + 4;
v2 = j + 4;
k3 = sparse([v1(:), v2(:)], elemento3, [10, 10]);

//mprintf("\n k3\n")
//disp(full(k3))
//mprintf("\n")

mprintf("\n Matriz k1\n")
k1 = full(k1)
disp(k1)
mprintf("\n")

mprintf("\n Matriz k2\n")
k2 = full(k2)
disp(k2)
mprintf("\n")

mprintf("\n Matriz k3\n")
k3 = full(k3)
disp(k3)
mprintf("\n")

// Montagem da matriz de rigidez global
k_g = k1 + k2 + k3;

mprintf("\n Matriz k_g\n")
k_g = full(k_g)
disp(k_g)
mprintf("\n")

//mprintf("\n Matriz k_g\n")
//k_g1 = full(k_g)
//disp(k_g1)
//mprintf("\n")

// Restrições de graus de liberdade (DoFs) 3, 4 e 10
k_g(10, :) = []; // Remove a linha 10
k_g(:, 10) = []; // Remove a coluna 10
k_g(3:4, :) = []; // Remove as linhas 3 e 4
k_g(:, 3:4) = []; // Remove as colunas 3 e 4

// Exibindo a matriz de rigidez global reduzida
//disp(k_g, "Matriz de Rigidez Global com DoFs Restritos:");
//disp(full(k_g))

mprintf("\n Matriz k_g Reduzida\n")
k_g_reduzida = full(k_g)
disp(k_g_reduzida)
mprintf("\n")

f = -0.1; //N

F = [0;f;0;0;0;f;0]
u = inv(k_g)*F

//Displacements plotting
//plot
Y = [0.5, 1; 0, 0; 1, 0;1.5,1; 2,0;1,0;0.5,1;1.5,1 ]

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
     
