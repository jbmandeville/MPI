 clear all; %close all;
clf(1,'reset');
v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);
s.Rate = 250e3;





pickupcoil = 0;
output_monitor = 0;

addAnalogOutputChannel(s,d(1).ID, 0, 'Voltage');
addAnalogOutputChannel(s,d(1).ID, 1, 'Voltage');

legendtext{1} = char(['ni-daq output']);
%  legendtext{end+1} = char(['diff amp output']); addAnalogInputChannel(s,d(1).ID, 1, 'Voltage');
%   legendtext{end+1} = char(['techron sample']);addAnalogInputChannel(s,d(1).ID, 2, 'Voltage');
    legendtext{end+1} = char(['pickup coil']); addAnalogInputChannel(s,d(1).ID, 3, 'Voltage');  pickupcoil =1;

%    legendtext{end+1} = char(['output voltage']);addAnalogInputChannel(s,d(1).ID, 0, 'Voltage');   output_monitor = 1;





%%%USER INPUT%%%%%%%%%%%%%%
squarewave = 0;
duration = .1;
amp = 1;  %Volts
current_corr = amp*20

if amp > 3
    ERRROR
end
%%%USER INPUT%%%%%%%%%%%%%%

time = [0:1/s.Rate:duration];
blocksize = duration*s.Rate;

if squarewave == 1
    drive_freq = 1;
    output_data_temp = 1*(amp/2+amp/2*square(2*pi*drive_freq*(time-0.2), .5)).';
    
else
    drive_freq = 25e3;
    output_data_temp = 1*amp*sin(2*pi*drive_freq*time).';
    
end


 output_data = [output_data_temp.^1, zeros(size(output_data_temp))];

%crop_10_periods = ceil(numel(time)*((50/drive_freq)/duration));  %%number of time points for 10 periods of drive freq



if squarewave == 1
    %      crop_start = 1;
    %      crop_end = numel(time);
    crop_start = ceil(numel(time)*((0.1999/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
    crop_end = ceil(numel(time)*((0.2002/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
else
%     crop_start = 1;
%     crop_end = numel(time);
    crop_start = ceil(numel(time)*((1/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
    crop_end = ceil(numel(time)*((10/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
end



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
%  [captured_data,time] = s.startForeground();
 [captured_data] = s.startForeground();

figure(1);
subplot(2,1,1);%plot(time(crop_start:crop_end),captured_data(crop_start:crop_end),:);
% plot(time(crop_start:crop_end),output_data(crop_start:crop_end),'k');
% hold on;
% plot(time(crop_start:crop_end),captured_data(crop_start:crop_end,1),'b');
% plot(time(crop_start:crop_end),captured_data(crop_start:crop_end,2),'r');

%  plot(time(crop_start:crop_end),[captured_data(crop_start:crop_end,:)]);
captured_data = [output_data(:,1), captured_data];


if crop_end > numel(captured_data)
    subplot(2,1,1);plot(time(crop_start:end),20*captured_data(crop_start:end,:));
    xlim([time(crop_start) time(end)]);
    
else
    
    if pickupcoil == 1
        subplot(2,1,1);
        [hAx,hLine1,hLine2] = plotyy(time(crop_start:crop_end),20*captured_data(crop_start:crop_end,1:(end-1)), time(crop_start:crop_end),captured_data(crop_start:crop_end,end));
        ylabel(hAx(1),'Amps into solenoid')
        ylabel(hAx(2),'voltage across pickup coil')
        ylim(hAx(1),[-20*amp*1.5, 20*amp*1.5])
        ylim(hAx(2),[-1*amp*4, 1*amp*4])
        hAx(1).YTick =[-20*amp*1.5,-10*amp*1.5, 0, 10*amp*1.5, 20*amp*1.5];
        hAx(2).YTick =[-1*amp*4,-2*amp, 0, 2*amp, 1*amp*4];
        
        
        
    elseif output_monitor == 1
        output_voltage = captured_data(:,end);
        output_current = output_voltage/4;
        captured_data = captured_data(:,1:end-1);
        
        subplot(2,1,1);
        [hAx,hLine1,hLine2] = plotyy(time(crop_start:crop_end),20*captured_data(crop_start:crop_end,:), time(crop_start:crop_end),output_current(crop_start:crop_end,end));
        ylabel(hAx(1),'(A)')
        ylabel(hAx(2),'measured current (A)')
        ylim(hAx(1),[-20*amp*1.5, 20*amp*1.5])
        ylim(hAx(2),[-20*amp*1.5, 20*amp*1.5])
        %         ylim(hAx(2),[-1*amp*4, 1*amp*4])
        hAx(1).YTick =[-20*amp*1.5,-10*amp*1.5, 0, 10*amp*1.5, 20*amp*1.5];
        hAx(2).YTick =[-20*amp*1.5,-10*amp*1.5, 0, 10*amp*1.5, 20*amp*1.5];
        
        %         hAx(2).YTick =[-1*amp*4,-2*amp, 0, 2*amp, 1*amp*4];
    else
        
        subplot(2,1,1);
        plot(time(crop_start:crop_end),20*captured_data(crop_start:crop_end,:),'linewidth', 2);
        ylabel('Amps into solenoid')
        ylim([-20*amp*1.5, 20*amp*1.5])
        YTick =[-20*amp*1.5,-10*amp*1.5, 0, 10*amp*1.5, 20*amp*1.5];
    end
    
    xlim([time(crop_start) time(crop_end)]);
end%  plot(time(crop_start:crop_end),[output_data(crop_start:crop_end),captured_data(crop_start:crop_end,:)]);


if squarewave == 1
ylim([20*amp*0.5, 20*amp*1.5])
else
% ylim(hAx(1),[-20*amp*1.5, 20*amp*1.5])
% ylim(hAx(2),[-1*amp*1.5, 1*amp*1.5])

end
%axis([time(crop_start) time(crop_end) 1.1*min(min(captured_data)) 1.1*max(max(captured_data))]);
%  legend('NI-DAQ output', 'diff amp output', 'techron sample');
%legend('ni-daq output', 'diff amp output', 'techron sample','pickup coil');
% legend('NI-DAQ output',  'techron sample')
legend(legendtext)
% ylabel('Amps into coil');
xlabel('time (s)');

text(time(crop_start),20*amp*1.5-1, ['peak-peak = ', num2str(20*(max(captured_data(:,end)-min(captured_data(:,end))))),' A']);  
title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);

[f,mag] = daqdocfft(20*captured_data,s.Rate,blocksize);
subplot(2,1,2);

% plot(f,output_mag,'k');
% hold on;
% plot(f,mag(:,1),'b');
% plot(f,mag(:,2),'r');
% hold off;

%    plot(f,[output_mag, mag]);
plot(f,mag);
if output_monitor == 1
    [f,outputcurrent_mag] = daqdocfft(output_current,s.Rate,blocksize);
     hold on; plot(f,outputcurrent_mag);
     hold off;
end
ylim([-100, 60]);
xlim([0, s.Rate/2]);
  legend(legendtext);

  
I0 = find(f > drive_freq - 100 & f < drive_freq +100);
log_amp0 = max(mag(I0,end));

I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
log_amp3 = max(mag(I3,end));

ratio_db = log_amp3 - log_amp0;

text(0,50, ['harmonic difference = ', num2str(ratio_db),' dB']);  
% legend('techron sample');
ylabel('Magnitude (dBV)')
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



