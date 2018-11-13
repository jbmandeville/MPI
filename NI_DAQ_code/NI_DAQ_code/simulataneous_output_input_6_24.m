clear all; %close all;


preamp_gain = 0;

v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);
s.Rate = 250e3;
addAnalogOutputChannel(s,d(1).ID, 0, 'Voltage');
addAnalogOutputChannel(s,d(1).ID, 1, 'Voltage');

pickupcoil = 0;

waveform(1) = 0; legendtext{1} = char(['ni-daq output']);   plot_scale(1) = 1;
   waveform(end+1) = 0;   plot_scale(end+1) = 1;
 %       wavefoPreamp output']); plot_scale(end+1) = 1; 
       waveform(end+1) = 4;   plot_scale(end+1) = 1;
%    waveform(end+1) = 4; legendtext{end+1} = char(['current sense']); pickupcoil = 0;

         
         
for input_count = 2:numel(waveform)
addAnalogInputChannel(s,d(1).ID, waveform(input_count), 'Voltage');
end


%%%USER INPUT%%%%%%%%%%%%%%
squarewave = 0;   %switch

amp =.1;  %Volts   %%current 1out of amplifier is roughly 20Xamp
numave = 1;
pausetime = .1;

% if amp > 2.9
%     ERROR
% end

%%%USER INPUT%%%%%%%%%%%%%%


%% NI-DAQ output

if squarewave == 1
    duration = .5;
    time = [0:1/s.Rate:duration];
    blocksize = duration*s.Rate;    
    drive_freq = 1;
    output_data_temp = amp/2+amp/2*square((time-duration/2), .05).';
    
else  
    drive_freq =25e3;
    

     duration = 1000/drive_freq;

    blocksize = duration*s.Rate; 
%     time = linspace(0,duration,blocksize);
    time = [0:1/s.Rate:duration];
    output_data_temp = 1*amp*sin(2*pi*drive_freq*time).';% + 1*amp*sin(2*pi*75e3*time).';
end

% output_data_all = [output_data_temp, zeros(size(output_data_temp))];
output_data = [output_data_temp, zeros(size(output_data_temp))];

%%

%% crop values for plots
if squarewave == 1
    crop_start = .246*s.Rate+1;
    crop_end = .26*s.Rate;
else
    crop_start = 0*s.Rate+1;
    crop_end = duration*s.Rate;
end

if crop_end > duration*s.Rate
    crop_start = 1;
    crop_end = duration*s.Rate;
    disp('duration too short for crop params - plotting full waveform');
end
%%

figure(1);

btn = uicontrol('Style', 'pushbutton', 'String', 'stop',...
    'Position', [20 20 50 20],...
    'Callback', 'delete(gcbo)');

input_count = 1;
cyclecount = 1;

while ishandle(btn)
    
     
    for aa = 1:numave
     queueOutputData(s,output_data);
     [single_data] = s.startForeground();
     single_data_all(aa,:,:)=single_data;
     pause(pausetime);
    end
    
    captured_data = squeeze(mean(single_data_all,1)).';

%%plot time domain
    subplot(2,1,1);
    data(:,1) = [plot_scale(1)*output_data(2:end,1)];
        plot(time(2:end), data(:,1));
        xlabel('time (s)');
        hold on;
        
for pp = 1:size(captured_data,2)
        data(:,pp+1) = [plot_scale(pp+1)*captured_data(2:end,pp)];
        plot(time(2:end), data(:,pp+1));
        xlabel('time (s)');   
end

% legend(legendtext);
% hold off;        
%     subplot(2,2,2);
%     data(:,1) = [plot_scale(1)*output_data(2:end,1)];
%         plot(time(end/10+1:end), data([end/10+1:end],1));
%         xlabel('time (s)');
%         hold on;
%         
% for pp = 1:size(captured_data,2)
%         data(:,pp+1) = [plot_scale(pp+1)*captured_data(2:end,pp)];
%         plot(time(end/10+1:end), data([end/10+1:end],pp+1));
%         xlabel('time (s)');   
% % end

legend(legendtext);
hold off;        
%title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
title({['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V,'],[' num ave = ',num2str(numave),', preamp gain = ',num2str(preamp_gain),')']});      
        
        %%
        
        
        %% frequency spectrum plot
       
        
%        if pickup_coil ==1 

[f,mag] = daqdocfft_lin(data(end/2+1:end,:),s.Rate,blocksize/2);
[f,maglog] = daqdocfft(data(end/2+1:end,:),s.Rate,blocksize/2);
%[f,mag] = daqdocfft(data,s.Rate,blocksize);

subplot(2,1,2);
plot(f,(maglog));
            
            ylim([-120, 60]);
            xlim([0, s.Rate/2]);
            
            I0 = find(f > drive_freq - 100 & f < drive_freq +100);
            log_amp0 = max(mag(I0,end));
            I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
            log_amp3 = max(mag(I3,end));
            ratio_db = log_amp3 - log_amp0;
            
            amp3_save(cyclecount) = log_amp3; 
            
   Ymax0 = get(gca,'ylim');   
%       Ymax0 = max(maglog); 
      Ymax = Ymax0(2);      

            
            ylabel('Magnitude (dB)')
            xlabel('Frequency (Hz)')
            title({['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V,'],[' num ave = ',num2str(numave),', preamp gain = ',num2str(preamp_gain),')']});
            legend(legendtext)
%         else
%             [f,mag] = daqdocfft([data, data_pickupcoil],s.Rate,blocksize);
%             
%             subplot(2,1,2);
%             plot(f,mag);
%             
%             ylim([-100, 60]);
%             xlim([0, s.Rate/2]);
%             
%             I0 = find(f > drive_freq - 100 & f < drive_freq +100);
%             log_amp0 = max(mag(I0,end));
%             I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
%             log_amp3 = max(mag(I3,end));
%             ratio_db = log_amp3 - log_amp0;
%             
%             text(0,56, ['3rd harmonic amp = ', num2str(log_amp3),' dB']);
%             %             text(0,56, ['fundamental amp = ', num2str(log_amp0),' dB']);
%             %              text(0,46, ['3rd harmonic amp = ', num2str(log_amp3),' dB']);
%             %             text(0,36, ['harmonic difference = ', num2str(ratio_db),' dB']);
%             %
%             ylabel('Magnitude (dB)')
%             xlabel('Frequency (Hz)')
%             title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
%             legend(legendtext)
%             
%             
%             %%calc linear harmonic values
%             [f,mag] = fftlin([data, data_pickupcoil],s.Rate,blocksize);            
%             
%             I0 = find(f > drive_freq - 100 & f < drive_freq +100);
%             log_amp0 = max(mag(I0,end));
%             I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
%             log_amp3 = max(mag(I3,end));
%             ratio_db = log_amp3 - log_amp0;
%             
%             
%  
         text(0,Ymax*.5, ['3rd harmonic amp = ', num2str(log_amp3)]);
         
         text(0,Ymax, ['fundamental amp = ', num2str(log_amp0)]);
%            
%             
           text(0,Ymax*.1, ['harmonic difference = ', num2str(ratio_db),' ']);        
 text(0,Ymax*.01, ['3rd harm change = ', num2str(100*(max(amp3_save)-min(amp3_save))),' ']);              
%             
%             
%         end
        
       
        
 
%         pause(.1);

    
%     subplot(2,1,1); hold off;
%     subplot(2,1,2); hold off;
%     
 
     pause(pausetime);
    cyclecount = cyclecount+1;
end



