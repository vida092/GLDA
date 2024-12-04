clc 
clear
database= "tfidf.csv";

D = readmatrix(database);%, Range=2);

features = D(:,1:end-2);
labels = D(:, end-1);
% D = [D(:,2:end-1) labels];
[m, n] = size(D);
classes = unique(labels);
num_classes = numel(classes);
n= n-1;
%conjuntos de entrenamiento y validación
train_data = [];
test_data = [];
display("base lista")
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

size(train_data)



%%%%%%%% Parámetros %%%%%%%%%%%%%%%%%%%%

num_executions = 1; 
all_populations = cell(1, num_executions); % Aquí se guardan las poblaciones mano
all_plots = cell(1,num_executions); % Aquí se guardan los números para los plots de cada ejecución
num_generations = 1000;  
num_parents = 15;
num_matrices = 250;
mutation_probability = 0.17;

%%%%%%%%%%%%%%%% Comienzan las   ejecuciones %%%%%%%%%%%%%%%
for execution = 1:num_executions
    plot_line = [];
    
    %%%%%%%%%%% Population vacía %%%%%%%%%%%
    population(num_matrices) = struct('matrix', [], 'fitness', 0);


    %%%%%%% Se llena la población %%%%%%%
    for i = 1:num_matrices
        population(i).matrix = generate_basis2(n);
        population(i).fitness = silhouetteFitness(train_data, population(i).matrix);
    end
    
    [~, idx] = sort([population.fitness], 'descend');
    population = population(idx);
    
    %%%%% Comienzan las generaciones %%%%    
    for generation = 1:num_generations
        
        %% Selección de los padres apartir de SUS %%%
        parent_indices = stochastic_universal_sampling(population, 2 * num_parents);
        
        % Generar descendencia y añadirla directamente a la población
        for i = 1:2:num_parents*2
            parent1 = population(parent_indices(i)).matrix;
            parent2 = population(parent_indices(i+1)).matrix;
            [child1, child2] = crossover2(parent1, parent2);
            mutant1 = mutate3(child1, mutation_probability);
            mutant2 = mutate3(child2, mutation_probability);
            child1_fitness = silhouetteFitness(train_data, mutant1);
            child2_fitness = silhouetteFitness(train_data, mutant2);
            population(end+1).matrix = mutant1;
            population(end).fitness = child1_fitness;
            population(end+1).matrix = mutant2;
            population(end).fitness = child2_fitness;
        end
        
        % Ordenar la población por aptitud y seleccionar los mejores
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


%%%%% Estadísticas %%%%%
%%%%% se guardan los mejores fitnes de cada ejecución %%%%%%
best_fitnesses = zeros(1, num_executions);
for i = 1:num_executions
    best_fitnesses(i) = all_populations{i}(1).fitness; % El mejor fitness de cada ejecución
end

%%% Guardo el mejor y peor fitnes de cada ejecución$$$$$
[~, idx_max] = max(best_fitnesses);
[~, idx_min] = min(best_fitnesses);

%%%%%%% Ordenar best_fitnesses y encontrar el índice mediano
sorted_fitnesses = sort(best_fitnesses);
median_fitness = sorted_fitnesses(ceil(num_executions / 2));
original_idx_median = find(best_fitnesses == median_fitness, 1, 'first'); 

fprintf('Ejecución con el máximo fitness: %d (Fitness: %.4f)\n', idx_max, best_fitnesses(idx_max));
fprintf('Ejecución con el mínimo fitness: %d (Fitness: %.4f)\n', idx_min, best_fitnesses(idx_min));
fprintf('Ejecución con el fitness mediano: %d (Fitness: %.4f)\n', original_idx_median, median_fitness);
fprintf('Desviación estandar:  %.4f\n', std(best_fitnesses));
fprintf('Media:  %.4f\n', mean(best_fitnesses));


%%%%%% Plots de la mejor, la peor y la mediana de las ejecuciones
best_gen_plot = all_populations{1,idx_max}.fitness;

worst_gen_plot = all_populations{1,idx_min}.fitness;

median_gen_plot = all_populations{1,original_idx_median}.fitness;




scatter_plot_2d(all_populations{1, original_idx_median}(1).matrix,train_data, 'Proyección sobre training');

scatter_plot_2d(all_populations{1, original_idx_median}(1).matrix, test_data, 'Proyección sobre testing');

scatter_plot_2d(all_populations{1, original_idx_median}(1).matrix, D, 'Proyección sobre dataset completo');



figure
p1 = plot(all_plots{idx_max}, 'DisplayName', 'Máximo');
hold on;
p2 = plot(all_plots{idx_min}, 'DisplayName', 'Mínimo');
p3 = plot(all_plots{original_idx_median}, 'DisplayName', 'Mediana');
grid on;
legend;


scatterByLabel(D,[1,2,3]);

DA = D(:,1:end-1) * all_populations{1, original_idx_median}(1).matrix;
DA = [DA labels];
GLDA_dataset = "GLDA_2D_" + database;
csvwrite(GLDA_dataset, DA)

runClassification(GLDA_dataset, 'holdout', 0.3);
runClassification(GLDA_dataset, 'kfold');



