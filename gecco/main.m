clc
clear
filename = "ionospherec.csv";
D = readmatrix(filename);
labels = D(:,end);
X = D(:,1:end-1);


[SB, SW_Cl] = compute_scatter_matrices(X, labels);
[m, d] = size(X);


num_individuals = 120;
num_generations = 25000;
crossover_prob = 0.1;
num_executions = 30;
final =[];
plots(num_executions) = struct('ejecution', 0, 'plotline', [], 'best_fitness', 0, 'best_individual', []);
for i=1:num_executions

    [best_individual, best_fitness, cplot] = genetic_algorithm(num_individuals, num_generations, d, crossover_prob);
    
    % Mostrar resultados
    disp('Mejor individuo encontrado:');
    disp(reshape(best_individual,[d,d]));
    disp('Fitness del mejor individuo:');
    disp(best_fitness);
    final = [final best_fitness];
    plots(i).ejecution=i;
    plots(i).plotline = cplot;
    plots(i).best_fitness = best_fitness;
    plots(i).best_individual = best_individual;
end

best_fitnesses = zeros(1,num_executions);
for i=1:num_executions
    best_fitnesses(i)= plots(i).best_fitness;
end
[~, idx_max] = max(best_fitnesses);
[~, idx_min] = min(best_fitnesses);
sorted_fitnesses = sort(best_fitnesses);
median_fitness = sorted_fitnesses(ceil(num_executions / 2));
original_idx_median = find(best_fitnesses == median_fitness, 1, 'first');

median_individual = plots(original_idx_median).best_individual;
median_individual = reshape(median_individual, [d,d]);
newspace = X * median_individual;
newspace = [newspace labels];
writematrix(newspace, 'GA-LDA_ ' + filename)


colors = {'b', 'g', 'r', 'c', 'm', 'y', 'k'};
figure;
plot(1:num_generations, plots(original_idx_median).plotline, '-', 'Color', colors{1});
hold on;


grid on;

xlabel('Generations');
ylabel('Values');
legend('Original Median');

disp('Valor máximo en 30 ejecuciones:')
disp(max(final))
disp('Valor mínimo en 30 ejecuciones:')
disp(min(final))
disp('media de 30 ejecuciones:')
disp(mean(final))
disp('desviación estandar 30 ejecucions:')
disp(std(final))
final=sort(final);
disp('mediana de 30 ejecuciones')
disp(final(floor(num_executions/2)))



