 clear all; %close all;

v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);
s.Rate = 833e3/2;
% sim_sRate = 2.5e5;




addAnalogOutputChannel(s,d(1).ID, 0, 'Voltage');
addAnalogOutputChannel(s,d(1).ID, 1, 'Voltage');
% addAnalogInputChannel(s,d(1).ID, 1, 'Voltage');
% addAnalogInputChannel(s,d(1).ID, 2, 'Voltage');
% addAnalogInputChannel(s,d(1).ID, 3, 'Voltage');

%%%USER INPUT%%%%%%%%%%%%%%
squarewave = 0;
duration = .1;
amp = .06;  %Volts
%%%USER INPUT%%%%%%%%%%%%%%

time = [0:1/s.Rate:duration];
blocksize = duration*s.Rate;
% sim_blocksize = duration*sim_sRate;
% sim_time = [0:1/sim_sRate:duration];

if squarewave == 1
    drive_freq = 1;
    output_data_temp = 1*(amp/2+amp/2*square(2*pi*drive_freq*(time-0.2), 1)).';
    
else
    drive_freq = 25e3;
    output_data_temp = 1*amp*sin(2*pi*drive_freq*time).';
    
end


output_data = [output_data_temp.^1, zeros(size(output_data_temp))];


sim_output_data = sin(2*pi*drive_freq*sim_time).';









%crop_10_periods = ceil(numel(time)*((50/drive_freq)/duration));  %%number of time points for 10 periods of drive freq



if squarewave == 1
%      crop_start = 1;
%      crop_end = numel(time);
    crop_start = ceil(numel(time)*((0.19/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
    crop_end = ceil(numel(time)*((0.22/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
else
         crop_start = 1;
     crop_end = numel(time);
    crop_start = ceil(numel(time)*((1/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
    crop_end = ceil(numel(time)*((10/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
end

sim_crop_10_periods = ceil(numel(sim_time)*((10/drive_freq)/duration));  %%number of time points for 10 periods of drive freq


Hd = bandpass_butterworth_filter_25e3_v2;
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

figure(1);
subplot(2,1,1);%plot(time(crop_start:crop_end),captured_data(crop_start:crop_end),:);
% plot(time(crop_start:crop_end),output_data(crop_start:crop_end),'k');
% hold on;
% plot(time(crop_start:crop_end),captured_data(crop_start:crop_end,1),'b');
% plot(time(crop_start:crop_end),captured_data(crop_start:crop_end,2),'r');

%  plot(time(crop_start:crop_end),[captured_data(crop_start:crop_end,:)]);
 captured_data = [captured_data, output_data];
if crop_end > numel(captured_data)
           subplot(2,1,1);plot(time(crop_start:end),20*captured_data(crop_start:end,:));
xlim([time(crop_start) time(end)]);
   
else
%     subplot(2,1,1);plot(time(crop_start:crop_end),20*captured_data(crop_start:crop_end,:));
 
    subplot(2,1,1);
 
    [hAx,hLine1,hLine2] = plotyy(time(crop_start:crop_end),20*captured_data(crop_start:crop_end,1:2), time(crop_start:crop_end),captured_data(crop_start:crop_end,3));
ylabel(hAx(1),'Amps into solenoid')
ylabel(hAx(2),'voltage across pickup coil')
ylim(hAx(1),[-20*amp*1.5, 20*amp*1.5])
ylim(hAx(2),[-1*amp*1.2, 1*amp*1.2])
hAx(1).YTick =[-20*amp*1.5,-10*amp*1.5, 0, 10*amp*1.5, 20*amp*1.5];
hAx(2).YTick =[-1*amp*1.2,-1*amp*1.2/2, 0, 1*amp*1.2/2, 1*amp*1.2];

xlim([time(crop_start) time(crop_end)]);


end%  plot(time(crop_start:crop_end),[output_data(crop_start:crop_end),captured_data(crop_start:crop_end,:)]);


if squarewave == 1
ylim([-20*amp*0.1, 20*amp*2])
else
ylim(hAx(1),[-20*amp*1.5, 20*amp*1.5])
ylim(hAx(2),[-1*amp*1.5, 1*amp*1.5])

end
%axis([time(crop_start) time(crop_end) 1.1*min(min(captured_data)) 1.1*max(max(captured_data))]);
%  legend('NI-DAQ output', 'diff amp output', 'techron sample');
  legend('diff amp output', 'techron sample','pickup coil');
% legend('NI-DAQ output',  'techron sample')
% ylabel('Amps into coil');
xlabel('time (s)');

title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);

[f,mag] = daqdocfft(captured_data,s.Rate,blocksize);
[f,output_mag] = daqdocfft(output_data,s.Rate,blocksize);
subplot(2,1,2);

% plot(f,output_mag,'k');
% hold on;
% plot(f,mag(:,1),'b');
% plot(f,mag(:,2),'r');
% hold off;

%    plot(f,[output_mag, mag]);
plot(f,mag);
ylim([-80, 80]);
xlim([0, s.Rate/2]);
  legend('diff amp output', 'techron sample','pickup coil');

% legend('techron sample');
ylabel('Magnitude (dBmV)')
xlabel('Frequency (Hz)')
title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
%  hold off;

% % figure(2);
% filtered_data = filter(Hd, captured_data);
% subplot(2,2,3);
%  plot(time(crop_start:crop_end),filtered_data(crop_start:crop_end));
% % plot(time,filtered_data);
%  title(['Bandpass filtered Data (duration = ',num2str(duration),'s)']);
%  xlabel('time (s)');
% 
% [filtered_f,filtered_mag] = daqdocfft(filtered_data,s.Rate,blocksize);
% subplot(2,2,4);
% plot(filtered_f,filtered_mag);
% ylim([-50, 150]);
% ylabel('Magnitude (dBmV)')
% xlabel('Frequency (Hz)')


mean(captured_data)

pause(.5);
end



