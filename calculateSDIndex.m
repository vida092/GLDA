function sdIndex = calculateSDIndex(matrix, alpha)
    % Separar datos y etiquetas
    data = matrix(:, 1:end-1);  % Características
    labels = matrix(:, end);   % Etiquetas
    
    % Identificar clusters únicos
    uniqueClusters = unique(labels);
    numClusters = length(uniqueClusters);
    
    % Inicializar variables
    clusterStdDevs = zeros(numClusters, 1);
    clusterCentroids = zeros(numClusters, size(data, 2));
    
    % Calcular compacidad (S)
    for i = 1:numClusters
        clusterPoints = data(labels == uniqueClusters(i), :);
        clusterCentroids(i, :) = mean(clusterPoints, 1); % Centroides de clusters
        if size(clusterPoints, 1) > 1
            % Desviación estándar de las distancias intra-cluster
            distances = pdist(clusterPoints, 'euclidean');
            clusterStdDevs(i) = std(distances);
        else
            clusterStdDevs(i) = 0; % Clusters con un solo punto tienen desviación 0
        end
    end
    S = mean(clusterStdDevs); % Compacidad promedio
    
    % Calcular separación (D)
    centroidDistances = pdist(clusterCentroids, 'euclidean');
    D = min(centroidDistances(centroidDistances > 0)); % Distancia mínima entre centroides
    
    % Calcular el índice SD
    sdIndex = alpha * S * D;
    
end
