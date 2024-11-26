clc 
clear
database= "golub_cleaned.csv";

D = readmatrix(database);

[m, n] = size(D);
features = D(:, 1:n-1);
labels = D(:, end);
classes = unique(labels);
num_classes = numel(classes);
n= n-1;
%conjuntos de entrenamiento y validación
train_data = [];
test_data = [];

% Porcentaje de división (70% para entrenamiento y 30% para validación)
train_ratio = 0.7;

for i = 1:num_classes
    class = classes(i);
    class_indices = find(labels == class);
    num_samples = numel(class_indices);
    num_train_samples = round(train_ratio * num_samples);
    
    % Mezcla índices aleatoriamente
    shuffled_indices = class_indices(randperm(num_samples));
    
    % Divide  en entrenamiento y validación
    train_indices = shuffled_indices(1:num_train_samples);
    test_indices = shuffled_indices(num_train_samples + 1:end);
    
    % Agrega a los conjuntos de datos
    train_data = [train_data; D(train_indices, :)];
    test_data = [test_data; D(test_indices, :)];
end




num_executions = 30; % Número de ejecuciones del algoritmo
all_populations = cell(1, num_executions); % Inicializar celda para almacenar las poblaciones
all_plots = cell(1,num_executions);
num_generations = 1000;
num_parents = 15;
num_matrices = 200;
mutation_probability = 0.085;

for execution = 1:num_executions
    plot_line = [];
    
    population(num_matrices) = struct('matrix', [], 'fitness', 0);

    for i = 1:num_matrices
        population(i).matrix = generate_basis(n);
        population(i).fitness = silhouetteFitness(D, population(i).matrix);
    end

    [~, idx] = sort([population.fitness], 'descend');
    population = population(idx);

    for generation = 1:num_generations

        %% Selección de los padres apartir de SUS %%%
        parent_indices = stochastic_universal_sampling(population, 2 * num_parents);
        
        % Generar descendencia y añadirla directamente a la población
        for i = 1:2:num_parents*2
            parent1 = population(parent_indices(i)).matrix;
            parent2 = population(parent_indices(i+1)).matrix;
            [child1, child2] = crossover(parent1, parent2);
            
            %Cruza con reparo paraa chamacos mensos
            mutant1 = mutate(child1, mutation_probability);
            mutant2 = mutate2(child2, mutation_probability);
            % mutant2 = child2;
            child1_fitness = silhouetteFitness(D, mutant1);
            child2_fitness = silhouetteFitness(D, mutant2); 
            population(end+1).matrix = mutant1;
            population(end).fitness = child1_fitness;
            population(end+1).matrix = mutant2;
            population(end).fitness = child2_fitness;
        end
        
        % Sobreviven los baby makers
        [~, idx] = sort([population.fitness], 'descend');
        population = population(idx);
        population = population(1:end-(2*num_parents));
        
        % Almacenar el mejor fitness de la generación para el plot
        plot_line = [plot_line, population(1).fitness];
        
        fprintf('Generación %d: Mejor fitness = %.4f\n', generation, population(1).fitness);
    end

    all_populations{execution} = population; 
    all_plots{execution}=plot_line;
    fprintf('Ejecución %d completada.\n', execution);
end

best_fitnesses = zeros(1, num_executions);
for i = 1:num_executions
    best_fitnesses(i) = all_populations{i}(1).fitness; % El mejor fitness de cada ejecución
end

elapsed_time = toc;
fprintf('Tiempo de ejecución : %.4f segundos\n', elapsed_time);

[~, idx_max] = max(best_fitnesses);
[~, idx_min] = min(best_fitnesses);

% Ordenar best_fitnesses y encontrar el índice mediano
sorted_fitnesses = sort(best_fitnesses);
median_fitness = sorted_fitnesses(ceil(num_executions / 2));
original_idx_median = find(best_fitnesses == median_fitness, 1, 'first'); 

fprintf('Ejecución con el máximo fitness: %d (Fitness: %.4f)\n', idx_max, best_fitnesses(idx_max));
fprintf('Ejecución con el mínimo fitness: %d (Fitness: %.4f)\n', idx_min, best_fitnesses(idx_min));
fprintf('Ejecución con el fitness mediano: %d (Fitness: %.4f)\n', original_idx_median, median_fitness);

best_gen_plot = all_populations{1,idx_max}.fitness;

worst_gen_plot = all_populations{1,idx_min}.fitness;

median_gen_plot = all_populations{1,original_idx_median}.fitness;


scatter_plot_3d(all_populations{1, idx_max}(1).matrix,train_data, 'Proyección sobre training');

scatter_plot_3d(all_populations{1, idx_max}(1).matrix, test_data, 'Proyección sobre testing');

scatter_plot_3d(all_populations{1, idx_max}(1).matrix, D, 'Proyección sobre dataset completo');


figure
p1 = plot(all_plots{idx_max}, 'DisplayName', 'Máximo');
hold on;
p2 = plot(all_plots{idx_min}, 'DisplayName', 'Mínimo');
p3 = plot(all_plots{original_idx_median}, 'DisplayName', 'Mediana');
grid on;
legend;



DA = features * all_populations{1, original_idx_median}(1).matrix;
DA = [DA, labels];
csvwrite('projected3d_' + database, DA);

%scatterByLabel(D,[1,2,3]);

scatter_plot_3d(all_populations{1, original_idx_median}(1).matrix, D, 'Proyecasdfjasdfset completo');
      