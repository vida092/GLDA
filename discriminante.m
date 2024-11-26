% clear
% 
% 
% data = readmatrix("dataset.csv");
% 
% species2 = data(:,end); % Etiquetas de clase
% group2 = species2; % Alias para mayor claridad
% 
% pl = data(:,1); % Primer feature
% pw = data(:,2); % Segundo feature
% 
% % Gráfica de dispersión
% h1 = gscatter(pl, pw, species2, 'krb', 'ov^', [], 'off');
% legend('0', '1', '2', 'Location', 'best');
% xlabel('x');
% ylabel('y');
% 
% % Partición de datos
% rng('default'); % Para reproducibilidad
% cv = cvpartition(group2, 'HoldOut', 0.10);
% trainInds2 = training(cv);
% sampleInds2 = test(cv);
% 
% % Datos de entrenamiento y prueba
% trainingData2 = [pl(trainInds2), pw(trainInds2)];
% sampleData2 = [pl(sampleInds2), pw(sampleInds2)];
% 
% % Clasificación
% [class2, err2, posterior2, logp2, coeff2] = classify(sampleData2, trainingData2, group2(trainInds2));
% 
% % Calcular la precisión
% trueLabels = group2(sampleInds2); % Etiquetas reales del conjunto de prueba
% accuracy = sum(class2 == trueLabels) / numel(trueLabels); % Precisión
% fprintf('Accuracy: %.2f%%\n', accuracy * 100);
% 
% % Líneas de decisión
% % Línea entre clases 0 y 1
% % K2 = coeff2(2,3).const;
% % L2 = coeff2(2,3).linear;
% 
% f2 = @(x1,x2) K2 + L2(1)*x1 + L2(2)*x2;
% hold on;
% h2 = fimplicit(f2, [min(pl) max(pl) min(pw) max(pw)]);
% h2.Color = 'r';
% h2.DisplayName = 'Boundary between 0 & 1';
% 
% % Línea entre clases 1 y 2
% K2 = coeff2(1,2).const;
% L2 = coeff2(1,2).linear;
% 
% f2 = @(x1,x2) K2 + L2(1)*x1 + L2(2)*x2;
% h3 = fimplicit(f2, [min(pl) max(pl) min(pw) max(pw)]);
% h3.Color = 'k';
% h3.DisplayName = 'Boundary between 1 & 2';
% 
% % Línea entre clases 0 y 2
% K2 = coeff2(1,3).const;
% L2 = coeff2(1,3).linear;
% 
% f2 = @(x1,x2) K2 + L2(1)*x1 + L2(2)*x2;
% h4 = fimplicit(f2, [min(pl) max(pl) min(pw) max(pw)]);
% h4.Color = 'b'; % Color diferente para esta línea
% h4.DisplayName = 'Boundary between 0 & 2';
% 
% grid on
% hold off;
% axis tight;
% title('Linear Classification with Fisher Training Data');


clear;

% Cargar datos
data = readmatrix("GLDA_2D_iris2.csv", Range=2);

% Asumimos que la última columna son las etiquetas de clase
species2 = data(:, end); % Etiquetas de clase
group2 = species2; % Alias para mayor claridad

% Extraer características (se asume que las características están antes de la última columna)
features = data(:, 1:end-1);

% Gráfica de dispersión
figure;
h1 = gscatter(features(:, 1), features(:, 2), species2, lines(numel(unique(species2))));
legend('Location', 'best');
xlabel('Feature 1');
ylabel('Feature 2');
title('Scatter plot of the data');

% Partición de datos
rng('default'); % Para reproducibilidad
cv = cvpartition(group2, 'HoldOut', 0.10);
trainInds2 = training(cv);
sampleInds2 = test(cv);

% Datos de entrenamiento y prueba
trainingData2 = features(trainInds2, :);
sampleData2 = features(sampleInds2, :);

% Clasificación
[class2, err2, posterior2, logp2, coeff2] = classify(sampleData2, trainingData2, group2(trainInds2));

% Calcular la precisión
trueLabels = group2(sampleInds2); % Etiquetas reales del conjunto de prueba
accuracy = sum(class2 == trueLabels) / numel(trueLabels); % Precisión
fprintf('Accuracy: %.5f%%\n', accuracy * 100);

% Líneas de decisión
hold on;
classes = unique(species2);
nClasses = numel(classes);

% Generar límites de decisión para todas las combinaciones de clases
for i = 1:nClasses
    for j = i+1:nClasses
        K2 = coeff2(i, j).const;
        L2 = coeff2(i, j).linear;
        f2 = @(x1, x2) K2 + L2(1) * x1 + L2(2) * x2;
        hBoundary = fimplicit(f2, [min(features(:, 1)), max(features(:, 1)), ...
                                   min(features(:, 2)), max(features(:, 2))]);
        hBoundary.DisplayName = sprintf('Boundary between %d & %d', classes(i), classes(j));
    end
end

grid on;
hold off;
axis tight;
title('Linear Classification with Fisher Training Data');





