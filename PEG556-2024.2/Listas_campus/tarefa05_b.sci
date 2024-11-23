// Limpeza de variáveis e da tela
clear; clc;

// Inicialização da matriz de rigidez local
//k = ones(6, 6); // Matriz de rigidez 6x6 com elementos iguais a 1

E =10; nu=0.3; t=1;

function k = calcula_ke(x2, x1, y2, y1, E, t, nu)
  
    // Diferenças de coordenadas
    a = (x2 - x1);
    b = (y2 - y1);
    c = a/b; //alpha c 
    
    // Cálculo da área do quadrado
    A = abs(a * b); // Para um quadrado alinhado aos eixos

    // Constantes
    cte1 = (E * t) / (12 * A * (1 - nu^2));
    cte2 = (E * t) / (24 * A * (1 + nu));

    // Cálculo da submatriz ke_1
    k_epson = cte1 * [4/c,     3*nu, -(4/c),  3*nu,  -(2/c),  -3*nu,  2/c,  -3*nu;
                      3*nu,    4*c,   -3*nu,  2*c,   -3*nu,  -2*c,   3*nu, -4*c; 
                    -(4/c), -3*nu,   4/c,  -3*nu,   2/c,    3*nu, -2/c,   3*nu; 
                      3*nu,     2*c,   -3*nu,  4*c,   -3*nu,  -4*c,   3*nu, -2*c;
                    -(2/c), -3*nu,   2/c,  -3*nu,   4/c,    3*nu, -4*c,   3*nu;
                     -3*nu,  -2*c,    3*nu, -4*c,    3*nu,   4/c,  -3*nu,  3*c;
                      2/c,     3*nu,  -2/c,   3*nu,  -4*c,   -3*nu,  4/c,  -3*nu;
                     -3*nu,  -4*c,    3*nu, -2*c,    3*nu,   2*c,  -3*nu,  4*c ];

    // Cálculo da submatriz ke_2
    k_lambida = cte2 * [4*c,	3,	2*c,	-3,	-(2*c),	-3,	-4*c,	3,
                3,	4/c,	3,	-4/c,	-3,	-2/c,	-3,	2/c,
2*c,	3,	4*c,	-3,	-4*c,	-3,	-2*c,	3,
-3,	-4/c,	-3,	4/c,	3,	2/c,	3,	-2/c,
-(2*c),	-3,	-4*c,	3,	4*c,	3,	2*c,	-3,
-3,	-2/c,	-3,	2/c,	3,	4/c,	3,	-4/c,
-4*c,	-3,	-2*c,	3,	2*c,	3,	4*c,	-3,
3,	2/c,	3,	-2/c,	-3,	-4/c,	-3,	4/c,
    

    ];

    // Matriz de rigidez elementar
    k = k_epson + k_lambida;
endfunction

// Índices para a montagem da matriz de rigidez global
//i = [1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 6 6 6 6 6 6 6 6 7 7 7 7 7 7 7 7 8 8 8 8 8 8 8 8];
//j = [1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8];

// Número de repetições
n_repeticoes = 8; // Número de vezes que cada índice é repetido
n_blocos = 8; // Número total de blocos

// Criando o vetor i
i = repmat((1:n_blocos)', n_repeticoes, 1); // Repetindo os índices de 1 a 8

// Criando o vetor j
j = repmat(1:n_blocos, n_repeticoes, 1); // Repetindo a sequência de 1 a 8

// Convertendo para vetores coluna (se necessário)
i = i(:); // Transformar i em um vetor coluna
j = j(:); // Transformar j em um vetor coluna


// Primeira submatriz de rigidez global
elemento1 = calcula_ke(1, 0, 1, 0, E, t, nu)
mprintf("\n elemento1\n")
disp(full(elemento1))
mprintf("\n")

k1 = sparse([i(:), j(:)], elemento1, [12, 12]);
mprintf("\n k1\n")
disp(full(k1))
mprintf("\n")

// Segunda submatriz de rigidez global
elemento2 = calcula_ke(2, 1, 1, 0, E, t, nu)
mprintf("\n elemento2\n")
disp(full(elemento2))
mprintf("\n")

v1 = [i(1:12), i(13:36) + 2];
v2 = [j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2, j(1:2), j(3:6) + 2];

k2 = sparse([v1(:), v2(:)], elemento2, [12, 12]);
mprintf("\n k2\n")
disp(full(k2))
mprintf("\n")
