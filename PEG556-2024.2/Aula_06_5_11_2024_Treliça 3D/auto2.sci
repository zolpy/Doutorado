clear; clc;

// Função para usar o plotmesh
function plotmesh(T, P, NodeLabels, EltLabels, _color)
    Net = size(T,1);
    _3D_problem = (size(P,2)==3);
    
    if _3D_problem then
        for ie = 1:Net
            XY = P(T(ie,:),:);
            X = [[XY(:,1)]; XY(1,1)];
            Y = [[XY(:,2)]; XY(1,2)];
            Z = [[XY(:,3)]; XY(1,3)];
            param3d1(X,Y,list(Z,color(_color)));  
            if (EltLabels)
                x = mean(XY(:,1));
                y = mean(XY(:,2));
                z = mean(XY(:,3));
                xstring(x,y,z,string(ie));
            end
        end 

        if (NodeLabels) then
            Np = size(P,1);
            for i=1:Np
                xstring(P(i,1),P(i,2),P(i,3),string(i));
            end
        end

        delta_x = max(P(:,1))-min(P(:,1));
        delta_y = max(P(:,2))-min(P(:,2));
        delta_z = max(P(:,3))-min(P(:,3));
        x_max = max(P(:,1));
        x_min = min(P(:,1));
        y_max = max(P(:,2));
        y_min = min(P(:,2));
        z_max = max(P(:,3));
        z_min = min(P(:,3));

        f = gca();
        f.data_bounds = [x_min-0.1*delta_x, y_min-0.1*delta_y, z_min-0.1*delta_z;
                         x_max+0.1*delta_x, y_max+0.1*delta_y, z_max+0.1*delta_z];
    else
        for ie = 1:Net
            XY = P(T(ie,:),:);
            X = [[XY(:,1)]; XY(1,1)];
            Y = [[XY(:,2)]; XY(1,2)];
            plot(X,Y,_color);  
            if (EltLabels)
                x = mean(XY(:,1));
                y = mean(XY(:,2));
                xstring(x,y,string(ie));
            end
        end 

        if (NodeLabels) then
            Np = size(P,1);
            for i=1:Np
                xstring(P(i,1),P(i,2),string(i));
            end
        end

        delta_x = max(P(:,1))-min(P(:,1));
        delta_y = max(P(:,2))-min(P(:,2));
        x_max = max(P(:,1));
        x_min = min(P(:,1));
        y_max = max(P(:,2));
        y_min = min(P(:,2));

        f = gca();
        f.data_bounds = [x_min-0.1*delta_x, y_min-0.1*delta_y; 
                         x_max+0.1*delta_x, y_max+0.1*delta_y];
    end
endfunction

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
    10,11,12;  // Nó 4 
    13,14,15;  // Nó 5
    16,17,18;  // Nó 6 
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
    8,5; // Conexão entre nó 8 e nó5 
    ...
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
for e=1:numelem 
   indice=element(e,:); 
   indiceB=[3*indice(1)-2:3*indice(1),(3*indice(2)-2):(3*indice(2))];

   xa=node(indice(2),:)-node(indice(1),:); 
   ya=node(indice(2),:)-node(indice(2),:); 
   za=node(indice(2),:)-node(indice(2),:); 

   length_element=sqrt(xa^2 + ya^2 + za^2); 

   l=xa/length_element;
   m=ya/length_element;
   n=za/length_element;

   k_local=(EA/length_element)*[l*l l*m l*n -l*l -l*m -l*n;
                                 l*m m*m m*n -l*m -m*m -m*n;
                                 l*n m*n n*n -l*n -m*n -n*n;
                                -l*l -l*m -l*n l*l l*m l*n;
                                -l*m -m*m -m*n l*m m*m m*n;
                                -l*n -m*n -n*n l*n m*n n*n];

   K(indiceB ,indiceB) = K(indiceB ,indiceB) + k_local;
end;

// Aplicação das Forças (definindo o vetor de forças)
P=zeros(numnode *3 ,01); 

P(12)=F;// Força aplicada no DoF correspondente ao Nó4.
P(18)=F;// Força aplicada no DoF correspondente ao Nó6.

f=P(7:18); 

K_reduced=K(7:18 ,7:18);

x=K_reduced\f;

xd=[zeros(6 ,01);x';zeros(6 ,01)];

Sigma=zeros(numelem ,01);

// Cálculo das tensões para cada elemento:
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

// Exibição das Tensões Calculadas:
disp("Tensões nos Elementos:");
disp(Sigma);

// Plotagem do modelo:
drawlater;
plotmesh(element,node,true,true,'green');
drawnow;
