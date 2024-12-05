function [best_individual, best_fitness, plot_line] = genetic_algorithm(num_individuals, num_generations, d, crossover_prob)
    % GENETIC_ALGORITHM Implementa un algoritmo genético completo
    %
    % Parámetros:
    %   num_individuals - Tamaño de la población
    %   num_generations - Número de generaciones
    %   d               - Dimensión de las matrices cuadradas W (dxd)
    %   crossover_prob  - Probabilidad de cruza
    %
    % Salidas:
    %   best_individual - Mejor individuo encontrado
    %   best_fitness    - Fitness del mejor individuo

    % Inicialización de la población
    plot_line = zeros(1, num_generations); % Preasignar espacio para eficiencia
    population.individual = cell(num_individuals, 1);
    population.fitness = zeros(num_individuals, 1);

    for i = 1:num_individuals
        population.individual{i} = rand(1, d^2); % Cada individuo es un vector de tamaño d^2
    end

    % Precalcular las matrices de dispersión (SB y SW_Cl)
    [SB, SW_Cl] = precalculate_scatter_matrices(d);

    % Evaluar la población inicial
    for i = 1:num_individuals
        population.fitness(i) = fitness_function(population.individual{i}, SB, SW_Cl, 'determinant', d);
    end

    % Algoritmo genético: iterar por generaciones
    for generation = 1:num_generations
        % Selección de padres usando SUS
        num_parents = num_individuals / 4; % Número de padres a seleccionar
        parents = sus_selection(population, num_parents);

        % Generar descendencia
        offspring.individual = cell(num_parents, 1);
        offspring.fitness = zeros(num_parents, 1);

        for i = 1:2:num_parents
            % Seleccionar dos padres al azar
            parent1 = parents.individual{i};
            parent2 = parents.individual{i+1};

            % Realizar cruza y mutación
            [offspring1, offspring2] = crossover_and_mutation(parent1, parent2, crossover_prob);

            % Guardar descendientes
            offspring.individual{i} = offspring1;
            offspring.individual{i+1} = offspring2;

            % Evaluar fitness de los descendientes
            offspring.fitness(i) = fitness_function(offspring1, SB, SW_Cl, 'determinant', d);
            offspring.fitness(i+1) = fitness_function(offspring2, SB, SW_Cl, 'determinant', d);
        end

        % Combinar población actual con descendientes
        combined_population.individual = [population.individual; offspring.individual];
        combined_population.fitness = [population.fitness; offspring.fitness];

        % Seleccionar los mejores individuos para la próxima generación
        [sorted_fitness, idx] = sort(combined_population.fitness, 'descend');
        population.individual = combined_population.individual(idx(1:num_individuals));
        population.fitness = combined_population.fitness(idx(1:num_individuals));

        % Guardar el mejor fitness de la generación actual
        plot_line(generation) = population.fitness(1);
        
    end


    best_individual = population.individual{1};
    best_fitness = population.fitness(1);

    % Graficar el progreso del fitness
    % figure;
    % plot(1:num_generations, plot_line, '-o');
    % xlabel('Generación');
    % ylabel('Mejor Fitness');
    % title('Evolución del Mejor Fitness por Generación');
    % grid on;
end


function [SB, SW_Cl] = precalculate_scatter_matrices(d)
    % Precálculo de matrices SB y SW_Cl para simulación
    SB = rand(d, d); % Matriz de dispersión entre clases simulada
    SW_Cl = rand(d, d); % Matriz de dispersión intra-clase simulada
    SB = SB' * SB; % Asegurar que sea semidefinida positiva
    SW_Cl = SW_Cl' * SW_Cl; % Asegurar que sea semidefinida positiva
end
