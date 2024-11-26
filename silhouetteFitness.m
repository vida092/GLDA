function fitnessValue = silhouetteFitness(D, B)
    % D: Base de datos original (última columna son las etiquetas)
    % B: Matriz de proyección
    

    rows = size(D, 2);
    features = D(:, 1:rows-1); % 
    labels = D(:, rows);      % Etiquetas
    
    % Proyectar las características usando la matriz B
    projectedFeatures = features * B;
    projectedData = [projectedFeatures, labels];
    
    % Calcular el coeficiente de silueta para los datos proyectados
    try
        % Normalización (opcional, dependiendo de los datos)
        %normalizedFeatures = zscore(projectedFeatures);
        normalizedFeatures = projectedFeatures;
        
        % Calcular el coeficiente de silueta promedio
        sValues = silhouette(normalizedFeatures, labels);
        fitnessValue = mean(sValues); % Promedio global como fitness
    catch
        % Si ocurre un error, asignar un valor muy bajo para que no sea
        % tomado en cuenta
        fitnessValue = -inf;
    end
end
