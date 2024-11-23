clear; clc;
//1. Inicialização e Definição de Parâmetros
//Primeiro, o código define as propriedades do material e da geometria do problema.

E = 200000; d = 25; A = ((d^2)*%pi)/4; EA = E*A; F = -1000; // Material: steel (MPa)
cd = -1000; // cube dimensions

//2. Coordenadas dos Nós e Exibição
//Definimos as coordenadas dos nós no espaço tridimensional e mostramos esses valores.
node = [0,0,0; 0,0,cd; cd,0,0; cd,cd,0; cd,cd,cd; 0,cd,cd; 0,cd,0; cd,0,cd]; // node coordinates
disp("node")
disp(node)
//mprintf(" E = %.2f [lb/in² para Pa] \n A = %.2f [in² para m²]\n\n", E, A);

//3. Extração das Colunas de Coordenadas
//As variáveis xx, yy e zz armazenam as coordenadas 
//armazenam as coordenadas x,y, e z dos nós.
xx = node(:,1); // xx -> 1st col.;
yy = node(:,2); // yy -> 2nd col.;
zz = node(:,3); // zz -> 3rd col.

//4. Conexões dos Elementos
// Definimos a conectividade entre os nós para formar os elementos.
element = [1,2;//1 –> 1-2
           3,4;// 2 –> 3-4
           5,6;// 3 –> 5-6
           7,8;// 4 –> 7-8
           1,3;// 5 –> 1-3
           2,4;// 6 –> 2-4
           8,6;// 7 –> 8-6
           7,5;// 8 –> 7-5
           1,7;// 9 –> 1-7
           3,5;// 10 –> 3-5
           4,6;// 11 –> 4-6
           2,8;// 12 –> 2-8
           8,5;// 13 –> 8-5
           2,3]; // element connections
mprintf("\n Element connections \n");
disp(element)

//5. Número Total de Nós e Elementos
//Calculamos e exibimos o número total de nós e elementos.
numnode = size(node,1); // total number of nodes
mprintf("\n total number of nodes \n");
disp(numnode)

numelem = size(element,1); // total number of elements
mprintf("\n total number of elements \n");
disp(numelem)

// Matrices initialization
U = zeros(3*numnode,1); // Displacement matrix with all elements equal to zero
mprintf("\n Displacement matrix with all elements equal to zero \n");
disp(U)

//6. Inicialização das Matrizes de Deslocamento e Rigidez
//Inicializamos a matriz de deslocamento U e a matriz de rigidez K com zeros.
K = zeros(3*numnode,3*numnode); // Stiffness matrix with all elements equal to zero
mprintf("\n Stiffness matrix with all elements equal to zero \n");
disp(K)

//7. Cálculo dos Deslocamentos e Matriz de Rigidez
//Para cada elemento, calcula-se a diferença entre as coordenadas 
//x,y, e z, o comprimento do elemento, e os coeficientes de inclinação.
// Displacements
for e = 1:numelem
    indice = element(e,:); // Index 1 represents the 1st element, index 2 represents the 2nd
    mprintf("\n %.2f  \n", e);
    disp(indice)
    
    indiceB = [3*indice(1)-2, 3*indice(1)-1, 3*indice(1), 3*indice(2)-2, 3*indice(2)-1, 3*indice(2)]; 
    mprintf("\n indiceB\n", indiceB);
    disp(indice)
    
    // lists the DoF of each element (3 DoF per node)
    xa = xx(indice(2)) - xx(indice(1)); // X difference in the coordinate of each element
    ya = yy(indice(2)) - yy(indice(1)); // Y difference in the coordinate of each element
    za = zz(indice(2)) - zz(indice(1)); // Z difference in the coordinate of each element
    length_element = sqrt(xa*xa + ya*ya + za*za); // element length
    l = xa/length_element; // alpha slope
    m = ya/length_element; // beta slope
    n = za/length_element; // gamma slope

//8. Montagem da Matriz de Rigidez para Cada Elemento
//A matriz de rigidez do elemento é construída e acumulada na matriz global.
    k1 = (EA/length_element)*[l*l,l*m,l*n,-l*l,-l*m,-l*n;
                              l*m,m*m,m*n,-l*m,-m*m,-m*n;
                              l*n,m*n,n*n,-l*n,-m*n,-n*n;
                             -l*l,-l*m,-l*n,l*l,l*m,l*n;
                             -l*m,-m*m,-m*n,l*m,m*m,m*n;
                             -l*n,-m*n,-n*n,l*n,m*n,n*n]
    
    K(indiceB, indiceB) = K(indiceB,indiceB) +k1;
end

mprintf("\n K\n");
disp(K)

//9. Aplicação das Forças e Resolução dos Deslocamentos
//Definimos o vetor de forças P e calculamos a matriz de rigidez 
//    reduzida para encontrar os deslocamentos x.
P = [0,0,0,0,0,0,0,0,0,0,0,F,0,0,0,0,0,F,0,0,0,0,0,0]';
f = P(7:18);
K2 = K(7:18,7:18);
x = K2\f;
xd = [0,0,0,0,0,0,(x(1:12))',0,0,0,0,0,0]';

mprintf("\n K2\n");
disp(K2)

mprintf("\n x\n");
disp(x)

//10. Cálculo das Tensões
//Finalmente, calculamos as tensões para cada elemento.
for e = 1:numelem
    indice = element(e,:);
    indiceB = [3*indice(1)-2,3*indice(1)-1,3*indice(1),3*indice(2)-2, 3*indice(2)-1, 3*indice(2)];
    xa=xx(indice(2))-xx(indice(1));
    ya=yy(indice(2))-yy(indice(1));
    za=zz(indice(2))-zz (indice(1));
    length_element = sqrt(xa*xa + ya*ya + za*za);
    c = xa/length_element;
    s = ya/length_element;
    r = za/length_element;
    T =[c,s,r,0,0,0;0,0,0,c,s,r];
    d1 = T*xd(indiceB);
    deltaL = d1(2,:)-d1(1,:);
    Eps = deltaL*(1/length_element);
    Sigma(1,e) = E*Eps
end;    
    
mprintf("\n c\n");
disp(c)    

mprintf("\n s\n");
disp(s)

mprintf("\n T\n");
disp(T)

mprintf("\n d1\n");
disp(d1)

mprintf("\n deltaL\n");
disp(deltaL)

mprintf("\n Eps\n");
disp(Eps)

mprintf("\n Sigma\n");
disp(Sigma)
