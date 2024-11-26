clc
clear
%%% https://www.openintro.org/data/index.php?data=golub %%%

D = readtable("golub.csv");
D(:, 1:5) = [];

% Supongamos que la columna de etiquetas es la primera columna de la tabla D
% Aseguramos que estamos trabajando con celdas
if iscell(D{:, 1})
    etiquetas = D{:, 1}; % Extraemos la columna como un cell array
else
    error('La primera columna no es un cell array, verifica el contenido de la tabla.');
end

% Creamos el mapeo de etiquetas a números
mapaEtiquetas = containers.Map({'allB', 'aml', 'allT'}, [1, 2, 3]);

% Convertimos las etiquetas a números
numeros = zeros(size(etiquetas)); % Inicializamos el vector numérico
for i = 1:length(etiquetas)
    % Verificamos que cada elemento sea una cadena válida
    if ischar(etiquetas{i})
        numeros(i) = mapaEtiquetas(etiquetas{i}); % Convertimos etiqueta a número
    else
        error('Elemento no válido en la columna de etiquetas. Verifica los datos.');
    end
end

% % Reemplazamos la columna original con los números
% D{:, 1} = numeros;

% Ahora puedes convertir la tabla a una matriz
matriz = table2array(D(:,2:end));
matriz = [matriz numeros];
csvwrite("golub_cleaned.csv", matriz);


