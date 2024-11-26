function scatter_plot_2d(matrix, D, plot_title)
    % Extrae las características y las etiquetas
    rows = size(D, 2);
    features = D(:, 1:rows-1);
    labels = D(:, rows);
    
    % Proyecta las características en el espacio 2D usando la matriz proporcionada
    projectedFeatures = features * matrix;
    matrix = [projectedFeatures, labels];

    % Extrae las coordenadas (x, y) y las etiquetas
    x = matrix(:, 1);
    y = matrix(:, 2);
    labels = matrix(:, 3);

    % Obtiene la lista única de etiquetas
    unique_labels = unique(labels);

    % Crea un mapa de colores
    colors = lines(length(unique_labels)); 

    % Crea la figura y habilita el grid
    figure;
    hold on;
    grid on;

    % Representa los puntos, coloreándolos según las etiquetas
    for i = 1:length(unique_labels)
        idx = labels == unique_labels(i);
        scatter(x(idx), y(idx), 20, colors(i, :), 'filled');
    end

    % Etiquetas y título
    xlabel('X');
    ylabel('Y');
    title(plot_title); % Usa el título proporcionado como parámetro

    % Agrega la leyenda
    legend(arrayfun(@num2str, unique_labels, 'UniformOutput', false));

    hold off;
end

