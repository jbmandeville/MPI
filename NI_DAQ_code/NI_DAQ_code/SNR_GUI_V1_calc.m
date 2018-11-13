%%SNR calc
f3 = f3_time;

N1 = 20;
N2 =4;
sig_data = f3(end-N2:end);
sig_data = f3(47:51);
noise_data = f3(1:N1);
%  sig_data = f3(40:50);
% noise_data = f3(25:45);


% noise_data = f3(88:112);

away = mean(noise_data);
near = mean(sig_data);

S = abs(mean(sig_data)-mean(noise_data))

Noise = std(noise_data)

SNR = S/Noise