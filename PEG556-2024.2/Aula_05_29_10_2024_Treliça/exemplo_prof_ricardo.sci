clear; clc
E = 21e5; //kgf/cm2
A = [1,1,1,1,sqrt(2), sqrt(2)]; //cm2
L = 21 //cm
X = [0,0; 0,L; L,0; L,L]; //cm
i = [1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4];
j = [1,2,3,4,1,2,3,4,1,1,3,4,1,2,3,4];

//stiffness matrix of the element 1
disp("-------------------------------------")
disp("------------Elemento 1---------------")
mprintf("\n")
deltaX = X(2,1) - X(1,1);
//disp("deltaX: ", deltaX)
deltaY = X(2,2) - X(1,2);
//disp("deltaY: ", deltaY)
mprintf(" X(2,1) = %.2f [cm] \n X(1,1) = %.2f [cm] \n X(2,2) = %.2f [cm] \n X(1,2) = %.2f [cm]\n\n", X(2,1), X(1,1), X(2,2), X(1,2));

mprintf(" deltaX = %.2f [cm] \n deltaY = %.2f [cm]\n\n", deltaX, deltaY);


L1 = sqrt(deltaX^2+deltaY^2); //cm
C = deltaX/L1 //slipe of the element (cos)
S = deltaY/L1 //slipe of the element (sen)

mprintf(" L1 = %.2f [cm] \n  C = cos = %.2f [rad] \n  S = sen = %.2f [rad] \n", L1, C, S);

k = [C*C, C*S, -C*C, -C*S;
     C*S, S*S, -C*S, -S*S;
    -C*C,-C*S,  C*C,  C*S;
    -C*S,-S*S,  C*S,  S*S];

disp("")    
disp("Matriz (k): ",k)    
    
cte = (E*A(1))/L1;
k1 = cte*k;
mprintf("\ncte = %.2f \nk1 = %.2f \n\n", cte, k1);

K1 =sparse([i(:),j(:)],k1,[8,8]);
disp("sparse(K1) = ", K1)
disp("")
K1 = full(K1);
disp("full(K1) = ", K1)

disp("")
KSte1 = [-C, -S, C, S];
disp("KSte1 = ", KSte1)

//stiffness matrix oh the element 2
disp("-------------------------------------")
disp("------------Elemento 2---------------")
deltaX = X(3,1) - X(1,1);
deltaY = X(3,2) - X(1,2);
mprintf("\ndeltaX = %.2f \ndeltaY = %.2f \n\n", deltaX, deltaY);

L2 = sqrt(deltaX^2+deltaY^2); //cm
C = deltaX/L2 //slipe of the element (cos)
S = deltaY/L2 //slipe of the element (sen)
mprintf("L2 = %.2f [cm] \nC = %.2f [rad] \  nS = %.2f [rad] \n", L2, C, S);

k = [C*C, C*S, -C*C, -C*S;
     C*S, S*S, -C*S, -S*S;
    -C*C,-C*S,  C*C,  C*S;
    -C*S,-S*S,  C*S,  S*S];

disp("")    
disp("Matriz (k): ",k) 
    
cte = (E*A(2))/L2;
k2 = cte*k;
mprintf("cte = %.2f [cm] \nk2 = %.2f [rad] \n\n", cte, k2);

v1 = [i(1:8),i(9:16)+2];
v2 = [j(1:2),j(3:4)+2, j(1:2), j(3:4)+2, j(1:2), j(3:4)+2, j(1:2),j(3:4)+2];

mprintf("L1 = %.2f [cm] \nC = %.2f [rad] \nS = %.2f [rad] \n", L1, C, S);

K2 =sparse([v1(:),v2(:)],k2,[8,8]);
disp("sparse(K2) = ", K1)
disp("")

K2 = full(K2);
disp("full(K2) = ", K2)
disp("")

KSte2 = [-C, -S, C, S];
disp("KSte2 = ", KSte2)
disp("")

//stiffness matrix oh the element 3

disp("-------------------------------------")
disp("------------Elemento 3---------------")
deltaX = X(4,1) - X(3,1);
deltaY = X(4,2) - X(3,2);

mprintf("deltaX = %.2f [cm] \ndeltaY = %.2f [cm]\n\n", deltaX, deltaY);

L3 = sqrt(deltaX^2+deltaY^2); //mm
C = deltaX/L3 //slipe of the element (cos)
S = deltaY/L3 //slipe of the element (sen)

k = [C*C, C*S, -C*C, -C*S;
     C*S, S*S, -C*S, -S*S;
    -C*C,-C*S,  C*C,  C*S;
    -C*S,-S*S,  C*S,  S*S];
    
cte = (E*A(3))/L3;
k3 = cte*k;
v1 = i+4;
v2 = j+4;

K3 =sparse([v1(:),v2(:)],k3,[8,8]);
K3 = full(K3);
KSte3 = [-C, -S, C, S];

//stiffness matrix oh the element 4

deltaX = X(4,1) - X(2,1);
deltaY = X(4,2) - X(2,2);

L4 = sqrt(deltaX^2+deltaY^2); //mm
C = deltaX/L4 //slipe of the element (cos)
S = deltaY/L4 //slipe of the element (sen)

k = [C*C, C*S, -C*C, -C*S;
     C*S, S*S, -C*S, -S*S;
    -C*C,-C*S,  C*C,  C*S;
    -C*S,-S*S,  C*S,  S*S];
    
cte = (E*A(4))/L4;
k4 = cte*k;
v1 = [i(1:8)+2,i(9:16)+4];
v2 = [j(1:2)+2,j(3:4)+4, j(1:2)+2, j(3:4)+4, j(1:2)+2, j(3:4)+4, j(1:2)+2,j(3:4)+4];

K4 =sparse([v1(:),v2(:)],k4,[8,8]);
K4 = full(K4);
KSte4 = [-C, -S, C, S];

//stiffness matrix oh the element 5

deltaX = X(3,1) - X(2,1);
deltaY = X(3,2) - X(2,2);

L5 = sqrt(deltaX^2+deltaY^2); //mm
C = deltaX/L5 //slipe of the element (cos)
S = deltaY/L5 //slipe of the element (sen)

k = [C*C, C*S, -C*C, -C*S;
     C*S, S*S, -C*S, -S*S;
    -C*C,-C*S,  C*C,  C*S;
    -C*S,-S*S,  C*S,  S*S];
    
cte = (E*A(5))/L5;
k5 = cte*k;
v1 = i+2;
v2 = j+2;

K5 =sparse([v1(:),v2(:)],k5,[8,8]);
K5 = full(K5);
KSte5 = [-C, -S, C, S];

//stiffness matrix oh the element 6

deltaX = X(4,1) - X(1,1);
deltaY = X(4,2) - X(1,2);

L6 = sqrt(deltaX^2+deltaY^2); //mm
C = deltaX/L6 //slipe of the element (cos)
S = deltaY/L6 //slipe of the element (sen)

k = [C*C, C*S, -C*C, -C*S;
     C*S, S*S, -C*S, -S*S;
    -C*C,-C*S,  C*C,  C*S;
    -C*S,-S*S,  C*S,  S*S];
    
cte = (E*A(6))/L6;
k6 = cte*k;
v1 = [i(1:8),i(9:16)+4];
v2 = [j(1:2),j(3:4)+4, j(1:2), j(3:4), j(1:2), j(3:4), j(1:2)+2,j(3:4)];


K6 =sparse([v1(:),v2(:)],k6,[8,8]);
K6 = full(K6);
KSte6 = [-C, -S, C, S];

K = K1 + K2 + K3 + K4 + K5 + K6;
v = v1 + v2;

K = full(K);
K(1:4,:) = [];
K(:,1:4) = [];
F = [0,0,0,-1000]';
u = inv(K)*F;

//Stresses calculation
u = [0;0;0;0;v]; //clamping
sigma12 = (E/L1)*(KSte1*u(1:4));
sigma13 = (E/L2)*(KSte2*[u(1:2);u(5:6)]);
sigma34 = (E/L3)*(KSte3*u(5:8));
sigma24 = (E/L4)*(KSte4*[u(3:4);u(7:8)]);
sigma23 = (E/L5)*(KSte5*u(3:6));
sigma14 = (E/L6)*(KSte6*[u(1:2);u(7:8)]);
sigma = [sigma12;
         sigma13;
         sigma34;
         sigma24;
         sigma23;
         sigma14];

disp(sigma)

//Displament plot
u = v*30; //scale
U = [0,0;0,21;21+u(3),21+u(4);21+u(1); 0+u(2);0,0;21+u(3), 21+u(4);0,21;21+u(1),0+u(2)]; //displaced geometry
plot(Y(:,1),Y(:,2),"g-",U(:,1),U(:,2),"b-","LineWidth",2);
legend("Original geometry", "displaced geometry (x30)");
