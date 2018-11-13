function [f,mag, xfft_out,xfft_full] = daqdocfft_lin(data,Fs,blocksize)
%    [F,MAG]=DAQDOCFFT(X,FS,BLOCKSIZE) calculates the FFT of X
%    using sampling frequency FS and the SamplesPerTrigger
%    provided in BLOCKSIZE

N_inputs = size(data,2);
for nn = 1:N_inputs
xfft(:,nn) = (fft(data(:,nn)))/(numel(data(:,nn))/2);
xfft_full = xfft;

mag_temp =abs(xfft(:,nn));
mag(:,nn) = mag_temp(1:floor(blocksize/2));

xfft_temp =(xfft(:,nn));
xfft_out(:,nn) = xfft_temp(1:floor(blocksize/2));

end

% Avoid taking the log of 0.

f = (0:length(mag)-1)*Fs/blocksize;
f = f(:);