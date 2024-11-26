function NewData = PolinomialExpansion(data, Grade)
    Variables = data;
    [n,p] = size(Variables);
    A=sortrows(allVL1(p,Grade,'<='),'descend');
    [~,is]=sort(sum(A,2));
    A=A(is,:);
    [new_p, ~] = size(A);
    NewVariables = zeros(n,new_p);

    for j = 2:new_p
        %indexVariables = A(j,:); 
        indexVariables = find(A(j,:) ~= 0);
        grades = A(j, indexVariables);
        ColumnVariables = data(:,indexVariables);
        s = sum(grades);
        if s==1 
            NewVariable = ColumnVariables;
        else
            NewVariable = ProductOfColumnVariables(ColumnVariables, grades);
        end
        NewVariables(:,j) = NewVariable;
    end
    NewVariables = array2table(NewVariables(:,2:end));
    
    % For variable names
    names = {};
    for j = 2:new_p
        %indexVariables = A(j,:); 
        indexVariables = find(A(j,:) ~= 0);
        grades = A(j, indexVariables);
        num_variables = length(indexVariables);
        variablesX = repmat(string('X'),1,num_variables);
        for k=1:num_variables
            if k==1
                if grades(k) > 1
                    txt = strcat(string(variablesX(k)), string(indexVariables(k)), "^", string(grades(k)));
                else
                    txt = strcat(string(variablesX(k)), string(indexVariables(k)));
                end
            else
                if grades(k) > 1
                    txt = strcat(txt, " ", string(variablesX(k)), string(indexVariables(k)), "^", string(grades(k)));
                else 
                    txt = strcat(txt, " ", string(variablesX(k)), string(indexVariables(k)));
                end
            end
            names{j-1}= txt;
        end
    end
    names = string(names);
    allVars = 1:width(NewVariables);
    allVars = append("Var",string(allVars));
    NewData = renamevars(NewVariables,allVars,names);
end