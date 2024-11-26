function mutant = mutate(matrix, mutation_probability)
    % Genera un número aleatorio entre 0 y 1
    r = rand;
    angle =  -pi/6 + (pi/6 - (-pi/6)) * rand(1, 1);
    
    % Aplica mutación 
    if r < mutation_probability
        % Genera la matriz de rotación para el ángulo dado y un eje aleatorio
        R = rotation_matrix(angle);
        
        % Aplica la rotación a la matriz original
        mutant = matrix * R;
    else
        mutant = matrix;
    end
end