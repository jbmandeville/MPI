clear all; %close all;

v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);
s.Rate = 250e3;


addAnalogOutputChannel(s,d(1).ID, 0, 'Voltage');
addAnalogOutputChannel(s,d(1).ID, 1, 'Voltage');

pickupcoil = 0;

waveform(1) = 0; legendtext{1} = char(['ni-daq output']);
% waveform(end+1) = 1; legendtext{end+1} = char(['Techron input']);
%          waveform(end+1) = 2; legendtext{end+1} = char(['Techron sample']);
           waveform(end+1) = 3; legendtext{end+1} = char(['Pickup coil']); pickupcoil = 1;

for input_count = 2:numel(waveform)
addAnalogInputChannel(s,d(1).ID, waveform(input_count), 'Voltage');
end


%%%USER INPUT%%%%%%%%%%%%%%
squarewave = 0;   %switch
duration = .001;
drive_freq = 25e3;
amp = 0.1;  %Volts   %%current out of amplifier is roughly 20Xamp

if amp > 2
    ERRROR
end

%%%USER INPUT%%%%%%%%%%%%%%


%% NI-DAQ output
time = [0:1/s.Rate:duration];
blocksize = duration*s.Rate;

if squarewave == 1
    drive_freq = 1;
    output_data_temp = 1*(amp/2+amp/2*square(2*pi*drive_freq*(time-0.2), .5)).';
    
else
     output_data_temp = 1*amp*sin(2*pi*drive_freq*time).';
%      output_data_temp =1*amp*cos(2*pi*0*time).';
end

output_data = [output_data_temp, zeros(size(output_data_temp))];
%%

%% crop values for plots
if squarewave == 1
    %      crop_start = 1;
    %      crop_end = numel(time);
    crop_start = ceil(numel(time)*((0.1999/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
    crop_end = ceil(numel(time)*((0.2002/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
else
    crop_start = 1;
    crop_end = numel(time);
    crop_start = ceil(numel(time)*((1/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
    crop_end = ceil(numel(time)*((10/drive_freq)/duration));  %%number of time points for 10 periods of drive freq
end

if crop_end > duration*s.Rate
    crop_start = 1;
    crop_end = duration*s.Rate;
    disp('duration too short for crop params - plotting full waveform');
end
%%

figure(1);

% Hd = bandpass_butterworth_filter_25e3_v2;

btn = uicontrol('Style', 'pushbutton', 'String', 'stop',...
    'Position', [20 20 50 20],...
    'Callback', 'delete(gcbo)');
colors = {'b','r','g','m','k'};

input_count = 1;


while ishandle(btn)
    
    
    
    
    queueOutputData(s,output_data);
    [captured_data] = s.startForeground();
    
    
    %%plot time domain
    subplot(3,1,1);
    
    if pickupcoil == 0
        data = [20*output_data(:,1) 20*captured_data];
        plot(time, data);
        ylabel('Amps into solenoid')
        xlabel('time (s)');
        plotmax = 20*amp*1.5; plotmin = -20*amp*1.5;
        ylim([plotmin, plotmax])
        YTick =[plotmin,plotmin/2, 0, plotmax/2, plotmax];
        xlim([time(crop_start), time(crop_end)]);
        legend(legendtext)
    else
        data = [20*output_data(:,1) 20*captured_data(:,1:end-1)];
        data_pickupcoil = captured_data(:,end);
        [hAx,hLine1,hLine2] = plotyy(time, data, time,data_pickupcoil);
        
        ylabel(hAx(1),'Amps into solenoid');
        ylabel(hAx(2),'voltage across pickup coil');
        plotmax1 = 20*amp*1.5; plotmin1 = -20*amp*1.5;
        plotmax2 = 2*amp; plotmin2 = -2*amp;
        ylim(hAx(1),[plotmin1, plotmax1])
         ylim(hAx(2),[plotmin2, plotmax2])
        hAx(1).YTick =[plotmin1,plotmin1/2, 0, plotmax1/2, plotmax1];
         hAx(2).YTick =[plotmin2,plotmin2/2, 0, plotmax2/2, plotmax1];
        legend(legendtext)
        xlim(hAx(1), [time(crop_start), time(crop_end)]);
        xlim(hAx(2), [time(crop_start), time(crop_end)]);
    end
    
        if squarewave == 1
            ylim([20*amp*0.5, 20*amp*1.5])
        end
        
        
        title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
        
        
       %%
        
        %% frequency spectrum plot
       
        
        
   if pickupcoil == 0
        [f,mag] = daqdocfft(data,s.Rate,blocksize);
        subplot(3,1,2);
       plot(f,mag);
        
        ylim([-100, 60]);
        xlim([0, s.Rate/2]);
       
        I0 = find(f > drive_freq - 100 & f < drive_freq +100);
        log_amp0 = max(mag(I0,end));        
        I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
        log_amp3 = max(mag(I3,end));       
        ratio_db = log_amp3 - log_amp0;
        

            text(0,50, ['harmonic difference = ', num2str(ratio_db),' dB']);
 
        ylabel('Magnitude (dB)')
        xlabel('Frequency (Hz)')
        title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
        legend(legendtext)
   else
        [f,mag] = daqdocfft([data, data_pickupcoil],s.Rate,blocksize);
        
        subplot(3,1,2);
       plot(f,mag);
        
        ylim([-100, 60]);
        xlim([0, s.Rate/2]);
       
        I0 = find(f > drive_freq - 100 & f < drive_freq +100);
        log_amp0 = max(mag(I0,end));        
        I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
        log_amp3 = max(mag(I3,end));       
        ratio_db = log_amp3 - log_amp0;
        

            
            text(0,56, ['fundamental amp = ', num2str(log_amp0),' dB']);
            text(0,46, ['3rd harmonic amp = ', num2str(log_amp3),' dB']);
            text(0,36, ['harmonic difference = ', num2str(ratio_db),' dB']);
  
        ylabel('Magnitude (dB)')
        xlabel('Frequency (Hz)')
        title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
        legend(legendtext)
   end
        
   
   %%
    %% plot magnetic drive field
        
        muo = 4*pi*10^-7;
        N = 30;             %% 30 turns solenoid drive coil
        L = 6e-2;           %% length of solenoid drive coil = 6cm
        
        
        
       subplot(3,1,3)
       
        data = [20*output_data(:,1) 20*captured_data(:,1:end-1)];
        %plot(time, 1e-3*muo*(N/L)*data);
        %plot(1e-3*muo*(N/L)*data(9:13),captured_data(9:13));
        plot(1e-3*muo*(N/L)*data,captured_data,'.');

        xlabel('drive field inside solenoid [mT]');
        %plotmax1 = 20*amp*1.5; plotmin1 = -20*amp*1.5;
        plotmax1 = 100e-3; plotmin = -50e-3;
        %ylim([plotmin1, plotmax1])
        %YTick =[plotmin1,plotmin1/2, 0, plotmax1/2, plotmax1];
        %legend([legendtext])
        %xlim([time(crop_start), time(crop_end)]);
%     end
    
        if squarewave == 1
            ylim([20*amp*0.5, 20*amp*1.5])
        end
        
        
        title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
        
       

%         pause(.1);

    
%     subplot(2,1,1); hold off;
%     subplot(2,1,2); hold off;
%     
 
    pause(.2);
    
end





