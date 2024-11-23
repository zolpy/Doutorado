clear; clc;
E = 200; nu = 0.3; t = 1;

i = [1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 5 6 6 6 6 6 6];
j = [1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6];

//ELEMENTO 1
x1= 0.5; y1=1; x2= 0; y2=0; x3= 1; y3=0; 
Area = [x1 y1 1; 
x2 y2 1
x3 y3 1 ]; 
A=abs(0.5*det(Area));

cte1=(E*t)/(4*A*(1-nu^2));
cte2=(E*t)/(8*A*(1+nu));
x21=x2-x1; x31=x3-x1; x32=x3-x2; y21=y2-y1; y31=y3-y1; y32=y3-y2;
ke_1=cte1*[y32^2 -nu*y32*x32 -y32*y31 nu*y32*x31 y32*y21 -nu*y32*x21 
-nu*y32*x32 x32^2 nu*x32*y31 -x32*x31 -nu*x32*y21 x32*x21 
-y32*y31 nu*x32*y31 y31^2 -nu*y31*x31 -y31*y21 nu*y31*x21 
nu*y32*x31 -x32*x31 -nu*y31*x31 x31^2 nu*x31*y21 -x31*x21 
y32*y21 -nu*x32*y21 -y31*y21 nu*x31*y21 y21^2 -nu*y21*x21
-nu*y32*x21 x32*x21 nu*y31*x21 -x31*x21 -nu*y21*x21 x21^2];
ke_2 = cte2*[x32^2 -x32*y32 -x32*x31 x32*y31 x32*x21 -x32*y21
-x32*y32 y32^2 y32*x31 -y32*y31 -y32*x21 y32*y21 
-x32*x31 y32*x31 x31^2 -x31*y31 -x31*x21 x31*y21 
x32*y31 -y32*y31 -x31*y31 y31^2 y31*x21 -y31*y21 
x32*x21 -y32*x21 -x31*x21 y31*x21 x21^2 -x21*y21 
-x32*y21 y32*y21 x31*y21 -y31*y21 -x21*y21 y21^2];
k = ke_1+ke_2

k1 = sparse([i(:), j(:)], k, [10,10]);

//ELEMENTO 2
x1= 0.5; y1=1; x2= 1; y2=0; x3= 1.5; y3=1;
Area = [x1 y1 1; 
x2 y2 1
x3 y3 1 ]; 
A=abs(0.5*det(Area));

cte1=(E*t)/(4*A*(1-nu^2));
cte2=(E*t)/(8*A*(1+nu));
x21=x2-x1; x31=x3-x1; x32=x3-x2; y21=y2-y1; y31=y3-y1; y32=y3-y2;
ke_1=cte1*[y32^2 -nu*y32*x32 -y32*y31 nu*y32*x31 y32*y21 -nu*y32*x21 
-nu*y32*x32 x32^2 nu*x32*y31 -x32*x31 -nu*x32*y21 x32*x21 
-y32*y31 nu*x32*y31 y31^2 -nu*y31*x31 -y31*y21 nu*y31*x21 
nu*y32*x31 -x32*x31 -nu*y31*x31 x31^2 nu*x31*y21 -x31*x21 
y32*y21 -nu*x32*y21 -y31*y21 nu*x31*y21 y21^2 -nu*y21*x21
-nu*y32*x21 x32*x21 nu*y31*x21 -x31*x21 -nu*y21*x21 x21^2];
ke_2 = cte2*[x32^2 -x32*y32 -x32*x31 x32*y31 x32*x21 -x32*y21
-x32*y32 y32^2 y32*x31 -y32*y31 -y32*x21 y32*y21 
-x32*x31 y32*x31 x31^2 -x31*y31 -x31*x21 x31*y21 
x32*y31 -y32*y31 -x31*y31 y31^2 y31*x21 -y31*y21 
x32*x21 -y32*x21 -x31*x21 y31*x21 x21^2 -x21*y21 
-x32*y21 y32*y21 x31*y21 -y31*y21 -x21*y21 y21^2];
k = ke_1+ke_2

v1 = [i(1:12), i(13:36)+2];
v2 = [j(1:2), j(3:6)+2, j(1:2), j(3:6)+2, j(1:2), j(3:6)+2, j(1:2), j(3:6)+2, j(1:2),j(3:6)+2, j(1:2),j(3:6)+2];
k2 = sparse([v1(:), v2(:)], k, [10,10]);

//ELEMENTO 3
x1= 1; y1=0; x2= 2; y2=0; x3= 1.5; y3=1;
Area = [x1 y1 1; 
x2 y2 1
x3 y3 1 ]; 
A=abs(0.5*det(Area));

cte1=(E*t)/(4*A*(1-nu^2));
cte2=(E*t)/(8*A*(1+nu));
x21=x2-x1; x31=x3-x1; x32=x3-x2; y21=y2-y1; y31=y3-y1; y32=y3-y2;
ke_1=cte1*[y32^2 -nu*y32*x32 -y32*y31 nu*y32*x31 y32*y21 -nu*y32*x21 
-nu*y32*x32 x32^2 nu*x32*y31 -x32*x31 -nu*x32*y21 x32*x21 
-y32*y31 nu*x32*y31 y31^2 -nu*y31*x31 -y31*y21 nu*y31*x21 
nu*y32*x31 -x32*x31 -nu*y31*x31 x31^2 nu*x31*y21 -x31*x21 
y32*y21 -nu*x32*y21 -y31*y21 nu*x31*y21 y21^2 -nu*y21*x21
-nu*y32*x21 x32*x21 nu*y31*x21 -x31*x21 -nu*y21*x21 x21^2];
ke_2 = cte2*[x32^2 -x32*y32 -x32*x31 x32*y31 x32*x21 -x32*y21
-x32*y32 y32^2 y32*x31 -y32*y31 -y32*x21 y32*y21 
-x32*x31 y32*x31 x31^2 -x31*y31 -x31*x21 x31*y21 
x32*y31 -y32*y31 -x31*y31 y31^2 y31*x21 -y31*y21 
x32*x21 -y32*x21 -x31*x21 y31*x21 x21^2 -x21*y21 
-x32*y21 y32*y21 x31*y21 -y31*y21 -x21*y21 y21^2];
k = ke_1+ke_2

k3 = sparse([i(:)+4, j(:)+4], k, [10,10]);

k_g = k1 + k2 + k3;

// Restricted DoFs - (3, 4, and 10)
k_g(10, :) = []; k_g(:, 10) = [];
k_g(3:4, :) = []; k_g(:, 3:4) = [];
novak = full(k_g)

f = 0.1
F = [0; -f; 0; 0;0;-f;0]
x=inv(novak)*F

//plot
u = [0.5,1, 0,0,1,0,1.5,1,2,0]';
v = [x(1); x(2); 0 ;0 ; x(3:7); 0];
scale = 100
u_desloc = u + scale*v
plot([u(1),u(3),u(5),u(7),u(9)],[u(2),u(3),u(5),u(8),u(10)], 'b', [u_desloc(1),u_desloc(3),u_desloc(5),u_desloc(7),u_desloc(9)],[u_desloc(2),u_desloc(3),u_desloc(5),...
u_desloc(8),u_desloc(10)], 'g')
legend('original', 'deslocada')
