%%%THS 4131 filter

C1 = 3.9e-9;
n = 2;
C2 = n*C1;


R2 = 330;
R3 = 560;
m = R3/R2;
R1 = 330;
R = R2;
C = C1;

C3 = 100e-12;
R4 = .1;
Rt = 1e6;

K = R2/R1;

FSF = 1;

fc = 1/(2*pi*sqrt(2*R2*R3*C1*C2))


Q = sqrt(2*R2*R2*C1*C2)/(R3*C1+R2*C1+K*R3*C1)

fc2 = 1/(2*pi*R*C*sqrt(2*m*n))
Q2 = sqrt(2*m*n)/(1+m*(1+K))


f = (1:1:1e6);

Hd = (K./(-(f./(FSF*fc)).^2 + (1/Q).*((1i*f)./(FSF*fc))+1)).*((Rt./(2.*R4+Rt))./(1+ (1i*2*pi.*f*R4*Rt*C3)./(2*R4+Rt)));

hold on; loglog(f, abs(Hd),'-m','linewidth', 2);