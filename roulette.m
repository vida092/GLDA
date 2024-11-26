function selected_index = roulette(population)
    % Extrae los valores de fitness de la población
    fitness_values = [population.fitness];
    
    % Calcula la suma total de fitness
    total_fitness = sum(fitness_values);
    
    % Normaliza los valores de fitness para obtener probabilidades de selección
    selection_probabilities = fitness_values / total_fitness;
    
    cumulative_probabilities = cumsum(selection_probabilities);
    
    % Genera un número aleatorio entre 0 y 1
    r = rand;
    
    % Encuentra el índice del primer individuo cuya probabilidad acumulada es mayor que r
    selected_index = find(cumulative_probabilities >= r, 1, 'first');
end
