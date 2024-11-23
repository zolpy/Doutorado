clear, clc

A = 400 //mm2
E = 200 //GPa

//Segmentos
AC=2 //m
DC=2 //m
CE=2//m
AE=2//m

//hipotenusa
a =sqrt(CE^2 +AE^2)
disp("Resultado de a:", a)
sen_teta = AE/a
disp("")
disp("sen_teta ", sen_teta, "rad" )
