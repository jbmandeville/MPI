function f = myfun(X)

d  = daq.getDevices;
devID = d(1).ID;
handles.s = daq.createSession('ni');
handles.s.Rate = 500e3;
handles.ao1 = handles.s.addAnalogOutputChannel(devID, 1, 'Voltage');
handles.ao1.TerminalConfig = 'SingleEnded';
handles.ch1 = handles.s.addAnalogInputChannel(devID, 0, 'Voltage');
handles.ch1.TerminalConfig = 'Differential';
handles.ch2 = handles.s.addAnalogInputChannel(devID, 4, 'Voltage');
handles.ch2.TerminalConfig = 'SingleEnded';

handles.numaveset = 1;
pausetime =  1;
handles.drive_freq =25e3;
handles.periodmult = 300;
handles.drive_freq = 25e3;
handles.pw = handles.periodmult/handles.drive_freq;

handles.time = [0:1/handles.s.Rate:handles.pw];
handles.amp = 0.5;
amp = handles.amp;
pw = handles.pw;
time = handles.time;
drive_freq = handles.drive_freq;
figure(1);
%%end copied from run/stop button callback

% if handles.stop_button_status == 10
for calnum = 1
    handles.runcount = calnum;
    %%copied from run/stop button callback
    phase_offset =X(2);
    amp_offset =X(1);

    cancellation_term = 0.0+ amp_offset*handles.amp*sin(2*pi*75e3*handles.time+phase_offset).';
    output_data_temp = 1*handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).' +cancellation_term;
    handles.output_data =[output_data_temp];
    queueOutputData(handles.s, handles.output_data);
    [captured_data] = handles.s.startForeground();
    handles.data = captured_data(2:end,:);
    handles.output = handles.data;
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
    xlim([0, handles.s.Rate/2]);
    I0 = find(f > drive_freq - 100 & f < drive_freq +100);
    lin_amp0 = max(mag(I0,end-1));
    log_amp0 = max(maglog(I0,end-1));
    I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
    lin_amp3 = sum(mag(I3,end-1));
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
    text(2.6e5,-20, ['amp offset = ', num2str(amp_offset)]);
    text(2.6e5,-60, ['phase offset = ', num2str(phase_offset)]);
    assignin('base','I3b', I3b);
    Ylim = get(gca,'ylim');
    Ymax = Ylim(2);
    ylim([-120, 10]);
    text(1.3e5,0, ['f0 amp gradiometer = ', num2str(lin_amp0)]);
    text(1.3e5,-10, ['f3 amp gradiometer = ', num2str(1000*lin_amp3),'mV']);
%    handles.runcount = handles.runcount+1;
    handles.gradiometer_f3_save(handles.runcount) = 1000*lin_amp3;
    handles.gradiometer_f0_save(handles.runcount) = 1000*lin_amp0;
%     axes(handles.data_plot_time)
%     plot([1:handles.runcount], handles.gradiometer_f3_save(1:handles.runcount));
%     xlabel('run number'); title('f3 level');
%     axes(handles.data_plot_time_f0)
%     plot([1:handles.runcount], handles.gradiometer_f0_save(1:handles.runcount));
%     xlabel('run number');  title('f0 level');
%     assignin('base','I3', I3);
%     assignin('base','f3_time',handles.gradiometer_f3_save);
%     assignin('base','data_t',handles.data(:,1));
%     assignin('base','data_f',maglog(:,1));
%     assignin('base','time',time(2:end));
%     assignin('base','freq', f);
    pause(pausetime-.3);   %%%nidaq take ~300ms to play next pulse
    %%end copied from run/stop button callback
    
    data_cal(:,calnum) = data_crop(:,1);
    assignin('base','data_cal', data_cal);
    
    
    
   
end
% end


f =  1000*lin_amp3;


% handles.cal_offset_button_status = set(hObject,0);

