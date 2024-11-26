clear 
% D = readmatrix("iris2.csv", "Range",2);
D1 =readmatrix("puntos.csv");
labels = D1(:,end);
D = PolinomialExpansion(D1(:,1:(end-1)),2);
D = table2array(D);
D = [D, labels];
[m ,n] = size(D);
n= n-1;

num_matrices = 50;
num_generations = 100 ;
num_parents = 25;
mutation_probability = 0.35;


population(num_matrices) = struct('matrix', [], 'fitness', 0);

for i = 1:num_matrices
    population(i).matrix = generate_basis(n);
    % population(i).fitness = fitness2(population(i).matrix,D,D(:,end));
end

[~, idx] = sort([population.fitness], 'descend');
population = population(idx);
conv_plot = [];


for generation = 1:num_generations
    new_population = population; 
    
    % Seleccionar los padres usando el muestreo universal estocástico
    parent_indices = stochastic_universal_sampling(population, 2 * num_parents);
    
    for i = 1:2:num_parents*2
        parent1 = population(parent_indices(i)).matrix;
        parent2 = population(parent_indices(i+1)).matrix;

        % Realizar cruce
        [child1, child2] = crossover(parent1, parent2);

        % Realizar mutación
        mutant1 = mutate(child1,  mutation_probability);
        mutant2 = mutate(child2,  mutation_probability);

        % Calcular el fitness de los nuevos individuos
        child1_fitness = fitness2(mutant1,D,D(:,end));
        child2_fitness = fitness2(mutant2,D,D(:,end));

        % Agregar los nuevos individuos a la nueva población
        new_population(end+1).matrix = mutant1;
        new_population(end).fitness = child1_fitness;
        new_population(end+1).matrix = mutant2;
        new_population(end).fitness = child2_fitness;
    end
    
    % Ordenar la población nuevamente por valores de fitness de mayor a menor
    [~, idx] = sort([new_population.fitness], 'descend');
    new_population = new_population(idx);
    
    % Eliminar los individuos menos aptos
    new_population = new_population(1:end-(2*num_parents));
    

    population = new_population;
    conv_plot =[conv_plot,population(1).fitness];
    

    fprintf('Generación %d: Mejor fitness = %.4f\n', generation, population(1).fitness);
end

scatter_plot_3d(population(1).matrix,D)