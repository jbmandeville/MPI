clear all; %close all;

v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);
s.Rate = 500e3;

numave = 1;
addAnalogOutputChannel(s,d(1).ID, 0, 'Voltage');
addAnalogOutputChannel(s,d(1).ID, 1, 'Voltage');

pickupcoil = 0;

waveform(1) = 0; legendtext{1} = char(['ni-daq output']);
waveform(end+1) = 0; legendtext{end+1} = char(['gradiometer']);  
waveform(end+1) = 4; legendtext{end+1} = char(['current sense resistor']);  
                 
ch1 = addAnalogInputChannel(s,d(1).ID, 0, 'Voltage');
ch1.Range = [-10,10];
ch1.TerminalConfig = 'SingleEnded';

ch2 = addAnalogInputChannel(s,d(1).ID, 4, 'Voltage');
ch2.Range = [-1,1];
ch2.TerminalConfig = 'SingleEnded';

%%%USER INPUT%%%%%%%%%%%%%%
amp = .0001;
numaveset = 1;
pausetime = .001;


%% NI-DAQ output
    drive_freq =25e3;
    duration = 500/drive_freq;    
    blocksize = duration*s.Rate;
    time = [0:1/s.Rate:duration];
    cancellation_term = 0.0+ 0.0*amp*sin(2*pi*75e3*time+(19*pi/20)).';
    output_data_temp = 1*amp*sin(2*pi*drive_freq*time).' + cancellation_term;

output_data = [output_data_temp, zeros(size(output_data_temp))];

figure(1);

btn = uicontrol('Style', 'pushbutton', 'String', 'stop',...
    'Position', [20 20 50 20],...
    'Callback', 'delete(gcbo)');


btn2 = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
    'Position', [500 20 50 20],...
    'Callback', @clear_axis);

runcount = 0;




while ishandle(btn)
    
    queueOutputData(s,output_data);
    [captured_data] = s.startForeground();
    data = captured_data(2:end,:);
%     
    subplot(3,1,1);
   
    amplitude = (max(data(end/4:end,1))-min(data(end/2:end,1)))/2;
    plot(time(2:end), data(:,1));
    xlabel('time (s)');
    
    text(.8*max(time),0, ['amplitude = ', num2str(amplitude)]);
    title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
    
%     subplot(3,2,2);
%    
%     amplitude = (max(data(end/2:end,2))-min(data(end/2:end,2)))/2;
%     plot(time(2:end), data(:,2));
%     xlabel('time (s)');
%     
%     text(.8*max(time),0, ['amplitude = ', num2str(amplitude)]);
%     title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
%     %%%
    data_crop = data(end/2+1:end,:);  blocksize_crop = numel(data_crop(:,1));
%     [f,mag] = daqdocfft_lin(data(end/2+1:end,:),s.Rate,blocksize/2);
%     [f,maglog] = daqdocfft(data(end/2+1:end,:),s.Rate,blocksize/2);
%     

  [f,mag] = daqdocfft_lin(data_crop,s.Rate,blocksize_crop);
  [f,maglog] = daqdocfft(data_crop,s.Rate,blocksize_crop);
    
    subplot(3,1,2);
    plot(f,maglog(:,1));
    xlim([0, s.Rate/2]);
    

    
    I0 = find(f > drive_freq - 100 & f < drive_freq +100);
    lin_amp0 = max(mag(I0,end-1));
    log_amp0 = max(maglog(I0,end-1));
    I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
    lin_amp3 = max(mag(I3,end-1));
    log_amp3 = max(maglog(I3,end-1));
   diffamp = lin_amp3 - lin_amp0;
    logdiffamp = log_amp3 - log_amp0;
    
    I0b = find(f > drive_freq - 100 & f < drive_freq +100);
    lin_amp0b = max(mag(I0b,end));
    log_amp0b = max(maglog(I0b,end));
    I3b = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
    lin_amp3b = max(mag(I3b,end));
    log_amp3b = max(maglog(I3b,end));
    diffampb = lin_amp3b - lin_amp0b;
    logdiffampb = log_amp3b - log_amp0b;
    
    
        
   
 
    ylabel('Magnitude (dB)')
    xlabel('Frequency (Hz)')
    title({['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V,'],[' num ave = ',num2str(numave),')']});%', preamp gain = ',num2str(preamp_gain),')']});
%     legend(legendtext)

    
    %%linear plot
%     ylim([0, 150e-3]);
    Ylim = get(gca,'ylim');
    Ymax = Ylim(2);
%     text(0,.95*Ymax, ['f0 amp gradiometer = ', num2str(lin_amp0)]);
%     text(0,.85*Ymax, ['f3 amp gradiometer = ', num2str(1000*lin_amp3),'mV']);  
%     text(0,.75*Ymax, ['diff gradiometer= ', num2str(logdiffamp),'db']);
% 
%     text(1.5e5,.95*Ymax, ['f0 amp Rcs = ', num2str(lin_amp0b)]);
%     text(1.5e5,.85*Ymax, ['f2 amp Rcs = ', num2str(1000*lin_amp3b),'mV']);  
%     text(1.5e5,.75*Ymax, ['diff Rcs = ', num2str(logdiffampb),'db']);
     
ylim([-120, 10]);
text(0,0, ['f0 amp gradiometer = ', num2str(lin_amp0)]);
    text(0,-10, ['f3 amp gradiometer = ', num2str(1000*lin_amp3),'mV']);  
    text(0,-20, ['diff gradiometer= ', num2str(logdiffamp),'db']);

    text(1.5e5,0, ['f0 amp Rcs = ', num2str(lin_amp0b)]);
    text(1.5e5,-10, ['f3 amp Rcs = ', num2str(1000*lin_amp3b),'mV']);  
    text(1.5e5,-20, ['diff Rcs = ', num2str(logdiffampb),'db']);

%     if ishandle(btn2) == 0
%         runcount = 0;
%         gradiometer_f3_save = [];
%     end
    
    runcount = runcount+1;
    gradiometer_f3_save(runcount) = 1000*lin_amp3;

    subplot(3,1,3);
    plot([1:runcount], gradiometer_f3_save(1:runcount));
    

   pause(pausetime);
    
end



