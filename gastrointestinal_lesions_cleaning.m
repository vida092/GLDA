D =readmatrix("data.txt");
D = D.';

labels1 = D(:,1);
labels2 = D(:,2);

D_textural = D(:, 3:425);
D_textural1 = [D_textural labels1];
D_textural2 = [D_textural labels2];
% scatterByLabel(D_textural,[1,25,5]);
% csvwrite("gastrointestinal_textural_1.csv", D_textural1)
% csvwrite("gastrointestinal_textural_2.csv", D_textural2)


D_color_features = D(:, 426: 681);
D_color_features1 = [D_color_features labels1];
D_color_features2 = [D_color_features labels2];

% scatterByLabel(D_textural1,[1,25,5]);
% 
% csvwrite("gastrointestinal_color_1.csv", D_textural1)
% csvwrite("gastrointestinal_color_2.csv", D_textural2)

D_3dshape = D(:,682:end);
D_3dshape_1 = [D_3dshape labels1];
D_3dshape_2 = [D_3dshape labels2];
scatterByLabel(D_3dshape_1,[1,4,5]);





