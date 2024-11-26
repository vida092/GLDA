clear 
D1 =readmatrix("image16.csv");
labels = D1(:,end);
D = PolinomialExpansion(D1(:,1:(end-1)),2);
D = table2array(D);
D = [D, labels];
disp("listo0")
%D= readmatrix("image16.csv");
[m, n] = size(D);
n= n-1;

num_matrices = 150;
population(num_matrices) = struct('matrix', [], 'fitness', 0);
disp("listo1")
% Inicializar la población
for i = 1:num_matrices
    population(i).matrix = generate_basis(n);
    population(i).fitness = fitness(D, population(i).matrix);
end

% Ordenar la población inicial por fitness
[~, idx] = sort([population.fitness], 'descend');
population = population(idx);
disp("listo2")
num_generations = 1000;
num_parents = floor(num_matrices / 2) * 2; % Asegurar que el número de padres sea par
mutation_probability = 0.3;
conv_plot = [];

for generation = 1:num_generations
    % Guardar el mejor individuo de la generación actual (elitismo)
    best_individual = population(1); % El mejor siempre estará en la primera posición tras ordenar

    new_population = struct('matrix', [], 'fitness', 0);  % Nueva población vacía
    
    % Seleccionar los padres usando el muestreo universal estocástico
    parent_indices = stochastic_universal_sampling(population, num_parents);
    
    % Generar n nuevos individuos
    for i = 1:2:num_parents
        parent1 = population(parent_indices(i)).matrix;
        parent2 = population(parent_indices(i+1)).matrix;
        
        % Realizar cruce
        [child1, child2] = crossover(parent1, parent2);
        
        % Realizar mutación
        mutant1 = mutate(child1, mutation_probability);
        mutant2 = mutate(child2, mutation_probability);
        
        % Calcular el fitness de los nuevos individuos
        child1_fitness = fitness(D, mutant1);
        child2_fitness = fitness(D, mutant2);
        
        % Añadir los nuevos individuos a la nueva población
        new_population(end+1).matrix = mutant1;
        new_population(end).fitness = child1_fitness;
        new_population(end+1).matrix = mutant2;
        new_population(end).fitness = child2_fitness;
    end
    
    % Ordenar la nueva población por fitness (de mayor a menor)
    [~, idx] = sort([new_population.fitness], 'descend');
    new_population = new_population(idx);
    
    % Reemplazar al peor individuo de la nueva generación con el mejor de la anterior
    new_population(end) = best_individual;
    
    % Ordenar la población nuevamente tras el reemplazo
    [~, idx] = sort([new_population.fitness], 'descend');
    new_population = new_population(idx);
    
    % Actualizar la población con la nueva generación
    population = new_population;
    
    % Almacenar el mejor fitness de la generación actual
    conv_plot = [conv_plot, population(1).fitness];
    
    % Mostrar la mejor aptitud de la generación actual
    fprintf('Generación %d: Mejor fitness = %.4f\n', generation, population(1).fitness);
end

% Graficar la evolución del mejor fitness
plot(conv_plot);
grid on 
xlabel('Generación');
ylabel('Mejor Fitness');
title('Evolución del Mejor Fitness');


scatter_plot_3d(population(1).matrix,D)


