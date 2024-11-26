function [eigenvectors,eigenvalues,proyecciones]=With_PCA(data,labels)
% data: Matriz de observaciones (rows) por atributos (cols)
% labes: Vector tipo categorical que contiene las clases

    [rows,cols]=size(data);
    
    clases=unique(labels);
    n_clases=length(clases);
    
    % Estandarizacion
%     for j=1:cols
%         for i=1:n_clases
%             ind=find(labels == clases(i));
%             varianzas(j,i)=var(data(ind,j));
%         end
%         data(:,j)=data(:,j)-repmat(mean(data(:,j)),rows,1);
%         data(:,j)=data(:,j)./repmat(mean(varianzas(j,:)),rows,1);
%     end 
    
    [eigenvectors,components,eigenvalues,tsquared,explainedv,mu] = pca(data);

    proyecciones=data*eigenvectors;

    for i=1:n_clases
        ind=find(labels == clases(i));
        scatter(proyecciones(ind,1),proyecciones(ind,2),'filled')
        hold on
    end
    grid on

end
