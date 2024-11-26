clc
clear

rgbImage = imread('input16.png');
binaryMask = imread('target16.png');


% imagen RGB a CieLab
% labImage = rgb2lab(rgbImage);

% Obtener las dimensiones de la imagen
[rows, cols, ~] = size(rgbImage);

outputMatrix = zeros(rows * cols, 4);

% Contador para la salida
counter = 1;

% Recorrer cada píxel de la imagen
for i = 1:rows
    for j = 1:cols
        % Obtener los valores RGB del píxel actual
        R = rgbImage(i, j, 1);
        G = rgbImage(i, j, 2);
        B = rgbImage(i, j, 3);

        % Obtener los valores CieLab del píxel actual
        % L = labImage(i, j, 1);
        % a = labImage(i, j, 2);
        % b = labImage(i, j, 3);

        % Obtener el valor de la etiqueta binaria del píxel actual
        binaryLabel = binaryMask(i, j);

        % Almacenar los valores en la matriz de salida
        outputMatrix(counter, :) = [R, G, B, binaryLabel];
        counter = counter + 1;
    end
end

% Mostrar los primeros 10 elementos de la matriz de salida para verificar
disp(outputMatrix(1:10, :));


csvFileName = 'image16rgb.csv';
writematrix(outputMatrix, csvFileName);

