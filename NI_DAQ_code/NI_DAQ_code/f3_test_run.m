function [f3_amp, f3_phase, data_raw] = f3_test_run(X,periodmult,pausetime, averages, drive_amp)

d  = daq.getDevices;
devID = d(1).ID;
handles.s = daq.createSession('ni');
handles.s.Rate = 500e3;
handles.ao1 = handles.s.addAnalogOutputChannel(devID, 1, 'Voltage');
handles.ao1.TerminalConfig = 'SingleEnded';
handles.ch1 = handles.s.addAnalogInputChannel(devID, 0, 'Voltage');
handles.ch1.TerminalConfig = 'Differential';

handles.ch1.Range = [-0.1,0.1];

handles.drive_freq =25e3;
handles.periodmult = periodmult;
handles.pw = handles.periodmult/handles.drive_freq;

handles.time = [0:1/handles.s.Rate:handles.pw];
handles.amp = drive_amp;
amp = handles.amp;
pw = handles.pw;
time = handles.time;
drive_freq = handles.drive_freq;
figure(1);
%%end copied from run/stop button callback

% if handles.stop_button_status == 10
for aa = 1:averages
    %%copied from run/stop button callback
    phase_offset =X(2);
    amp_offset =X(1);

    cancellation_term = amp_offset*sin(2*pi*75e3*handles.time+phase_offset).';
    output_data_temp = 1*handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).' +cancellation_term;
    handles.output_data =[output_data_temp];
    queueOutputData(handles.s, handles.output_data);
    [captured_data] = handles.s.startForeground();
    handles.data_raw(:,aa) = captured_data(2:end);



handles.data = mean(handles.data_raw,2);  %%averaged data



    amplitude = (max(handles.data(end/2:end,1))-min(handles.data(end/2:end,1)))/2;
    subplot(2,1,1)
    plot(time(2:end), handles.data(:,1));
    xlabel('time (s)');
    h2 = text(.8*max(time),0, ['amplitude = ', num2str(amplitude)]);
    set(h2,'fontsize',22);
    title({['Acquired signal']; ['(duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']});
%     axes(handles.data_plot_freq);
subplot(2,1,2)
    datacursormode on;
    data = handles.data;
    data_crop = data(end/2+1:end,:);  blocksize_crop = numel(data_crop(:,1));
    [f,mag,xfft] = daqdocfft_lin(data_crop,handles.s.Rate,blocksize_crop);
    [f,maglog] = daqdocfft(data_crop,handles.s.Rate,blocksize_crop);
    assignin('base','xfft', xfft);
    plot(f,maglog(:,1));
    xlim([0, handles.s.Rate/2]);ylim([-120, 10]);
    
    
    I0 = find(f > drive_freq - 100 & f < drive_freq +100);
    lin_amp0 = max(mag(I0));
    log_amp0 = max(maglog(I0));
    I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
    lin_amp3 = sum(mag(I3));
    log_amp3 = max(maglog(I3));
  
    
    ylabel('Magnitude (dB)')
    xlabel('Frequency (Hz)')
    text(1e4,0, ['amp offset = ', num2str(amp_offset)]);
    text(1e4,-10, ['phase offset = ', num2str(phase_offset)]);
    assignin('base','I3', I3);
    
   

    f3_amp = 1000*abs(xfft(I3));
    f3_phase = angle(xfft(I3));
    
    text(1.3e5,0, ['f0 amp gradiometer = ', num2str(lin_amp0)]);
    text(1.3e5,-15, ['f3 amp gradiometer = ', num2str(f3_amp),'mV']);
    text(1.3e5,-30, ['f3 phase gradiometer = ', num2str(f3_phase),'rad']);
    

    
   text(1e3,-140, ['run num = ', num2str(aa)]);

    
       pause(pausetime-.3);   %%%nidaq take ~300ms to play next pulse


 end


data_raw = handles.data_raw;


% handles.cal_offset_button_status = set(hObject,0);

