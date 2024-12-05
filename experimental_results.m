clc
clear
a =  readmatrix('GSLDA_iris.csv');
b = readmatrix('iris.csv');
c = readmatrix('GA-LDA_ iris.csv');

disp('-------------dun index----------------')
db = calculateDunnIndex(b);
disp('Dunn index de la base original')
disp(db)
da = calculateDunnIndex(a);
disp('Dunn index de la base hecha por mi')
disp(da)
dc = calculateDunnIndex(c);
disp('Dunn index de la base del paper')
disp(dc)

disp('-------------sdi index----------------')

db = calculateSDIndex(b,1);
disp('SDI index de la base original')
disp(db)
da = calculateSDIndex(a,1);
disp('SDI index de la base hecha por mi')
disp(da)
dc = calculateSDIndex(c,1);
disp('SDI index de la base del paper')
disp(dc)

disp('----------informacion mutua-------------------')

db = calcularInformacionMutua(b);
disp('información mutua base original')
disp(db)
da = calcularInformacionMutua(a);
disp('informacion mutua base hecha por mi')
disp(da)
dc = calcularInformacionMutua(c);
disp('informacion mutua base del paper')
disp(dc)

