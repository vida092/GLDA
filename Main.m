% Canonical Discriminant Analysis

% 
% close all

Data = readtable('synthetic_lda_data.csv');

data = table2array(Data(:,1:end-1));
labels = categorical(table2array(Data(:,end)));

% Expansión polinomial
if 0
    Grade = 2;
    data = PolinomialExpansion(data, Grade);
    data = table2array(data);
end

[eigenvectors, eigenvalues,proyecciones] = My_CDA(data,labels);

%[eigenvectors,eigenvalues,proyecciones]=With_PCA(data,labels);

% Linear Discriminant Classification
predictors=proyecciones(:,1:2); %proyecciones(:,1:2) data
MdlLinear = fitcdiscr(predictors,labels);
out = predict(MdlLinear,predictors);
figure
confMat = confusionmat(labels,out);
confMat = confMat./sum(confMat,2);
display('Accuracy: ')
mean(diag(confMat))*100
veesto = mean(diag(confMat))*100;
confusionchart(labels,out);
title('Confusion Matrix')
