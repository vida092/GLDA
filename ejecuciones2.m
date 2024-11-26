clear 
D1 = readmatrix("puntos.csv");
labels = D1(:,end);
D = PolinomialExpansion(D1(:,1:(end-1)),2);
D = table2array(D);
D = [D, labels];
[m ,n] = size(D);
n= n-1;

num_matrices = 50;
num_generations = 00;
num_parents = 15;
mutation_probability = 0.35;
num_executions = 3; % Número de veces que se ejecutará el algoritmo
all_populations = cell(1, num_executions); % Celda para almacenar las poblaciones finales
all_plots = cell(1,num_executions); %Celda para almacenar las gráficas de convergencia
for execution = 1:num_executions
    plot_line = [];
    population(num_matrices) = struct('matrix', [], 'fitness', 0);
    for i = 1:num_matrices
        population(i).matrix = generate_basis(n);
        population(i).fitness = fitness2(population(i).matrix, D, D(:,end));
    end
    disp("lista la primera generación")
    
    [~, idx] = sort([population.fitness], 'descend');
    population = population(idx);
    
    for generation = 1:num_generations
        new_population = population; % Crear una copia de la población actual
        
        parent_indices = stochastic_universal_sampling(population, 2 * num_parents);
        
        for i = 1:2:num_parents*2
            parent1 = population(parent_indices(i)).matrix;
            parent2 = population(parent_indices(i+1)).matrix;
            [child1, child2] = crossover(parent1, parent2);
            mutant1 = mutate(child1, mutation_probability);
            mutant2 = mutate(child2, mutation_probability);
            child1_fitness = fitness2(mutant1, D, D(:,end));
            child2_fitness = fitness2(mutant2, D, D(:,end));
            new_population(end+1).matrix = mutant1;
            new_population(end).fitness = child1_fitness;
            new_population(end+1).matrix = mutant2;
            new_population(end).fitness = child2_fitness;
        end
        
        [~, idx] = sort([new_population.fitness], 'descend');
        new_population = new_population(idx);
        new_population = new_population(1:end-(2*num_parents));
        population = new_population;
        plot_line=[plot_line, population(1).fitness];
        fprintf('Generación %d: Mejor fitness = %.4f\n', generation, population(1).fitness);
    end
    
    all_populations{execution} = population; % Almacenar la población final
    all_plots{execution}=plot_line;
    fprintf('Ejecución %d completada.\n', execution);
    
end

best_fitnesses = zeros(1, num_executions);
for i = 1:num_executions
    best_fitnesses(i) = all_populations{i}(1).fitness; % El mejor fitness de cada ejecución
end

[~, idx_max] = max(best_fitnesses);
[~, idx_min] = min(best_fitnesses);

sorted_fitnesses = sort(best_fitnesses);
median_fitness = sorted_fitnesses(ceil(num_executions / 2));
original_idx_median = find(best_fitnesses == median_fitness, 1, 'first');

fprintf('Ejecución con el máximo fitness: %d (Fitness: %.4f)\n', idx_max, best_fitnesses(idx_max));
fprintf('Ejecución con el mínimo fitness: %d (Fitness: %.4f)\n', idx_min, best_fitnesses(idx_min));
fprintf('Ejecución con el fitness mediano: %d (Fitness: %.4f)\n', original_idx_median, median_fitness);

best_gen_plot = all_populations{1,idx_max}.fitness;

worst_gen_plot = all_populations{1,idx_min}.fitness;

median_gen_plot = all_populations{1,original_idx_median}.fitness;

scatter_plot_3d(all_populations{1,idx_max}(1).matrix,D);
figure; 

% Graficar la curva con el valor máximo
plot(all_plots{idx_max}, 'LineWidth', 2); 

% Graficar la curva con el valor mínimo
plot(all_plots{idx_min}, 'LineWidth', 2);

% Graficar la curva que corresponde al índice mediano
plot(all_plots{original_idx_median}, 'LineWidth', 2);


grid on;

legend('Máximo', 'Mínimo', 'Mediano', 'Location', 'best'); 


xlabel('Índice'); % Etiqueta del eje X
ylabel('Valor'); % Etiqueta del eje Y
title('Comparación de Curvas'); 
max_value = max(best_fitnesses);  % Encuentra el valor máximo
min_value = min(best_fitnesses);  % Encuentra el valor mínimo
median_value = median(best_fitnesses);  % Calcula la mediana
mean_value = mean(best_fitnesses);  % Calcula la media
std_deviation = std(best_fitnesses);  % Calcula la desviación estándar


disp(['Valor máximo: ', num2str(max_value)]);
disp(['Valor mínimo: ', num2str(min_value)]);
disp(['Mediana: ', num2str(median_value)]);
disp(['Media: ', num2str(mean_value)]);
disp(['Desviación estándar: ', num2str(std_deviation)]);
