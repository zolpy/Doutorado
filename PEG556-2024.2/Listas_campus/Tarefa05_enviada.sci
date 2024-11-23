clc; clear;
// Define material properties and geometry
E = 210;  // Young's modulus in Pa
nu = 0.3;   // Poisson's ratio
t = 1;  // thickness in meters
F = 1; // Force increased to 1kN to make deformation more visible

// Node coordinates (x,y)
nodes = [
    0, 0;    // Node 1
    1, 0;    // Node 2
    2, 0;    // Node 3
    2, 1;    // Node 4
    1, 1;    // Node 5
    0, 1     // Node 6
];

// Element connectivity (node1, node2, node3, node4)
elements = [
    1, 2, 5, 6;  // Element 1
    2, 3, 4, 5   // Element 2
];

// Global stiffness matrix initialization
K = zeros(12, 12);  // 2 DOF per node, 6 nodes total

// Plane stress material matrix
D = (E/(1-nu^2)) * [1, nu, 0;
                    nu, 1, 0;
                    0, 0, (1-nu)/2];

// Function to compute element stiffness matrix
function [ke] = element_stiffness(x1, y1, x2, y2, x3, y3, x4, y4, D, t)
    // Element dimensions
    a = abs(x2 - x1)/2;
    b = abs(y4 - y1)/2;
    
    // Gauss points
    gp = 1/sqrt(3);
    w1 = 1;
    w2 = 1;
    
    ke = zeros(8,8);
    
    // Numerical integration
    for i = [-gp, gp]
        for j = [-gp, gp]
            // Shape function derivatives
            dNdxi = [-(1-j)/4, (1-j)/4, (1+j)/4, -(1+j)/4];
            dNdeta = [-(1-i)/4, -(1+i)/4, (1+i)/4, (1-i)/4];
            
            // Jacobian
            J = [dNdxi*[x1;x2;x3;x4], dNdxi*[y1;y2;y3;y4];
                 dNdeta*[x1;x2;x3;x4], dNdeta*[y1;y2;y3;y4]];
            
            detJ = det(J);
            invJ = inv(J);
            
            // B matrix
            dNdx = [invJ(1,1)*dNdxi + invJ(1,2)*dNdeta];
            dNdy = [invJ(2,1)*dNdxi + invJ(2,2)*dNdeta];
            
            B = zeros(3,8);
            for n = 1:4
                B(1,2*n-1) = dNdx(n);
                B(2,2*n) = dNdy(n);
                B(3,2*n-1) = dNdy(n);
                B(3,2*n) = dNdx(n);
            end
            
            // Element stiffness contribution
            ke = ke + B'*D*B*detJ*t*w1*w2;
        end
    end
endfunction

// Assemble global stiffness matrix
for e = 1:2
    nodes_e = elements(e,:);
    xe = nodes(nodes_e, 1);
    ye = nodes(nodes_e, 2);
    ke = element_stiffness(xe(1), ye(1), xe(2), ye(2), xe(3), ye(3), xe(4), ye(4), D, t);
    
    // Assembly
    for i = 1:4
        for j = 1:4
            row = 2*nodes_e(i)-1:2*nodes_e(i);
            col = 2*nodes_e(j)-1:2*nodes_e(j);
            K(row,col) = K(row,col) + ke(2*i-1:2*i, 2*j-1:2*j);
        end
    end
end

// Apply boundary conditions
fixed_dofs = [1,2,11,12];  // DOFs for nodes 1 and 6
free_dofs = setdiff(1:12, fixed_dofs);

// Force vector
f = zeros(12,1);
f(8) = -F;  // Vertical force at node 4

// Solve for displacements
u = zeros(12,1);
u(free_dofs) = K(free_dofs,free_dofs)\f(free_dofs);

// Plot setup
scf();
clf();

// Adjust figure properties for better visualization
da = gca();
da.grid = [1 1];
da.box = "on";
da.margins = [0.1 0.1 0.1 0.1];
da.tight_limits = "on";

// Scale factor for deformation
scale = 2;  // Adjusted scale factor

// Original structure plotting
orig_x = [];
orig_y = [];
for e = 1:2
    node_nums = elements(e,:);
    // Add nodes and close the element
    x = [nodes(node_nums, 1); nodes(node_nums(1), 1)];
    y = [nodes(node_nums, 2); nodes(node_nums(1), 2)];
    orig_x = [orig_x; x; %nan];  // Add NaN to separate elements
    orig_y = [orig_y; y; %nan];
end

// Deformed structure plotting
def_x = [];
def_y = [];
deformed_nodes = nodes + [u(1:2:$) u(2:2:$)] * scale;
for e = 1:2
    node_nums = elements(e,:);
    // Add nodes and close the element
    x = [deformed_nodes(node_nums, 1); deformed_nodes(node_nums(1), 1)];
    y = [deformed_nodes(node_nums, 2); deformed_nodes(node_nums(1), 2)];
    def_x = [def_x; x; %nan];  // Add NaN to separate elements
    def_y = [def_y; y; %nan];
end

// Plot both structures
plot(orig_x, orig_y, 'g-', 'LineWidth', 2);
plot(def_x, def_y, 'b-', 'LineWidth', 2);

// Set axis limits to match reference image
da.data_bounds = [-0.4, -0.4; 2.2, 1.2];

// Add title and labels
title("Estrutura Original e Deformada (Escala " + string(scale) + "x)");
xlabel("Distância X (m)");
ylabel("Distância Y (m)");
legend(["Geometria Original", "Geometria Deformada"], "in_upper_right");

// Print displacements
printf("\nDeslocamentos nodais:\n");
for i = 1:6
    printf("Nó %d: ux = %.3e m, uy = %.3e m\n", i, u(2*i-1), u(2*i));
end
