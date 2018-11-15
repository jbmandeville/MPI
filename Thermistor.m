function Temp = Thermistor(V)
R = (28.32/V-5.63)*10^3;
A1 = 3.354016E-03; 
B1 = 2.569850E-04; 
C1 = 2.620131E-06; 
D1 = 6.383091E-08;
Rref = 10e3;
Temp = 1./(A1 + B1*log(R/Rref)+C1*(log(R/Rref)).^2 + D1*(log(R/Rref)).^3)-273.15;

