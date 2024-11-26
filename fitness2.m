function fitness2 = fitness2(matrix,D,labels)
    features = D(:,1:(end-1));
    predictores = features * matrix;
    %predictors=proyecciones(:,1:2); %proyecciones(:,1:2) data
    MdlLinear = fitcdiscr(predictores,labels);
    out = predict(MdlLinear,predictores);
    confMat = confusionmat(labels,out);
    confMat = confMat./sum(confMat,2);
    fitness2 = mean(diag(confMat))*100;

end