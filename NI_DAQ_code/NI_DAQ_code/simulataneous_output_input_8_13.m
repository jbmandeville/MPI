clear all; %close all;




preamp_gain = 0;
v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);
s.Rate = 2e6;
addAnalogOutputChannel(s,d(1).ID, 0, 'Voltage');
addAnalogOutputChannel(s,d(1).ID, 1, 'Voltage');

pickupcoil = 0;
sub_baseline = 0;
baseline_ave = 1;

waveform(1) = 0; legendtext{1} = char(['ni-daq output']);   plot_scale(1) = .1; 
  waveform(end+1) = 0; legendtext{end+1} = char(['preamp']);  plot_scale(end+1) = 1;  termconfig = 'SingleEnded';
waveform(end+1) = 4; legendtext{end+1} = char(['preamp']);  plot_scale(end+1) = 1;  termconfig = 'SingleEnded';
%   waveform(end+1) = 2;  legendtext{end+1} = char([' ']);  plot_scale(end+1) = 1;  ch2.TerminalConfig = 'Differential'
%    waveform(end+1) = 4; legendtext{end+1} = char(['current sense']); pickupcoil = 0;

for input_count = 2:numel(waveform)
    ch2 = addAnalogInputChannel(s,d(1).ID, waveform(input_count), 'Voltage');
end

ch2.Range = [-.5,.5];
ch2.TerminalConfig = termconfig;

% ch2.TerminalConfig = 'SingleEnded'

%%%USER INPUT%%%%%%%%%%%%%%
squarewave = 0;   %switch
amp = .2; %/sqrt(10);  %Volts   %%current 1out of amplifier is roughly 20Xamp
numaveset = 1;
pausetime = .1;


%% NI-DAQ output
if squarewave == 1
    duration = .5;
    time = [0:1/s.Rate:duration];
    blocksize = duration*s.Rate;
    drive_freq = 1;
    output_data_temp = amp/2+amp/2*square((time-duration/2), .05).';
    
else
    drive_freq =25e3;
    duration = 500/drive_freq;    
    blocksize = duration*s.Rate;
    time = [0:1/s.Rate:duration];
    cancellation_term = .0*amp*sin(2*pi*75e3*time-(pi/2+5*pi/10)).';

    output_data_temp = 1*amp*sin(2*pi*drive_freq*time).' + cancellation_term;
end

output_data = [output_data_temp, zeros(size(output_data_temp))];

%%

figure(1);
btn = uicontrol('Style', 'pushbutton', 'String', 'stop',...
    'Position', [20 20 50 20],...
    'Callback', 'delete(gcbo)');

input_count = 1;
cyclecount = 1;

while ishandle(btn)
    
    
    if cyclecount == 1
        numave = baseline_ave;
    else
        numave = numaveset;
    end
    for aa = 1:numave
        queueOutputData(s,output_data);
        [single_data] = s.startForeground();
        single_data_all(aa,:,:)=single_data;
        pause(pausetime);
    end
    
    captured_data = squeeze(mean(single_data_all,1)).';
    
    %%plot time domain
    subplot(3,1,1);
%     data(:,1) = [plot_scale(1)*output_data(2:end,1)];
%     plot(time(2:end), data(:,1));
%     xlabel('time (s)');
%     hold on;
%     
 if cyclecount == 1
     data_run1 = squeeze(mean(single_data_all([ceil(end/2):end],2:end),1)).';
     [f,mag,xfft2] = daqdocfft_lin(data_run1(end/2+1:end,:),s.Rate,blocksize/2);
      run1_harm_sig = data_run1.'-abs(xfft2(251))*cos(2*pi*25e3*time(2:end)+angle(xfft2(251)));
%%captured_data(2:end,1);
 end
    
    for pp = 1:size(captured_data,2)
        if cyclecount~= 1 && sub_baseline == 1
        data(:,pp+1) = [plot_scale(pp+1)*captured_data(2:end,pp)] - data_run1;
        else
        data(:,pp+1) = [plot_scale(pp+1)*captured_data(2:end,pp)];
        
        end
        
        
        
        amplitude = (max(data(end/2:end,pp+1))-min(data(end/2:end,pp+1)))/2;
        plot(time(2:end), data(:,pp+1),'-r');
        xlabel('time (s)');
        
%         hold on; plot(time(2:end), run1_harm_sig);
        
        text(.8*max(time),0, ['amplitude = ', num2str(amplitude)]);
    end
    
    legend(legendtext(2));
    hold off;
    %title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
    title({['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V,'],[' num ave = ',num2str(numave),')']});%', preamp gain = ',num2str(preamp_gain),')']});
    
    %%
    
    
    %% frequency spectrum plot  
    [f,mag] = daqdocfft_lin(data(end/2+1:end,:),s.Rate,blocksize/2);
   
   [f,magdatarun1] = daqdocfft_lin(run1_harm_sig(:,end/2+1:end).',s.Rate,blocksize/2);

    
    [f,maglog] = daqdocfft(data(end/2+1:end,:),s.Rate,blocksize/2);
    
    subplot(3,1,2);
    plot(f,(mag(:,1)),'-b'); hold on;
   plot(f,(mag(:,2)),'-r');   hold off;
    

    xlim([0, s.Rate/2]);
    
    I0 = find(f > drive_freq - 100 & f < drive_freq +100);
    lin_amp0 = max(mag(I0,end));
    log_amp0 = max(maglog(I0,end));
    I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
    lin_amp3 = max(mag(I3,end));
    log_amp3 = max(maglog(I3,end));
    
    I2 = find(f > drive_freq*2 - 100 & f < drive_freq*2 +100);
    lin_amp2 = max(mag(I2,end));
    log_amp2 = max(maglog(I2,end));
    I4 = find(f > drive_freq*4 - 100 & f < drive_freq*4 +100);
    lin_amp4 = max(mag(I4,end));
    log_amp4 = max(maglog(I4,end));
    
    
    
    diffamp = lin_amp3 - lin_amp0;
    logdiffamp = log_amp3 - log_amp0;
    if cyclecount ~= 1 
    amp3_save(cyclecount-1) = lin_amp3;
    else 
        amp3_save = 0;
    end
        
   
 
    ylabel('Magnitude (dB)')
    xlabel('Frequency (Hz)')
    title({['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V,'],[' num ave = ',num2str(numave),')']});%', preamp gain = ',num2str(preamp_gain),')']});
    legend(legendtext)

    
    %%linear plot
    ylim([0, 80e-3]);
    Ylim = get(gca,'ylim');
    Ymax = Ylim(2);
    text(0,.95*Ymax, ['fundamental amp = ', num2str(lin_amp0)]);
    text(0,.85*Ymax, ['3rd harmonic amp = ', num2str(1000*lin_amp3),'mV']);  
    text(0,.75*Ymax, ['harmonic difference = ', num2str(logdiffamp),'db']);
    if cyclecount ~= 1 
    text(0,.65*Ymax, ['1000x delta 3rd harm = ', num2str(1000*(max(amp3_save)-min(amp3_save))),' ']);
    end
   text(5.5e4,55, ['2nd harmonic amp = ', num2str(lin_amp2)]);
    text(5.5e4,45, ['4th harmonic amp = ', num2str(lin_amp4)]);
  


    figure(1);
    subplot(3,1,3); 
    if cyclecount ~=1
    plot([1:cyclecount-1], amp3_save);
    end
    
%     %log plot
%      text(0,55, ['fundamental amp = ', num2str(lin_amp0)]);
%     text(0,45, ['3rd harmonic amp = ', num2str(1000*lin_amp3),'mV']);  
%     text(0,35, ['harmonic difference = ', num2str(logdiffamp),'db']);
%     if cyclecount ~= 1 
%     text(0,25, ['1000x delta 3rd harm = ', num2str(1000*(max(amp3_save)-min(amp3_save))),' ']);
%     end
%    text(5.5e4,55, ['2nd harmonic amp = ', num2str(lin_amp2)]);
%     text(5.5e4,45, ['4th harmonic amp = ', num2str(lin_amp4)]);
%          ylim([-150, 60]);
    pause(pausetime);
    cyclecount = cyclecount+1;
end



