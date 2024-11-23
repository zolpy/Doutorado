clear;
clc;

// Definir parâmetros do problema
E = 1.9e5; // Módulo de elasticidade em lb/in²
A = 8; // Área transversal em in²
L = 36; // Comprimento em in (para as barras horizontais)

// Função para calcular o comprimento, coseno e seno
function [L_e, c, s, grau] = elength(x1, y1, x2, y2)
    L_e = sqrt((x2 - x1)^2 + (y2 - y1)^2); // Comprimento da barra
    c = (x2 - x1) / L_e;
    s = (y2 - y1) / L_e;
    angulo_rad = atan(s/c); // Calcula o ângulo em radianos com a função arco tangente
    grau = angulo_rad * (180 / %pi); // Converte para graus
endfunction

// Calcular comprimentos e ângulos para as barras
[L1, c1, s1, grau1] = elength(0, 0, L, 0);
[L2, c2, s2, grau2] = elength(L, 0, 0, L);
[L3, c3, s3, grau3] = elength(0, L, L, L);
[L4, c4, s4, grau4] = elength(L, 0, L, L);
[L5, c5, s5, grau5] = elength(L, 0, 2*L, L);
[L6, c6, s6, grau6] = elength(L, L, 2*L, L);

// Imprimir resultados
mprintf("-----------------Resultados---------------------\n")
mprintf(" L1 = %.3f [in], cos = %.3f, sin = %.3f, grau1 = %.1f [°]\n", L1, c1, s1, grau1);
mprintf(" L2 = %.3f [in], cos = %.3f, sin = %.3f, grau2 = %.1f [°]\n", L2, c2, s2, grau2);
mprintf(" L3 = %.3f [in], cos = %.3f, sin = %.3f, grau3 = %.1f [°]\n", L3, c3, s3, grau3);
mprintf(" L4 = %.3f [in], cos = %.3f, sin = %.3f, grau4 = %.1f [°]\n", L4, c4, s4, grau4);
mprintf(" L5 = %.3f [in], cos = %.3f, sin = %.3f, grau5 = %.1f [°]\n", L5, c5, s5, grau5);
mprintf(" L6 = %.3f [in], cos = %.3f, sin = %.3f, grau6 = %.1f [°]\n", L6, c6, s6, grau6);
mprintf("------------------------------------------------\n")
//-----------------Resultados---------------------
// L1 = 36.000 [in], cos = 1.000, sin = 0.000, grau1 = 0.0 [°]
// L2 = 50.912 [in], cos = -0.707, sin = 0.707, grau2 = -45.0 [°]
// L3 = 36.000 [in], cos = 1.000, sin = 0.000, grau3 = 0.0 [°]
// L4 = 36.000 [in], cos = 0.000, sin = 1.000, grau4 = 90.0 [°]
// L5 = 50.912 [in], cos = 0.707, sin = 0.707, grau5 = 45.0 [°]
// L6 = 36.000 [in], cos = 1.000, sin = 0.000, grau6 = 0.0 [°]
//------------------------------------------------

function [k]=estiffness(E,A,L_e,c,s)
    k= (E * A / L_e) * [c^2, c*s, -c^2, -c*s;
                        c*s, s^2, -c*s, -s^2;
                       -c^2, -c*s, c^2, c*s;
                       -c*s, -s^2, c*s, s^2];
endfunction

k1 = estiffness (E,A,L1,c1,s1)
k2 = estiffness (E,A,L2,c2,s2)
k3 = estiffness (E,A,L3,c3,s3)
k4 = estiffness (E,A,L4,c4,s4)
k5 = estiffness (E,A,L5,c5,s5)
k6 = estiffness (E,A,L6,c6,s6)

// Imprimir resultados
mprintf("----------------------------------------------k1\n")
disp(k1)
mprintf("----------------------------------------------k2\n")
disp(k2)
mprintf("----------------------------------------------k3\n")
disp(k3)
mprintf("----------------------------------------------k4\n")
disp(k4)
mprintf("----------------------------------------------k5\n")
disp(k5)
mprintf("----------------------------------------------k6\n")
disp(k6)
mprintf("------------------------------------------------\n")

//----------------------------------------------k1
//   42222.222   0.  -42222.222   0.
//   0.          0.   0.          0.
//  -42222.222   0.   42222.222   0.
//   0.          0.   0.          0.
//----------------------------------------------k2
//   14927.81  -14927.81  -14927.81   14927.81
//  -14927.81   14927.81   14927.81  -14927.81
//  -14927.81   14927.81   14927.81  -14927.81
//   14927.81  -14927.81  -14927.81   14927.81
//----------------------------------------------k3
//   42222.222   0.  -42222.222   0.
//   0.          0.   0.          0.
//  -42222.222   0.   42222.222   0.
//   0.          0.   0.          0.
//----------------------------------------------k4
//   0.   0.          0.   0.       
//   0.   42222.222   0.  -42222.222
//   0.   0.          0.   0.       
//   0.  -42222.222   0.   42222.222
//----------------------------------------------k5
//   14927.81   14927.81  -14927.81  -14927.81
//   14927.81   14927.81  -14927.81  -14927.81
//  -14927.81  -14927.81   14927.81   14927.81
//  -14927.81  -14927.81   14927.81   14927.81
//----------------------------------------------k6
//   42222.222   0.  -42222.222   0.
//   0.          0.   0.          0.
//  -42222.222   0.   42222.222   0.
//   0.          0.   0.          0.
//------------------------------------------------


