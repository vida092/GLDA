% Suponiendo que tu tabla se llama "T"
% T = table(col1, col2, ..., etiquetas) donde etiquetas contiene 'M' y 'B'
clc
clear
T = readtable("wdbc.csv");
%
T.Var2 = cellfun(@(x) double(ismember(x, 'B')), T{:, 2}); % Convierte cada celda y asigna valores numéricos

% Convertir la tabla a matriz
M = table2array(T);

% Convertir la tabla a matriz

% Mover la segunda columna (etiquetas) al final
M = [M(:, [1 3:end]), M(:, 2)]; % Mover la segunda columna al final
csvwrite("wbc_clean.csv",M)
