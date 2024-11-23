clear; clc;

// 1. Inicialização e Definição de Parâmetros
E = 200000; // Módulo de Elasticidade (MPa)
d = 25; // Diâmetro
A = ((d^2) * %pi) / 4; // Área da seção transversal
EA = E * A; // Produto EA
F = -1000; // Força aplicada

// 2. Coordenadas dos Nós
node = [0,0,0; 0,0,1; 1,0,0; 1,0,1; 
        1,1,0; 1,1,1; 0,1,0; 0,1,1]; // Coordenadas dos nós
        
// Exibição das coordenadas dos nós
disp("Nó:");
disp(node);
mprintf("\n")

// 3. Definição dos DoFs
DoFs = [
    1, 2, 3;   // Nó 1
    4, 5, 6;   // Nó 2
    7, 8, 9;   // Nó 3
    10,11,12;  // Nó 4 A força está para baixo no nó 4, ou seja, em z, logo -1000 em 12
    13,14,15;  // Nó 5
    16,17,18;  // Nó 6 A força está para baixo no nó 6, ou seja, em z, logo -1000 em 18
    19,20,21;  // Nó 7
    22,23,24   // Nó 8
];


// Conexões dos elementos (definindo as arestas)
element = [
    1,2; // Conexão entre nó 1 e nó 2
    3,4; // Conexão entre nó 3 e nó 4
    5,6; // Conexão entre nó 5 e nó 6
    7,8; // Conexão entre nó 7 e nó 8
    1,3; // Conexão entre nó 1 e nó 3
    2,4; // Conexão entre nó 2 e nó 4
    8,6; // Conexão entre nó 8 e nó 6
    7,5; // Conexão entre nó 7 e nó 5
    1,7; // Conexão entre nó 1 e nó 7
    3,5; // Conexão entre nó 3 e nó 5
    4,6; // Conexão entre nó 4 e nó 6
    2,8; // Conexão entre nó 2 e nó 8
    8,5; // Conexão entre nó 8 e nó 5
    2,3; // Conexão entre nó 2 e nó 3
];

// Exibição das conexões dos elementos
disp("Conexões dos Elementos:");
disp(element);
mprintf("\n")

// Número total de nós e elementos
numnode = size(node ,1); 
numelem = size(element ,1); 
disp("Número total de nós:");
disp(numnode);
mprintf("\n")

disp("Número total de elementos:");
disp(numelem);
mprintf("\n")

// Inicialização das Matrizes de Deslocamento e Rigidez
U = zeros(3*numnode ,1); 
disp("Matriz U:");
disp(U);
mprintf("\n")

K = zeros(3*numnode ,3*numnode); 
disp("Matriz K:");
disp(K);
mprintf("\n")

// Cálculo da Matriz de Rigidez para Cada Elemento
for e = 1:numelem
    indice = element(e,:); 
    indiceB = [3*indice(1)-2:3*indice(1), ...
                (3*indice(2)-2):(3*indice(2))]; 

    xa = node(indice(2),1) - node(indice(1),1);
    ya = node(indice(2),2) - node(indice(1),2);
    za = node(indice(2),3) - node(indice(1),3);
    
    length_element = sqrt(xa^2 + ya^2 + za^2); 
    l = xa / length_element;
    m = ya / length_element;
    n = za / length_element;

    k_local = (EA / length_element) * [l*l l*m l*n -l*l -l*m -l*n;
                                        l*m m*m m*n -l*m -m*m -m*n;
                                        l*n m*n n*n -l*n -m*n -n*n;
                                       -l*l -l*m -l*n l*l l*m l*n;
                                       -l*m -m*m -m*n l*m m*m m*n;
                                       -l*n -m*n -n*n l*n m*n n*n];
                                       
    mprintf(" k_%d_(local): \n",e)
    disp(k_local)
    mprintf("\n")
    K(indiceB ,indiceB) = K(indiceB ,indiceB) + k_local;
    //mprintf(" K(indiceB ,indiceB) \n")
    //disp(K(indiceB ,indiceB))
    //mprintf("\n")
    
end




// Aplicação das Forças (definindo o vetor de forças)
P = zeros(24 ,1); 
disp("Matriz zeros(24 ,1):");
disp(P);
mprintf("\n")

P(12) = F;// Nó 4 A força está para baixo no nó 4, ou seja, em z, logo -1000 em 12
disp("Matriz P(12):");
disp(P);
mprintf("\n")

P(18) = F;// Nó 6 A força está para baixo no nó 6, ou seja, em z, logo -1000 em 18
disp("Matriz P(18):");
disp(P);
mprintf("\n")

// Resolução dos Deslocamentos (aplicação da matriz de rigidez reduzida)
f = P(7:18);
disp("Matriz f:");
disp(f);
mprintf("\n")

/*
A linha K_reduced = K(7:18, 7:18); está extraindo as linhas e colunas da matriz K
 que correspondem aos graus de liberdade que não estão fixos. Neste caso, você 
 está pegando as linhas e colunas de 7 a 18.
 
Isso significa que você está focando apenas nas DoFs que são livres (não fixos) 
para a análise. Por exemplo, se os DoFs 1 a 6 estão fixos, você está extraindo
apenas as DoFs que vão de 7 a 18.
*/
K_reduced = K(7:18 ,7:18);
disp("Matriz K_reduced:");
disp(K_reduced);
mprintf("\n")

x = K_reduced \ f;
disp("Matriz x:");
disp(x);
mprintf("\n")

// Cálculo das Tensões para Cada Elemento (opcional)
Sigma = zeros(numelem ,1);
disp("Tensões nos Elementos:");
disp(Sigma);

// Cálculo das tensões: idem looping da matriz de rigidez, exceto duas ultimas linhas
for e = 1:numelem 
    indice = element(e,:); 
    indiceB = [3*indice(1)-2:3*indice(1), (3*indice(2)-2):(3*indice(2))];

    xa = node(indice(2),1) - node(indice(1),1);
    ya = node(indice(2),2) - node(indice(1),2);
    za = node(indice(2),3) - node(indice(1),3);
    
    length_element = sqrt(xa^2 + ya^2 + za^2); 
    
    c = xa / length_element; 
    s = ya / length_element; 
    r = za / length_element; 
    
    T = [c,s,r ,0 ,0 ,0; 0,0,0,c,s,r]; // Matriz rotação
    
    d_local = T * xd(indiceB); // Deslocamento local
    deltaL = d_local(2,:) - d_local(1,:); // Variação do comprimento
    Eps = deltaL * (1 / length_element); // Deformação específica
    
    Sigma(e) = E * Eps; // Tensão
end;

disp("Tensões nos Elementos:");
disp(Sigma);
