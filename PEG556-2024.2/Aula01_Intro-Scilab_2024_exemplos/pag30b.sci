clear; clc  
x = input('x='); // Ler a entrada do usuário
if x < 0 then
    y = -x; // Se x for negativo, y é o oposto de x
elseif x == 1 then
    y = x; // Se x for igual a 1, y é igual a x
elseif x == 2 then
    y = 2 * x; // Se x for igual a 2, y é o dobro de x
else
    y = 5 * x; // Para outros valores de x, y é cinco vezes x
end

// Exibir o resultado
mprintf('y = %.0f\n', y);
