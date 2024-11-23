// Definindo nós e conectividade
nodes = [0, 0, 0; 1, 0, 0; 1, 1, 0; 0, 1, 0; // Base inferior
         0, 0, 1; 1, 0, 1; 1, 1, 1; 0, 1, 1]; // Nível superior

elements = [1, 2, 3; 1, 3, 4; // Base inferior
            5, 6, 7; 5, 7, 8; // Base superior
            1, 2, 6; 1, 6, 5; // Colunas verticais
            2, 3, 7; 2, 7, 6;
            3, 4, 8; 3, 8, 7;
            4, 1, 5; 4, 5, 8]; // Conexões diagonais

// Plotando a malha
clf();
for i = 1:size(elements,1)
    x = nodes(elements(i,:),1);
    y = nodes(elements(i,:),2);
    z = nodes(elements(i,:),3);
    plot3(x,y,z,'b-'); // Plota as arestas em azul
    hold on;
end

xlabel("X");
ylabel("Y");
zlabel("Z");
title("Plotagem da Malha");
grid on;
hold off;
