function [f,mag] = daqdocfft(data,Fs,blocksize)
%    [F,MAG]=DAQDOCFFT(X,FS,BLOCKSIZE) calculates the FFT of X
%    using sampling frequency FS and the SamplesPerTrigger
%    provided in BLOCKSIZE

N_inputs = size(data,2);
for nn = 1:N_inputs
xfft(:,nn) = abs(fft(data(:,nn)))/(numel(data(:,nn))/2);

index = find(xfft(:,nn) == 0);
xfft(index,nn) = 1e-17;

mag_temp = 20*log10(xfft(:,nn));
mag(:,nn) = mag_temp(1:floor(blocksize/2));




end

% Avoid taking the log of 0.

f = (0:length(mag)-1)*Fs/blocksize;
f = f(:);