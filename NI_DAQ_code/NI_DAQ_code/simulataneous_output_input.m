 clear all; %close all;

v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);
 s.Rate = 250000;

addAnalogOutputChannel(s,d(1).ID, 0, 'Voltage');
addAnalogInputChannel(s,d(1).ID, 1, 'Voltage');

sim_sRate = 2.5e5;

duration = 1; %1 second acquisition
blocksize = duration*s.Rate;
time = [0:1/s.Rate:duration];
sim_blocksize = duration*sim_sRate;
sim_time = [0:1/sim_sRate:duration];




drive_freq = 300;
output_data = .1*sin(2*pi*drive_freq*time).';
%output_data = (0.5+0.5*square(2*pi*100*time, 50)).';
sim_output_data = sin(2*pi*drive_freq*sim_time).';


crop_10_periods = ceil(numel(time)*((50/drive_freq)/duration));  %%number of time points for 10 periods of drive freq


crop_start = ceil(numel(time)*((50/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
crop_end = ceil(numel(time)*((100/drive_freq)/duration));  %%number of time points for 10 periods of drive freq


sim_crop_10_periods = ceil(numel(sim_time)*((10/drive_freq)/duration));  %%number of time points for 10 periods of drive freq

% % sim
% figure(1);
% subplot(2,1,1);
% plot(time(1:sim_crop_10_periods),sim_output_data(1:sim_crop_10_periods));
% title(['Sim Data (duration = ',num2str(duration),'s)']);
% xlabel('time (s)');
% 
% sim_captured_data = sim_output_data;
% 
% [sim_f,sim_mag] = daqdocfft(sim_captured_data,sim_sRate,blocksize);
% subplot(2,1,2);
% plot(sim_f,sim_mag);
% ylim([-50, 150]);
% ylabel('Magnitude (dB)')
% xlabel('Frequency (Hz)')
% %%
% % 
Hd = bandpass_filter_75e3;
figure(1);
btn = uicontrol('Style', 'pushbutton', 'String', 'stop',...
        'Position', [20 20 50 20],...
        'Callback', 'delete(gcbo)');

while ishandle(btn)
    
    
queueOutputData(s,output_data) 

% subplot(3,1,1);
% plot(time(1:crop_10_periods),output_data(1:crop_10_periods));
% title(['Output Data Queued (duration = ',num2str(duration),'s)']);
% xlabel('time (s)');
 [captured_data,time] = s.startForeground();


 subplot(2,2,1);plot(time(1:crop_10_periods),captured_data(1:crop_10_periods));

ylabel('Voltage');
xlabel('time (s)');
title('Acquired Signal');

[f,mag] = daqdocfft(captured_data,s.Rate,blocksize);
subplot(2,2,3);
plot(f,mag);
ylim([-50, 150]);
ylabel('Magnitude (dB)')
xlabel('Frequency (Hz)')

% figure(2);
filtered_data = filter(Hd, captured_data);
subplot(2,2,2);
 plot(time(1:crop_10_periods),filtered_data(1:crop_10_periods));
% plot(time,filtered_data);
 title(['Bandpass filtered Data (duration = ',num2str(duration),'s)']);
 xlabel('time (s)');

[filtered_f,filtered_mag] = daqdocfft(filtered_data,s.Rate,blocksize);
subplot(2,2,4);
plot(filtered_f,filtered_mag);
ylim([-50, 150]);
ylabel('Magnitude (dB)')
xlabel('Frequency (Hz)')


 figure(2);

subplot(1,2,1);
 plot(time(1:crop_10_periods),filtered_data(1:crop_10_periods));
%plot(time,filtered_data);
 title(['Bandpass filtered Data (duration = ',num2str(duration),'s)']);
 xlabel('time (s)');

[filtered_f,filtered_mag] = daqdocfft(filtered_data,s.Rate,blocksize);
subplot(1,2,2);
plot(filtered_f,filtered_mag);
ylim([-50, 150]);
ylabel('Magnitude (dB)')
xlabel('Frequency (Hz)')



pause(.05);
end



