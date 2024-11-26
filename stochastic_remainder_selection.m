function selected_indices = stochastic_remainder_selection(population, num_selections)
    % Extrae los valores de fitness de la población
    fitness_values = [population.fitness];
    
    % Calcula la suma total de fitness
    total_fitness = sum(fitness_values);
    
    % probabilidades de selección
    selection_probabilities = fitness_values / total_fitness;
    
    % Inicializa el vector de índices seleccionados
    selected_indices = [];
    
    % Asignación determinística
    for i = 1:length(selection_probabilities)
        count = floor(selection_probabilities(i) * num_selections);
        selected_indices = [selected_indices, repmat(i, 1, count)];
    end
    
    remainder_probabilities = selection_probabilities * num_selections - floor(selection_probabilities * num_selections);
    cumulative_probabilities = cumsum(remainder_probabilities);
    
    while length(selected_indices) < num_selections
        r = rand;
        selected_index = find(cumulative_probabilities >= r, 1, 'first');
        selected_indices = [selected_indices, selected_index];
    end
    
    selected_indices = selected_indices(1:num_selections);
end
