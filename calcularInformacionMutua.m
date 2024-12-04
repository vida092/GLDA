function [infoMutuas, promedioIM] = calcularInformacionMutua(data)
    % Extraer características y etiquetas
    X = data(:, 1:end-1);  % Todas las columnas excepto la última
    Y = data(:, end);      % Última columna: etiquetas

    numFeatures = size(X, 2);  % Número de características
    infoMutuas = zeros(numFeatures, 1);  % Inicializar vector de información mutua

    % Estimar la densidad de cada característica y la etiqueta
    [fY, y] = ksdensity(Y);
    dy = mean(diff(y));
    fY = fY * dy;  % Normalizar la densidad

    for i = 1:numFeatures
        [fX, x] = ksdensity(X(:, i));
        dx = mean(diff(x));
        fX = fX * dx;  % Normalizar la densidad
        
        % Densidad conjunta aproximada mediante el producto de las densidades marginales
        % Esto asume independencia, solo para propósitos demostrativos
        [Xgrid, Ygrid] = meshgrid(x, y);
        fXY = interp1(x, fX, Xgrid(:)) .* interp1(y, fY, Ygrid(:));
        fXY = reshape(fXY, length(y), length(x));
        
        % Normalización de la densidad conjunta
        fXY = fXY * dx * dy;
        
        % Cálculo de entropías
        H_X = -sum(fX .* log2(fX + eps));
        H_Y = -sum(fY .* log2(fY + eps));
        H_XY = -sum(fXY(:) .* log2(fXY(:) + eps));
        
        % Calcular la información mutua
        infoMutuas(i) = H_X + H_Y - H_XY;
    end
    
    % Calcular el promedio de la información mutua
    promedioIM = mean(infoMutuas);
    
    % Mostrar los resultados
    disp('Información mutua para cada característica con respecto a las etiquetas:');
    disp(infoMutuas);
    disp(['Promedio de Información Mutua: ', num2str(promedioIM)]);
end
