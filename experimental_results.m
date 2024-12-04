clc
clear
a =  readmatrix('GSLDA_ionospherec.csv');
b = readmatrix('ionospherec.csv');
c = readmatrix('GA-LDA_ ionospherec.csv');


db = calculateDunnIndex(b);
disp('Dunn index de la base original')
disp(db)
da = calculateDunnIndex(a);
disp('Dunn index de la base hecha por mi')
disp(da)
dc = calculateDunnIndex(c);
disp('Dunn index de la base del paper')
disp(dc)



db = calculateSDIndex(b,1);
disp('SDI index de la base original')
disp(db)
da = calculateSDIndex(a,1);
disp('SDI index de la base hecha por mi')
disp(da)
dc = calculateSDIndex(c,1);
disp('SDI index de la base del paper')
disp(dc)


