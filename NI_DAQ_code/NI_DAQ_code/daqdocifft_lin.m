function [f,mag, xifft] = daqdocifft_lin(xfftfull,Fs,blocksize)
%    [F,MAG]=DAQDOCFFT(X,FS,BLOCKSIZE) calculates the FFT of X
%    using sampling frequency FS and the SamplesPerTrigger
%    provided in BLOCKSIZE



% xfft = ifft(data)/numel(data)/2;
xifft = (numel(xfftfull)/2)*ifft(xfftfull);

mag =abs(xifft);
% mag = mag_temp(1:floor(blocksize/2));
% 
% 
% xfft_out = xfft(1:floor(blocksize/2));
% 
% 

% Avoid taking the log of 0.

f = (0:length(mag)-1)*Fs/blocksize;
f = f(:);