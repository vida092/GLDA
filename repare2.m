function matrix = repare2(matrix)
    % Asegúrate de que la matriz tenga dos columnas
    if size(matrix, 2) ~= 2
        error('La matriz debe tener exactamente dos columnas.');
    end
    
    % Extraer las columnas
    col1 = matrix(:, 1);
    col2 = matrix(:, 2);
    
    % Ajustar col2 para que sea ortogonal a col1
    col2 = col2 - (dot(col2, col1) / dot(col1, col1)) * col1;
    
    % Actualizar la matriz con la columna ortogonalizada
    matrix(:, 2) = col2;
end
