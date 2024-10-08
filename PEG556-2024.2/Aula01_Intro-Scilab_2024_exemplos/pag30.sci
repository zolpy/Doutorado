
clear; clc

x = input('x='); // Ler a entrada do usuário
if x < 0 then
    y = 2 * x; // Se x for negativo, y é o dobro de x
else
    y = x; // Se x for não negativo, y é igual a x
end

// Exibir o resultado
mprintf('y = %.0f\n', y);
