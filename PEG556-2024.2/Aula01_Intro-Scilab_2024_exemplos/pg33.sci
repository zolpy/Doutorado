clear; clc

function [x1, x2, delta] = calculateRoots(a, b, c)
    // Calcula o discriminante
    delta = b^2 - 4*a*c;

    if delta > 0 then
        // Duas raízes reais distintas
        x1 = (-b + sqrt(delta)) / (2*a);
        x2 = (-b - sqrt(delta)) / (2*a);
    elseif delta == 0 then
        // Uma raiz dupla
        x1 = -b / (2*a);
        x2 = x1; // x2 é igual a x1
    else
        // Delta < 0, valores aleatórios
        x1 = rand(1, 1); // Gera um número aleatório
        x2 = rand(1, 1); // Gera outro número aleatório
    end
endfunction

// Programa principal
function main()
    a = input('Digite o coeficiente a (a != 0): ');
    
    while a == 0 do
        a = input('O coeficiente a deve ser diferente de zero. Digite novamente: ');
    end

    b = input('Digite o coeficiente b: ');
    c = input('Digite o coeficiente c: ');

    // Chama a função para calcular as raízes
    [x1, x2, delta] = calculateRoots(a, b, c);

    if delta > 0 then
        disp('As raízes são:');
        disp(x1);
        disp(x2);
    elseif delta == 0 then
        disp('A raiz dupla é:');
        disp(x1);
    else
        disp('Delta é negativo. Raízes reais não existem, valores gerados:');
        // Exibe os valores aleatórios, se necessário
        disp('Valores aleatórios gerados para x1 e x2:');
        disp(x1);
        disp(x2);
    end
endfunction

// Executa o programa principal
main();

