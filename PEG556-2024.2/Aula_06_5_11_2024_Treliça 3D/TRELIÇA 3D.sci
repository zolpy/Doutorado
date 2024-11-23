clear; clc;

// Função para plotar a malha (estrutura) antes e depois da carga
function plotmesh(T, P, NodeLabels, EltLabels, _color)
    Net = size(T,1);
    _3D_problem = (size(P,2)==3);
    
    if _3D_problem then
        for ie = 1:Net
            XY = P(T(ie,:),:);
            X = [[XY(:,1)]; XY(1,1)];
            Y = [[XY(:,2)]; XY(1,2)];
            Z = [[XY(:,3)]; XY(1,3)];
            param3d1(X, Y, list(Z, color(_color)));  
            if (EltLabels)
                x = mean(XY(:,1));
                y = mean(XY(:,2));
                z = mean(XY(:,3));
                xstring(x, y, z, string(ie));
            end
        end 
        
        if (NodeLabels) then
            Np = size(P,1);
            for i=1:Np
                xstring(P(i,1), P(i,2), P(i,3), string(i));
            end
        end
    end
endfunction

// Dados de entrada
E = 200000;                // Módulo de Elasticidade em MPa
d = 25;                    // Diâmetro da barra em mm
A = ((d^2) * %pi) / 4;     // Área da seção transversal em mm²
EA = E * A;                // Rigidez axial
F = -1000;                // Força de 10 kN aplicada em nós específicos

// Coordenadas dos nós (cada linha representa um nó)
node = [0, 0, 0;
        0, 0.5, 1;
        0, 1, 0;
        1, 0, 0;
        1, 0.5, 1;
        1, 1, 0;
        2, 0, 0;
        2, 0.5, 1;
        2, 1, 0];

// Conectividade dos elementos (cada linha representa uma barra conectando dois nós)
element = [1, 2; 2, 3; 3, 1; 4, 5; 5, 6; 6, 4; 
           7, 8; 8, 9; 9, 7; 1, 4; 2, 5; 3, 6; 
           4, 7; 5, 8; 6, 9; 1, 6; 2, 4; 3, 5; 
           4, 9; 5, 7; 6, 8];

numnode = size(node, 1);     // Número total de nós
numelem = size(element, 1);  // Número total de elementos (barras)

xx = node(:,1);  // Coordenadas X dos nós
yy = node(:,2);  // Coordenadas Y dos nós
zz = node(:,3);  // Coordenadas Z dos nós

// Inicialização das matrizes
U = zeros(3 * numnode, 1);         // Matriz de deslocamentos
K = zeros(3 * numnode, 3 * numnode); // Matriz de rigidez global

// Montagem da matriz de rigidez global
for e = 1:numelem
    indice = element(e, :);  // Nós conectados pelo elemento
    indiceB = [3 * indice(1) - 2, 3 * indice(1) - 1, 3 * indice(1), 
               3 * indice(2) - 2, 3 * indice(2) - 1, 3 * indice(2)];
    
    // Cálculo dos comprimentos e inclinações
    xa = xx(indice(2)) - xx(indice(1));
    ya = yy(indice(2)) - yy(indice(1));
    za = zz(indice(2)) - zz(indice(1));
    length_element = sqrt(xa^2 + ya^2 + za^2);
    c = xa / length_element;
    s = ya / length_element;
    r = za / length_element;
    
    // Matriz de rigidez local do elemento
    k1 = (EA / length_element) * [
        c*c,   c*s,   c*r,  -c*c,  -c*s,  -c*r;
        c*s,   s*s,   s*r,  -c*s,  -s*s,  -s*r;
        c*r,   s*r,   r*r,  -c*r,  -s*r,  -r*r;
       -c*c,  -c*s,  -c*r,   c*c,   c*s,   c*r;
       -c*s,  -s*s,  -s*r,   c*s,   s*s,   s*r;
       -c*r,  -s*r,  -r*r,   c*r,   s*r,   r*r];
    
    // Inserção na matriz de rigidez global
    K(indiceB, indiceB) = K(indiceB, indiceB) + k1;
end

// Aplicação das forças e restrições
P = zeros(3 * numnode, 1);
P([12, 18, 21, 27]) = F;  // Aplicação de 10 kN nos graus de liberdade específicos
K2 = K(10:27, 10:27);              // Redução da matriz de rigidez global
f = P(10:27);                      // Redução do vetor de forças

// Cálculo dos deslocamentos
x = K2 \ f;
xd = [zeros(9, 1); x; zeros(9, 1)];

// Cálculo das tensões
Sigma = zeros(1, numelem);
for e = 1:numelem
    indice = element(e, :);
    indiceB = [3 * indice(1) - 2, 3 * indice(1) - 1, 3 * indice(1), 
               3 * indice(2) - 2, 3 * indice(2) - 1, 3 * indice(2)];
    
    xa = xx(indice(2)) - xx(indice(1));
    ya = yy(indice(2)) - yy(indice(1));
    za = zz(indice(2)) - zz(indice(1));
    length_element = sqrt(xa^2 + ya^2 + za^2);
    c = xa / length_element;
    s = ya / length_element;
    r = za / length_element;
    
    T = [c, s, r, 0, 0, 0; 0, 0, 0, c, s, r];
    d1 = T * xd(indiceB)(:);  // Ajuste para garantir que xd(indiceB) seja um vetor coluna
    deltaL = d1(2) - d1(1);
    Eps = deltaL / length_element;
    Sigma(e) = E * Eps;
end

// Exibir tensões
disp("Tensões nos elementos (MPa):")
disp(Sigma)

// Plotar deslocamentos antes e depois da aplicação da carga
dn = [xd(1:3)'; xd(4:6)'; xd(7:9)'; xd(10:12)'; xd(13:15)'; xd(16:18)'; xd(19:21)'; xd(22:24)'; xd(25:27)'];
drawlater;
t = element;
p = node;
u = dn;
plotmesh(t, p, 0, 0, 'green');   // Estrutura original
scale = 1000;                    // Escala para visualização dos deslocamentos
pd = p + scale * dn;
plotmesh(t, pd, 0, 0, 'red');    // Estrutura deformada
legends(['antes da carga', 'depois da carga'], [color('green'), color('red')], 'ur');
drawnow;    
