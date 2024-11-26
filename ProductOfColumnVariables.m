function NewVariable = ProductOfColumnVariables(ColumnVariables, grades)
    grades_length = length(grades);
    num_columns = sum(grades);
    columnsV = []; 
    for i = 1:grades_length
        columnsV = [columnsV repmat(ColumnVariables(:,i), 1, grades(i))];
    end

    ColumnVariables = columnsV;
    clear columnsV
    [~,num_variables] = size(ColumnVariables);
    for k = 2:num_variables
        first_column = ColumnVariables(:,1);
        k_column = ColumnVariables(:,k);
        first_column = first_column .* k_column;
    end
    NewVariable =  first_column;
end