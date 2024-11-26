filename = 'data1.csv'; % Reemplaza con la ruta de tu archivo
D = readmatrix(filename); % Lee el archivo CSV como una matriz numérica

% 2. Separa las características (X) y las etiquetas (y)
X = D(:, 1:end-1); % Todas las columnas excepto la última
y = D(:, end);     % Última columna (etiquetas)


X_normalized = zscore(X);

% Calcular y graficar el coeficiente de silueta
figure;
silhouette(X_normalized, y);

% Si deseas obtener los valores numéricos
[s_values, h] = silhouette(X_normalized, y);
silhouette_avg = mean(s_values); % Promedio global
disp(['Promedio del coeficiente de silueta: ', num2str(silhouette_avg)]);

% Calcular la matriz de distancias
distances = pdist2(X_normalized, X_normalized); % Matriz de distancias


n = size(X_normalized, 1); % Número de puntos
s_values = zeros(n, 1); % Para almacenar coeficientes de silueta

for i = 1:n
    % Índices de puntos en la misma clase
    same_class = y == y(i);
    same_class(i) = false; % Excluir el propio punto
    
    % Índices de puntos en otras clases
    other_classes = y ~= y(i);
    
    % Calcular a(i)
    a_i = mean(distances(i, same_class));
    
    % Calcular b(i) para la clase más cercana
    b_i = min(arrayfun(@(c) mean(distances(i, y == c)), unique(y(other_classes))));
    
    % Calcular el coeficiente de silueta para el punto i
    s_values(i) = (b_i - a_i) / max(a_i, b_i);
end


silhouette_avg = mean(s_values);
disp(['Promedio del coeficiente de silueta (manual): ', num2str(silhouette_avg)]);



% Ordenar puntos por clase para visualización
[sorted_y, idx] = sort(y);
sorted_s_values = s_values(idx);

% Graficar los coeficientes de silueta
bar(sorted_s_values);
xlabel('Índice de Puntos Ordenados por Clase');
ylabel('Coeficiente de Silueta');
title('Coeficientes de Silueta');
grid on;


