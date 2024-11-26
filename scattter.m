
data = readmatrix("image16.csv");

x = data(:, 1); 
y = data(:, 5); 
labels = data(:, end); 


unique_labels = unique(labels);
colors = lines(length(unique_labels));

figure;
hold on;
grid on;

for i = 1:length(unique_labels)
    idx = labels == unique_labels(i);
    scatter(x(idx), y(idx), 36, colors(i, :), 'filled');
end

xlabel('X');
ylabel('Y');
title('2D Scatter Plot by Labels');

legend(arrayfun(@num2str, unique_labels, 'UniformOutput', false));

hold off;

