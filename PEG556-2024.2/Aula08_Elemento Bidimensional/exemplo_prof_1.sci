// Limpeza de variáveis e da tela
clear; clc;

// Inicialização da matriz de rigidez local (6x6)
k_local = ones(6, 6); // Todos elementos de rigidez são 1

// Número total de graus de liberdade
total_dof = 10;

// Indices globais de cada nó (considerando 2 DoFs por nó)
node_dofs = [
    1 2; // Nó 1
    3 4; // Nó 2
    5 6; // Nó 3
    7 8; // Nó 4
    9 10 // Nó 5
];

// Conectividade dos elementos (elementos conectando nós)
elements = [
    1 2; // Elemento 1 (conecta Nó 1 e Nó 2)
    1 3; // Elemento 2 (conecta Nó 1 e Nó 3)
    1 4; // Elemento 3 (conecta Nó 1 e Nó 4)
];

// Inicialização da matriz de rigidez global completa (10x10)
k_global = zeros(total_dof, total_dof);

// Montagem da matriz de rigidez global a partir dos elementos
for e = 1:size(elements, 1)
    nodes = elements(e, :);            // Nós do elemento e
    dofs = [node_dofs(nodes(1), :) node_dofs(nodes(2), :)]; // Graus de liberdade do elemento
    
    // Adicionando k_local na matriz global k_global nos DOFs correspondentes
    for i = 1:6
        for j = 1:6
            k_global(dofs(i), dofs(j)) = k_global(dofs(i), dofs(j)) + k_local(i, j);
        end
    end
end

// Remoção dos graus de liberdade restritos (3, 4 e 10)
restricted_dofs = [3, 4, 10];
k_reduced = k_global;
k_reduced(restricted_dofs, :) = [];
k_reduced(:, restricted_dofs) = [];

// Exibição da matriz de rigidez global reduzida (7x7)
disp(k_reduced, "Matriz de Rigidez Global Reduzida (7x7):");
