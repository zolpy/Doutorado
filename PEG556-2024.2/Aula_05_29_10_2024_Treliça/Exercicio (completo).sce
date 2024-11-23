clear 
clc
E = 21e5;  // kgf/cm2
A = [1 1 1 1 sqrt(2) sqrt(2)];  // cm2
X = [0  0;
     0  21;
    21  0;
    21  21]; // Coordenadas dos nós (X,Y) em cm
i = [1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4];
j = [1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4];

// Cálculos das Matrizes de Rigidez e Montagem da Matriz Global
deltax = X(2,1)-X(1,1);
deltay = X(2,2)-X(1,2);
L1 = sqrt( deltax^2 +  deltay^2);  // mm
C=deltax/L1; S=deltay/L1;  
k =[C*C C*S -C*C -C*S; C*S S*S -C*S -S*S; -C*C -C*S C*C C*S; -C*S -S*S C*S S*S];
cte =(E*A(1))/L1; k1=cte*k;
K1=sparse([i(:),j(:)],k1,[8,8]); K1=full(K1);
KSte1 =  [-C -S C S];

deltax = X(3,1)-X(1,1);
deltay = X(3,2)-X(1,2);
L2 = sqrt( deltax^2 +  deltay^2);
C=deltax/L2; S=deltay/L2;  
k =[C*C C*S -C*C -C*S; C*S S*S -C*S -S*S; -C*C -C*S C*C C*S; -C*S -S*S C*S S*S];
cte =(E*A(2))/L2; k2=cte*k;
ii = [i(1:8),i(9:16)+2]; jj = [j(1:2),j(3:4)+2, j(1:2), j(3:4)+2, j(1:2), j(3:4)+2, j(1:2),j(3:4)+2];
K2 =sparse([ii(:),jj(:)],k2,[8,8]); K2 = full(K2);
KSte2 = [-C, -S, C, S];

deltax = X(4,1)-X(3,1);
deltay = X(4,2)-X(3,2);
L3 = sqrt( deltax^2 +  deltay^2);  
C=deltax/L3; S=deltay/L3;  
k =[C*C C*S -C*C -C*S; C*S S*S -C*S -S*S; -C*C -C*S C*C C*S; -C*S -S*S C*S S*S];
cte =(E*A(3))/L3; k3=cte*k;
K3=sparse([i(:)+4,j(:)+4],k3,[8,8]); K3=full(K3);
KSte3 =  [-C -S C S];

deltax = X(4,1)-X(2,1);
deltay = X(4,2)-X(2,2);
L4 = sqrt( deltax^2 +  deltay^2);  
C=deltax/L4; S=deltay/L4;  
k =[C*C C*S -C*C -C*S; C*S S*S -C*S -S*S; -C*C -C*S C*C C*S; -C*S -S*S C*S S*S];
cte =(E*A(4))/L4; k4=cte*k;
ii = [i(1:8)+2 i(9:16)+4]; jj = [j(1:2)+2 j(3:4)+4 j(1:2)+2 j(3:4)+4 j(1:2)+2 j(3:4)+4 j(1:2)+2 j(3:4)+4];
K4=sparse([ii(:),jj(:)],k4,[8,8]); K4=full(K4);
KSte4 =  [-C -S C S];

deltax = X(3,1)-X(2,1);
deltay = X(3,2)-X(2,2);
L5 = sqrt( deltax^2 +  deltay^2);  
C=deltax/L5; S=deltay/L5;  
k =[C*C C*S -C*C -C*S; C*S S*S -C*S -S*S; -C*C -C*S C*C C*S; -C*S -S*S C*S S*S];
cte =(E*A(5))/L5; k5=cte*k;
K5=sparse([i(:)+2,j(:)+2],k5,[8,8]); K5=full(K5);
KSte5 =  [-C -S C S];

deltax = X(4,1)-X(1,1);
deltay = X(4,2)-X(1,2);
L6 = sqrt( deltax^2 +  deltay^2);  
C=deltax/L6; S=deltay/L6;  
k =[C*C C*S -C*C -C*S; C*S S*S -C*S -S*S; -C*C -C*S C*C C*S; -C*S -S*S C*S S*S];
cte =(E*A(6))/L6; k6=cte*k;
ii=[i(1:8) i(9:16)+4]; jj=[j(1:2) j(3:4)+4 j(1:2) j(3:4)+4 j(1:2) j(3:4)+4 j(1:2) j(3:4)+4];
K6=sparse([ii(:),jj(:)],k6,[8,8]); K6=full(K6);
KSte6 =  [-C -S C S];

K=K1+K2+K3+K4+K5+K6;
K=full(K);
K(1:4,:)=[]; K(:,1:4)=[];
F=[ 0 0 0 -1000 ]';
u=inv(K)*F;
u= [0; 0 ;0; 0; u ]; // considerando engastes

// tensao nos elementos 
sigma12 = (E/L1)*(KSte1*u(1:4));
sigma13 = (E/L2)*(KSte2*[u(1:2); u(5:6)]);
sigma34 = (E/L3)*(KSte3*u(5:8));
sigma24 = (E/L4)*(KSte4*[u(3:4); u(7:8)]);
sigma23 = (E/L5)*(KSte5*u(3:6));
sigma14 = (E/L6)*(KSte6*[u(1:2); u(7:8)]);

sigma = [sigma12; sigma13; sigma34  ;sigma24 ; sigma23 ;sigma14];
disp("sigma = ", sigma)

// ================== PLOTAGEM ======================
scale = 30;
X_disp = X + scale * [0 0; 0 u(3); u(5) 0; u(7) u(8)];

clf(); // Limpa a figura atual
plot([X(1,1), X(2,1)], [X(1,2), X(2,2)], 'g-') // Original
plot([X(1,1), X(3,1)], [X(1,2), X(3,2)], 'g-') // Original
plot([X(2,1), X(4,1)], [X(2,2), X(4,2)], 'g-') // Original
plot([X(3,1), X(4,1)], [X(3,2), X(4,2)], 'g-') // Original
plot([X(1,1), X(4,1)], [X(1,2), X(4,2)], 'g-') // Original
plot([X(2,1), X(3,1)], [X(2,2), X(3,2)], 'g-') // Original

// Plotar a geometria deslocada
plot([X_disp(1,1), X_disp(2,1)], [X_disp(1,2), X_disp(2,2)], 'b-') // Deslocado
plot([X_disp(1,1), X_disp(3,1)], [X_disp(1,2), X_disp(3,2)], 'b-') // Deslocado
plot([X_disp(2,1), X_disp(4,1)], [X_disp(2,2), X_disp(4,2)], 'b-') // Deslocado
plot([X_disp(3,1), X_disp(4,1)], [X_disp(3,2), X_disp(4,2)], 'b-') // Deslocado
plot([X_disp(1,1), X_disp(4,1)], [X_disp(1,2), X_disp(4,2)], 'b-') // Deslocado
plot([X_disp(2,1), X_disp(3,1)], [X_disp(2,2), X_disp(3,2)], 'b-') // Deslocado

legend(["Original geometry", "Displaced geometry (x30)"]);
xgrid
