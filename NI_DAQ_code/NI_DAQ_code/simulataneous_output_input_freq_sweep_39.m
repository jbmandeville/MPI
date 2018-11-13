 clear all; %close all;

v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);
 s.Rate = 250000;

addAnalogOutputChannel(s,d(1).ID, 0, 'Voltage');
addAnalogInputChannel(s,d(1).ID, 2, 'Voltage');

sim_sRate = 2.5e5;
amp = 0.1;
duration = 1.5; %1 second acquisition
blocksize = duration*s.Rate;
time = [0:1/s.Rate:duration].';
sim_blocksize = duration*sim_sRate;
sim_time = [0:1/sim_sRate:duration];




drive_freq = 25e3;
output_data = amp*sin(2*pi*drive_freq*time).';
%output_data = (0.5+0.5*square(2*pi*100*time, 50)).';
% sim_output_data = sin(2*pi*drive_freq*sim_time).';


crop_10_periods = ceil(numel(time)*((50/drive_freq)/duration));  %%number of time points for 10 periods of drive freq


crop_start = ceil(numel(time)*((50/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
crop_start = 1;
crop_end = ceil(numel(time)*((10/drive_freq)/duration));  %%number of time points for 10 periods of drive freq


% sim_crop_10_periods = ceil(numel(sim_time)*((10/drive_freq)/duration));  %%number of time points for 10 periods of drive freq

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
Hd = bandpass_butterworth_filter_25e3_v2;
figure(1);
btn = uicontrol('Style', 'pushbutton', 'String', 'stop',...
    'Position', [20 20 50 20],...
    'Callback', 'delete(gcbo)');

% drive_freq_vector = logspace(1,5,100);
freq_space = 500;
drive_freq_vector = (1:freq_space:125e3);
%drive_freq_vector = [25e3,50e3];
freq_response = zeros(numel(time),numel(drive_freq_vector));


for fcount = 1:numel(drive_freq_vector)
  if ishandle(btn) == 1
    tic;
    
    
    drive_freq = drive_freq_vector(fcount);
    
    output_data = amp*sin(2*pi*drive_freq*time);
    % sim_output_data = sin(2*pi*drive_freq*sim_time).';
    % crop_start = ceil(numel(time)*((50/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
    % crop_end = ceil(numel(time)*((100/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
%     crop_start = 1;
%     crop_end = ceil(numel(time)/10);%/ceil(numel(time)*((10/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
%     
    crop_start = 1;
    crop_end = ceil(numel(time)*((10/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
    
    
    queueOutputData(s,output_data)
    
    % subplot(3,1,1);
    % plot(time(1:crop_10_periods),output_data(1:crop_10_periods));
    % title(['Output Data Queued (duration = ',num2str(duration),'s)']);
    % xlabel('time (s)');
    [captured_data,time] = s.startForeground();
    
    
    %  subplot(2,2,1);plot(time(1:crop_10_periods),captured_data(1:crop_10_periods));
   if crop_end > numel(captured_data)
           subplot(2,2,1);plot(time(crop_start:end),captured_data(crop_start:end));
   else
    subplot(2,2,1);plot(time(crop_start:crop_end),captured_data(crop_start:crop_end));
   end
    ylim([-1.2*amp, 1.2*amp]);
    ylabel('Voltage');
    xlabel('time (s)');
   title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);

    
    [f,mag] = daqdocfft(captured_data,s.Rate,blocksize);
    subplot(2,2,2);
    plot(f,mag);
    ylim([-50, 100]);
    ylabel('Magnitude (dBmV)')
    xlabel('Frequency (Hz)')
    
    
     subplot(2,2,3); 
    rms_response(fcount) = sqrt(mean(captured_data.^2));
    loglog((drive_freq_vector(1):freq_space:drive_freq), rms_response);
    xlim([drive_freq_vector(1),drive_freq_vector(end)]);
%     ylim([10e-3,max(rms_response)*1.1]);
    
    
    
    

%     
%     
%   
%     plot(time(crop_start:crop_end),filtered_data(crop_start:crop_end));
%     % plot(time,filtered_data);
%     ylim([-1, 1]);
%     title(['Bandpass filtered Data (duration = ',num2str(duration),'s)']);
%     xlabel('time (s)');
%     
%     [filtered_f,filtered_mag] = daqdocfft(filtered_data,s.Rate,blocksize);
%     subplot(2,2,4);
%     plot(filtered_f,filtered_mag);
%     ylim([-50, 1500]);
%     ylabel('Magnitude (dBmV)')
%     xlabel('Frequency (Hz)')
    
    title(['drive freq = ', num2str(drive_freq)]);
    
    
    freq_response(:,fcount) = captured_data;
    
    if ishandle(btn) == 0 
        fcount = numel(drive_freq_vector)+1
    end
    
        pause(.05);
    telapsed = toc
    disp(['time remaining = ', num2str(telapsed*(numel(drive_freq_vector)-fcount))]);

  end
  end


 
 
% figure(2);
hold on; loglog(drive_freq_vector, rms_response/(amp*sqrt(2)/2),'b', 'linewidth', 2);
%  hold on;   loglog((drive_freq_vector(1):freq_space:drive_freq), rms_response);

%     
% xlabel('drive freq (Hz');
% ylabel('voltage gain');
% title('THS-4131 anti-aliasing frequency response');
% 
%       xlim([drive_freq_vector(1),drive_freq_vector(end)]);
%     ylim([10e-3,max(rms_response)*1.1]);
%     
