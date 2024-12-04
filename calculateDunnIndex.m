function dunnIndex = calculateDunnIndex(matrix)
    % Separar datos y etiquetas
    data = matrix(:, 1:end-1);  % Características
    labels = matrix(:, end);   % Etiquetas
    
    % Identificar clusters únicos
    uniqueClusters = unique(labels);
    numClusters = length(uniqueClusters);
    
    % Inicializar distancias entre clusters y diámetros de clusters
    clusterDiameters = zeros(numClusters, 1);
    interClusterDistances = inf(numClusters, numClusters);
    
    % Calcular diámetros de cada cluster
    for i = 1:numClusters
        clusterPoints = data(labels == uniqueClusters(i), :);
        if size(clusterPoints, 1) > 1
            % Distancias entre puntos del cluster
            distances = pdist(clusterPoints, 'euclidean');
            clusterDiameters(i) = max(distances);
        else
            clusterDiameters(i) = 0; % Clusters con un solo punto tienen diámetro 0
        end
    end
    
    % Calcular distancias entre clusters
    for i = 1:numClusters
        for j = i+1:numClusters
            cluster1Points = data(labels == uniqueClusters(i), :);
            cluster2Points = data(labels == uniqueClusters(j), :);
            % Distancia mínima entre puntos de clusters diferentes
            pairwiseDistances = pdist2(cluster1Points, cluster2Points, 'euclidean');
            interClusterDistances(i, j) = min(pairwiseDistances(:));
        end
    end
    
    % Índice Dunn
    dunnIndex = min(interClusterDistances(interClusterDistances > 0)) / max(clusterDiameters);
end
