function selected_parents = sus_selection(population, num_parents)
    % SUS_SELECTION Selecciona padres usando Stochastic Universal Sampling (SUS)
    %
    % Parámetros:
    %   population  - Estructura con los campos:
    %                 .individual (Nx1 celdas con vectores de individuos)
    %                 .fitness (Nx1 vector de aptitudes)
    %   num_parents - Número de padres a seleccionar
    %
    % Salida:
    %   selected_parents - Estructura con los padres seleccionados
    %                      (misma estructura que la población)

    % Extraer la cantidad de individuos
    num_individuals = length(population.fitness);

    % Calcular la aptitud total
    fitness_total = sum(population.fitness);

    % Calcular las probabilidades de selección
    probabilities = population.fitness / fitness_total;

    % Calcular la suma acumulativa de probabilidades
    cumulative_prob = cumsum(probabilities);

    % Calcular los puntos de la ruleta
    step_size = fitness_total / num_parents;
    start_point = rand() * step_size;
    points = start_point + (0:num_parents-1) * step_size;

    % Selección de padres
    selected_parents.individual = cell(num_parents, 1);
    selected_parents.fitness = zeros(num_parents, 1);

    % Inicializar índice para la ruleta
    j = 1;

    % Seleccionar individuos usando SUS
    for i = 1:num_parents
        % Asegurar que el índice j no exceda el tamaño
        while j <= num_individuals && points(i) > cumulative_prob(j)
            j = j + 1;
        end

        % Si se alcanza el final de cumulative_prob, tomar el último individuo
        if j > num_individuals
            j = num_individuals;
        end

        % Guardar el padre seleccionado
        selected_parents.individual{i} = population.individual{j};
        selected_parents.fitness(i) = population.fitness(j);
    end
end
