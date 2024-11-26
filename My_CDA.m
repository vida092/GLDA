function [eigenvectors, eigenvalues, projections] = My_CDA(data,labels)
    % data: Matrix of observations (rows) by features (cols)
    % labels: Vector type "categorical" with the classes

    % GENERAL DATA DISPERSION  
    global_mean = mean(data)';  % Global mean
    [rows,cols] = size(data);   % Data size

    txt = strcat("There are n = ", string(rows), " observations in dimension p = ", string(cols));
    disp(txt)

    % DATA DISPERSION BY CLASS
    classes = unique(labels);
    n_classes = length(classes);
    means_matrix = zeros(n_classes,cols);          % Matrix of means
    W = zeros(cols,cols);                          % Within groups matrix 
    for i = 1:n_classes
        indexes = find(labels == classes(i));
        Matrix_Subclass_i = data(indexes,:);
        [classSize,~] = size(Matrix_Subclass_i);
        means_matrix(i,:) = mean(Matrix_Subclass_i);
        classesCovariance = cov(Matrix_Subclass_i);
        group_matrix_weighted = classSize * classesCovariance;
        W = W + group_matrix_weighted;
    end
    txt = strcat("There are g = ", string(n_classes), " classes.");
    disp(txt)

    %----------------------------------------------------------------------
    % BETWEEN-GROUPS DISPERSION
    X_bar = means_matrix - global_mean';
    A = X_bar' * X_bar;  % Between groups matrix

    % WITHIN-GROUPS DISPERSION
    S = (1/(rows - n_classes)) * W ; % Pooled within matrix

    %----------------------------------------------------------------------
    % CANONICAL AXES CONSTRUCTION
    [V,L] = eig(A,S);
    eigenvalues = diag(L)';
    [eigenvalues, indexes] = sort(eigenvalues, 'descend');
    eigenvectors = V(:,indexes);

    % CANONICAL AXES PROJECTIONS
    projections = data*eigenvectors;

    std_projections = std(projections);
    txt = "The standard desviation for canonical axis is presented in the following vector: ";
    disp(txt)
    disp(std_projections)
    m = min(cols,(n_classes-1));
    txt = strcat("The actual number of canonical axes is m = ", string(m), ".");
    disp(txt)
    percent =  sum(eigenvalues(1:m))/sum(eigenvalues) * 100;
    txt = strcat("The percentage of geometric variability explained by the first m = ", string(m), " canonical coordinates is: ", string(percent),"%.");
    disp(txt)
    %----------------------------------------------------------------------
    % Graphic if m is equal to 1, 2 or 3.
   
    symbols = {'x', 'o', 'square', 'd', '<','>','+','pentagram','*','v'};
    for i=1:n_classes
        class_indexes = find(labels == classes(i));
        scatter(projections(class_indexes,1),projections(class_indexes,2),symbols{i})
        hold on
    end
    %legend(classes,'Location','eastoutside','Orientation','vertical')
    xlabel('Canonical axis Y1');
    ylabel('Canonical axis Y2');
    grid on
    title('Data projection with CDA in dimension 2')
    percent =  sum(eigenvalues(1:2))/sum(eigenvalues) * 100;
    txt = ['Geometric variability explained = ' int2str(percent) '%'];
    subtitle(txt)

    if m == 1
        symbols = {'x', 'o', 'square', 'd', '<','>'};
        yposition = [0.5, 1, 1.5, 2, 2.5, 3];
        colors = {'b','r','y','m','g','c'};
        % stacked
        ax = axes(figure, 'NextPlot', 'add', 'YColor', 'none');
        for i = 1:n_classes
            class_indexes = find(labels == classes(i));
            N = length(class_indexes);
            scatter(ax, projections(class_indexes,1), zeros(N,1), symbols{i}, colors{i})
            hold on
        end
        legend(classes,'Location','eastoutside','Orientation','vertical')
        xlabel('Canonical axis Y1');
        
        for i = 1:n_classes
            class_indexes = find(labels == classes(i));
            N = length(class_indexes);
            scatter(ax, projections(class_indexes,1), repmat(yposition(i),1,N), symbols{i},colors{i})
            hold on
        end
        ylim(ax, [0 yposition(n_classes)]);
        xlim(ax, [min(projections(:,1)) max(projections(:,1))]);
        legend(classes,'Location','eastoutside','Orientation','vertical')
        xlabel('Canonical axis Y1');
        grid on
        pbaspect([2 1 1])
        title('Data projection with CDA in dimension 1')
        percent =  sum(eigenvalues(1))/sum(eigenvalues) * 100;
        txt = ['Geometric variability explained = ' int2str(percent) '%'];
        subtitle(txt)
    end
end