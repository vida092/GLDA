function mutatedMatrix = mutate2(matrix, probability)
    % Copia la matriz original para preservar su tamaño y estructura
    mutatedMatrix = matrix;
    % Genera un número aleatorio para decidir si se realiza el swap
    if rand() < probability
        % Selecciona dos filas distintas al azar
        numRows = size(matrix, 1);
        rows = randperm(numRows, 2);
        % Realiza el swap entre las filas seleccionadas
        tempRow = mutatedMatrix(rows(1), :);
        mutatedMatrix(rows(1), :) = mutatedMatrix(rows(2), :);
        mutatedMatrix(rows(2), :) = tempRow;
    end
end
