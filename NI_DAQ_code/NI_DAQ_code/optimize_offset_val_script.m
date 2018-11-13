%%%  optimize offst values


X = data_crop;


s.Rate = 500e3;
periodmult = 300; drive_freq = 25e3;
pw = periodmult/drive_freq;
time = [0:1/s.Rate:pw/2];
time = time(1:end-1);





% [Y,I] = max(xfft); 
% I = I3; I2 = numel(X) - I+2;
% 
% temp = zeros(size(xfftfull));
% xfftfullfilt = temp;
% xfftfullfilt(I) = xfftfull(I);
% xfftfullfilt(I2) = xfftfull(I2);
% 
% [f,mag,Xifft] = daqdocifft_lin(xfftfullfilt,500e3,numel(xfftfull));


[f,mag,xfft,xfftfull] = daqdocfft_lin(X(:,1),500e3,numel(X));
X75_grad = xfft(I3);
phase75 = angle(X75_grad)
mag75 = abs(X75_grad)
% mag75 = 1;
grad75 = mag75*cos(2*pi*75e3*time+phase75);


[f,mag,xfft,xfftfull] = daqdocfft_lin(X(:,2),500e3,numel(X));
X75_cs = xfft(I3);
% phase75 = angle(X75_cs)
% mag75 = abs(X75_cs)
% mag75 = 1;
cs75 = mag75*cos(2*pi*75e3*time+phase75);

% figure;  hold on; plot(time, grad75); plot(time, cs75);xlim([5.9e-3, 6e-3]);


% hold on; subplot(1,2,2);plot(time, X); hold on; plot(time, (Xifft));  xlim([5.9e-3, 6e-3]);


