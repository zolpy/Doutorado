clear;clc;
// input data
E = 30000000;A = 1;EA = E*A;L = 90;
mprintf("\n\tE = %.2f \n\tA = %.2f \n\tEA = %.2f \n\tL = %.2f\n", E,A,EA,L )

numx = 3;// number of elements

node = linspace(0,L,numx+1);//inicio, fim, quantos segmentos
//mprintf("\n\t node = linspace(0,L,numx+1); \n", node)

node1=[(node(1:4))', [0 0 0 0]'];

//mprintf("\n\t node1 \n", node1)

// Define nodes, elements and DOFs
n=1:numx;
//mprintf("n: ", n )
element(:,1)=n;
element(:,2)=element+1; // define elements in sequential order
numnode=size(node,2);
numelem=size(element,1);
ndof = numnode;
xx=node;

mprintf("\n\txx: ")
disp(xx)
mprintf("\n")

// Stiffness matrix
K = sparse([],[],[numnode,numnode]);
mprintf("\n\tK: ")
disp(K)
mprintf("\n")

for e = 1:numelem
    index = element(e,:); // vector DoF for each element
    nn = size(index,"*"); // vector index length
    length_element = node(index(2))-node(index(1));
    detJ0 = length_element/2; // J=L/2
    invJ0 = 1/detJ0; // J^-1
    N = ([1,1]/2)'; // shape function matrix
    dNdxi = [-1;1]/2; // derived from shape function matrix in relation
    // to the natural coordinates
    dNdx = dNdxi*invJ0;
    // derived from shape function matrix in relation to X (local coordinates)
    // matrix B *** [K] = sum of [B]' T. [D]. [B]. |J| , where [D] = E.A ***
    B = [-1/length_element  1/length_element]; // deformation vector
    K(index,index) = K(index,index)+(B'*E*B*A*detJ0*2); //B'E = 2/L = dr/dx
end;
K=full(K)
disp("Matriz K")
disp(K)

// Load vector
f = zeros(numnode, 1);
mprintf("\n matriz f: \n")
disp(f)
f(2) = 3000;

// Boundary conditions
fixedNodeW = find(xx == min(node(:)) | xx == max(node(:)))';
dofs = [fixedNodeW];

// 1st and last nodes restricted
U = zeros(numnode, 1);
act = setdiff((1:ndof)', dofs);
U = K(act, act) \ f(act);
//U(act) = K(act, act) \ f(act);
U1 = zeros(ndof, 1);
U1(act) = U;
U = U1;

// Stress calculation
stress = zeros(numelem, size(element, 2), 1);
stressPoints(1, 1) = -1; stressPoints(1, 2) = 1;
for e = 1:numelem
    index = element(e, :); indexB = index; nn = size(index, "*");
    for q = 1:nn
        pt = stressPoints(q);
        N = ([1-pt, 1 + pt] / 2)';
        dNdxi = [-1; 1] / 2;
        dNdx = dNdxi * invJ0; // same as lines of previous looping up to here
        B = [-1 / length_element  1 / length_element]; // deformation vector
        strain = B * U(indexB); stress(e, q) = E * strain;
    end;
end;
disp(stress(: , 1));
Y = node' + U*1000;
plot(node(1), 0, "ro");
plot(Y(2), 0, "bo"); plot(Y(3), 0, "bo");
plot(node(2), 0, "ro"); plot(node(3), 0, "ro");
plot(node(4), 0, "ro");
hl = legend(["original nodes", "displaced nodes (x1000)"]);
xgrid;
