clear; clc
// Material properties
E = 30e6;
G = 80e6;

// Cross-sectional properties
A = 6.8;
Iz = 65;
Iy = 45;
J = 50;

// Length of the element (assume 1 m)
L = 1;

// Global stiffness matrix
K = [
    A*E/L 0 0 0 0 0 -A*E/L 0 0 0 0 0;
    0 12*E*Iz/L^3 0 0 6*E*Iz/L^2 0 0 -12*E*Iz/L^3 0 0 -6*E*Iz/L^2 0;
    0 0 12*E*Iy/L^3 0 0 6*E*Iy/L^2 0 0 -12*E*Iy/L^3 0 0 -6*E*Iy/L^2;
    0 0 0 G*J/L 0 0 0 0 0 -G*J/L 0 0 0;
    0 6*E*Iz/L^2 0 0 4*E*Iz/L 0 0 -6*E*Iz/L^2 0 0 2*E*Iz/L 0;
    0 0 6*E*Iy/L^2 0 0 4*E*Iy/L 0 0 -6*E*Iy/L^2 0 0 2*E*Iy/L;
    -A*E/L 0 0 0 0 0 A*E/L 0 0 0 0 0;
    0 -12*E*Iz/L^3 0 0 -6*E*Iz/L^2 0 0 12*E*Iz/L^3 0 0 6*E*Iz/L^2 0;
    0 0 -12*E*Iy/L^3 0 0 -6*E*Iy/L^2 0 0 12*E*Iy/L^3 0 0 6*E*Iy/L^2;
    0 0 0 -G*J/L 0 0 0 0 0 G*J/L 0 0 0;
    0 -6*E*Iz/L^2 0 0 -2*E*Iz/L 0 0 6*E*Iz/L^2 0 0 4*E*Iz/L 0;
    0 0 -6*E*Iy/L^2 0 0 -2*E*Iy/L 0 0 6*E*Iy/L^2 0 0 4*E*Iy/L];

// Global force vector
F = [0 0 0 0 0 0 3000 500 300 500 300 400]';

// Apply boundary conditions (fix node 1)
K(1:6, :) = 0;
K(:, 1:6) = 0;
K(1:6, 1:6) = eye(6);

// Solve for displacements
U = K \ F;

// Display results
disp(U);
