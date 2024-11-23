// Definindo coordenadas dos nós
nodes = [0.5, 1; 0, 0; 1, 0; 1.5, 1; 2, 0]; // Coordenadas dos nós (x,y)

// Definindo conectividade dos elementos
elements = [1, 2; 1, 3; 2, 3; 3, 4; 4, 5; 1, 4; 2, 4; 3, 5; 1, 5]; 

// Número de nós e graus de liberdade
nNodes = size(nodes, "r");
dofPerNode = 2;
totalDOF = nNodes * dofPerNode;

// Inicializando a matriz de rigidez global
K = zeros(totalDOF, totalDOF);

// Função para calcular a matriz de rigidez local de um elemento (2x2)
function k = localStiffnessMatrix(k_ij)
    k = k_ij * [1, -1; -1, 1];
endfunction

// Função para expandir a matriz de rigidez local (2x2) para uma matriz de (4x4)
function k_expanded = expandLocalStiffnessMatrix(k_local)
    k_expanded = [k_local, zeros(2, 2); zeros(2, 2), k_local];
endfunction

// Loop para montar a matriz de rigidez global
for i = 1:size(elements, "r")
    n1 = elements(i, 1);
    n2 = elements(i, 2);
    
    // Graus de liberdade dos nós do elemento
    dof = [2*n1-1, 2*n1, 2*n2-1, 2*n2];
    
    // Matriz de rigidez local expandida (4x4)
    k_local_expanded = expandLocalStiffnessMatrix(localStiffnessMatrix(1));
    
    // Inserindo k_local_expanded na matriz de rigidez global
    K(dof, dof) = K(dof, dof) + k_local_expanded;
end

// Exibindo a matriz de rigidez global
disp(K, "Matriz de Rigidez Global:");
