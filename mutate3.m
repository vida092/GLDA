function mutant = mutate3(matrix, mutation_probability)
    % Genera un número aleatorio entre 0 y 1
    r = rand;
    angle =  -pi/8 + (pi/8 - (-pi/8)) * rand(1, 1);
    % Aplica mutación 
    if r < mutation_probability
        % Genera la matriz de rotación para el ángulo dado y un eje aleatorio
        R = [cos(angle) -sin(angle) ; sin(angle) cos(angle)];
        
        % Aplica la rotación a la matriz original
        mutant = matrix * R;
    else
        mutant = matrix;
    end
end