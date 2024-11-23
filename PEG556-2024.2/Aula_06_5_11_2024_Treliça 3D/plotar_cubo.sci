// Definindo os nós do cubo
node = [0,0,0; 0,0,1; 1,0,0; 1,0,1; 1,1,0; 1,1,1; 0,1,0; 0,1,1];

// Definindo as arestas do cubo (conectividade entre os nós)
edges = [1 2; 2 4; 4 3; 3 1; // Base inferior
         5 6; 6 8; 8 7; 7 5; // Base superior
         1 5; 2 6; // Conexões verticais
         3 7; 4 8]; // Conexões verticais

// Criando a figura
clf(); // Limpa a figura atual
hold on;

// Plotando as arestas do cubo
for i = 1:size(edges, 1)
    x = node(edges(i,:), 1); // Coordenadas x
    y = node(edges(i,:), 2); // Coordenadas y
    z = node(edges(i,:), 3); // Coordenadas z
    plot3(x, y, z, 'k-'); // Plota a aresta em preto
end

// Configurações do gráfico
xlabel("X");
ylabel("Y");
zlabel("Z");
title("Cubo em 3D");
grid on;
axis equal; // Para manter a proporção correta entre os eixos
hold off;
