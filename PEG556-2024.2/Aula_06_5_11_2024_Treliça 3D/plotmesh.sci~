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
          xstring(x,y,z,string(i));
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
      f.data_bounds = [x_min-0.1*delta_x, y_min-0.1*delta_y; x_max+0.1*delta_x, y_max+0.1*delta_y];
    end
endfunction

// Daddos de entrada
E = 210000;d = 25;A = ((d^2)*%pi)/4;EA = E*A; F = -1000;
mprintf("E= %.2f; d= %.2f A= %.2f; EA= %.2f; F= %.2f  \n\n",E,d,A,EA,F)
node = [0,0,0; 0,0,1; 1,0,0; 1,0,1; 1,1,0; 1,1,1; 0,1,0; 0,1,1];// coordenadas dos nós
xx = node(:,1);yy = node(:,2);zz = node(:,3);// 1ª col = X e 2ª col = Y
element = [1,2;3,4;5,6;7,8;
           1,3;2,4;8,6;7,5;
           1,7;3,5;4,6;2,8;
           8,5;2,3]//;1,4;7,6];// conectividade dos elementos
numnode = size(node,1);// número total de nós
numelem = size(element,1);// número total de elementos

// Matrizes de rigidez
U = zeros(3*numnode,1);// Matriz deslocamento c/ todos elementos iguais a zero
K = zeros(3*numnode,3*numnode);// Matriz K c/ todos elementos iguais a zero
for e = 1:numelem
  indice = element(e,:);  // O índice 1 representa o 1º elem, o índice 2 representa o 2º elem, etc...
  // 3 GL sempre multiplica o índice por 3
  indiceB = [3*indice(1)-2,3*indice(1)-1,3*indice(1),3*indice(2)-2,3*indice(2)-1,3*indice(2)];
  // relaciona os dofs dos nos de cada elemento
  xa = xx(indice(2))-xx(indice(1));  // diferença da coordenada de cada elemento em X
  ya = yy(indice(2))-yy(indice(1));  // diferença da coordenada de cada elemento em Y
  za = zz(indice(2))-zz(indice(1));  // diferença da coordenada de cada elemento em z
  length_element = sqrt(xa*xa+ya*ya+za*za);  // comprimento do elemento
  c = xa/length_element;  // inclinação alfa
  s = ya/length_element;  // inclinação beta
  r = za/length_element;  // inclinação gama
  k1 = (EA/length_element)*[c*c,c*s,c*r,-c*c,-c*s,-c*r;c*s,s*s,s*r,-c*s,-c*c,-s*r;c*r,s*r,r*r,-c*r,-s*r,-r*r;-c*c,-c*s,-c*r,c*c,c*s,c*r;-c*s,-s*s,-s*r,c*s,s*s,s*r;-c*r,-s*r,-r*r,c*r,s*r,r*r];
  K(indiceB,indiceB) = K(indiceB,indiceB)+k1;  // Matriz de rigidez global
end;

// Restrição dos nós
P = [0,0,0,0,0,0,0,0,0,0,0,F,0,0,0,0,0,F,0,0,0,0,0,0]';// F atua no 3o GL do nó 4
f = P(7:18);
K2 = K(7:18,7:18);// 6 1os (nós 1 e 2) e 6 últimos (nós 7 e 8) GLs restritos
x = K2\f;
xd = [0,0,0,0,0,0,(x(1:12))',0,0,0,0,0,0]'; // Retorna os GLs restritos = 0.

// Cálculo das tensões: idem looping da matriz de rigidez, exceto duas ultimas linhas
for e = 1:numelem
  indice = element(e,:);  // O índice 1 representa o 1º elem, o índice 2 representa o 2º elem, etc...
  indiceB = [3*indice(1)-2,3*indice(1)-1,3*indice(1),3*indice(2)-2,3*indice(2)-1,3*indice(2)];  // relaciona os DoFs dos nos de cada elemento
  xa = xx(indice(2))-xx(indice(1));  // diferença da coordenada de cada elemento em X
  ya = yy(indice(2))-yy(indice(1));  // diferença da coordenada de cada elemento em Y
  za = zz(indice(2))-zz(indice(1));  // diferença da coordenada de cada elemento em z
  length_element = sqrt(xa*xa+ya*ya+za*za);  // comprimento do elemento
  c = xa/length_element;  // inclinação alfa
  s = ya/length_element;  // inclinação beta
  r = za/length_element;  // inclinação gama
  T = [c,s,r,0,0,0;0,0,0,c,s,r];  // Matriz rotação
  d1 = T*xd(indiceB);  // deslocamento
  deltaL = d1(2,:)-d1(1,:);
  Eps = deltaL*(1/length_element);  // Deformação específica
  Sigma(1,e) = E*Eps;  // Tensão
end;
Sigmad = [(Sigma(1,:))';(Sigma(1,:))'];
disp(Sigma(1,:))

// plotar deslocamentos (dn)
dn = [(xd(1:3))';(xd(4:6))';(xd(7:9))';(xd(10:12))';(xd(13:15))';(xd(16:18))';(xd(19:21))';(xd(22:24))'];
drawlater;
t = element; p = node; u = dn;
plotmesh(t, p, 0, 0, 'green');
scale = 1000;
pd = p + scale * dn;
plotmesh(t, pd, 0, 0, 'red');
legends(['before loading', 'after loading'], [color('green'), color('red')], 'ur');
drawnow;
