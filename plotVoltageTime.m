function plotVoltageTime(handles)
%%%gradiometer /preamp voltage time domain plot
show    = strcmp(get(handles.panel_currentData,'visible'),'on');
enabled = get(handles.radioButton_acquireEachPulse,'Value') == 1.0;
if ( show && enabled )
    time = handles.time;
    nRun = handles.runcount;  % alias nRun
    assignin('base','time',time(2:end));
    drive_freq = handles.drive_freq;
    amplitude = (max(handles.data(ceil(end/2):end,1))-min(handles.data(ceil(end/2):end,1)))/2;
    lin_amp0p3 = handles.gradiometer_f0_save_mV(nRun) + handles.gradiometer_f3_save_amp_mV(nRun);
    axes(handles.plot_voltage_time);
    plot(time(1:end), handles.data(:,1));
    xlabel('time (s)');
    h1 = text(0,-.5*min(handles.data), ['amp =', num2str(1000*amplitude),' mV']); %unit change Erica 2-7-2018
    set(h1,'fontsize',20,'Color','blue');
    h2 = text(0,1*min(handles.data), ['f0+f3 =', num2str(lin_amp0p3),' mV']); %unit change Erica 2-7-2018; factor of 1000 included already
    set(h2,'fontsize',40,'Color','magenta');
    title({'Acquired signal'; ['(duration = ',num2str(handles.amp),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(handles.amp),'V)']});
end
