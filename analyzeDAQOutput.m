function handles = analyzeDAQOutput(handles)
global myDeviceSettings
nRun = handles.runcount;  % alias nRun
data(:,1) = handles.data(:,1);  %data(:,2) = data_currentsense;
assignin('base','data_full', data);
data_crop = data(ceil(end/4)+1:end,:);
%data_crop = data(ceil(end/4)+1:end-ceil(end/4)+1,:);
blocksize_crop = numel(data_crop(:,1));
assignin('base','data_crop', data_crop);

[f,mag,xfft] = daqdocfft_lin(data_crop,myDeviceSettings.rateContinuous,blocksize_crop); assignin('base','xfft', xfft);

drive_freq = handles.drive_freq;
correction = evalin('base','correction');

deltaF3Wide   = myDeviceSettings.deltaF3Wide;
deltaF3Narrow = myDeviceSettings.deltaF3Narrow;
deltaF = myDeviceSettings.deltaF1;
I0 = find(f > drive_freq - deltaF & f < drive_freq +deltaF);
lin_amp0 = max(mag(I0,1));
I3 = find(f > drive_freq*3 - deltaF3Wide & f < drive_freq*3 +deltaF3Wide); assignin('base','I3', I3);
%     lin_amp3 = max(mag(I3,1));
%I3
%xfft(I3,1)
lin_complex3 = xfft(I3,1);
lin_amp3 = abs(lin_complex3);
lin_phase3 = phase(lin_complex3);
lin_real3 = real(lin_complex3);
lin_imag3 = imag(lin_complex3);
lin_complex3_corr = lin_complex3 - correction;
lin_amp3_corr = abs(lin_complex3_corr);
lin_phase3_corr = phase(lin_complex3_corr);
I5 = find(f > drive_freq*5 - deltaF & f < drive_freq*5 +deltaF);
lin_amp5 = max(mag(I5,1));
I4 = find(f > drive_freq*4 - deltaF & f < drive_freq*4 +deltaF);
lin_amp4 = max(mag(I4,1));
I2 = find(f > drive_freq*2 - deltaF & f < drive_freq*2 +deltaF); assignin('base','I3', I3);
lin_amp2 = max(mag(I2,1));

% I3exact = find(f > drive_freq*3 - 50 & f < drive_freq*3 +50);
I3exact = find(f > drive_freq*3 - deltaF3Narrow & f < drive_freq*3 + deltaF3Narrow);

phase_31 = (angle(xfft(I3exact,1))); %phase_32  = angle(xfft(I3,2));

[f,maglog] = daqdocfft(data_crop,myDeviceSettings.rateContinuous,blocksize_crop);

%%%gradiometer /preamp voltage freq dom. plot
axes(handles.plot_freq_time); datacursormode on;
plot(f,maglog(:,1));
hold on; plot(f(I3),maglog(I3),'rs','markerfacecolor',[0 0 0]);
hold on; plot(f(I0),maglog(I0),'rs','markerfacecolor',[0 0 0]);
xlabel('frequency (Hz)');
text(2e3,0, ['DC offset = ', num2str(1000*max(mag(1,1))),'mV']); % unit change to mV - EM 2/6/2018
text(2e3,-10, ['f0 amp gradiometer = ', num2str(1000*lin_amp0),'mV']); % unit change to mV - EM 2/6/2018
text(2e3,-20, ['f3 amp gradiometer = ', num2str(1000*lin_amp3),'mV',', \phi = ', num2str(lin_phase3),' rad']);
text(5e4,-30, ['(real = ', num2str(1000*lin_real3),'mV',', imag = ', num2str(1000*lin_imag3),' mV)']);
text(2e3,-40, ['f5 amp gradiometer = ', num2str(1000*lin_amp5),'mV']);
xlim([0, myDeviceSettings.rateContinuous/2]);ylim([-120, 10]); hold off;

amp_offset   = get(handles.slider1_amp,'Value');
phase_offset = get(handles.slider2_phase,'Value');
text(10e4,-60, ['amp = ', num2str(amp_offset)]);
text(10e4,-80, ['phase = ', num2str(phase_offset)]);
ylim([-120, 10]);

if nRun == 0
    handles.timetrack = [];
end

handles.runcount = handles.runcount + 1;  nRun = handles.runcount;
set(handles.runcount_string, 'String', num2str(nRun));
set(handles.runcount_string, 'Value', nRun);

handles.gradiometer_f3_save_complex(nRun) = lin_complex3;
handles.gradiometer_f3_save_amp_mV(nRun) = 1000*lin_amp3;
handles.gradiometer_f3_save_phase(nRun) = lin_phase3;
handles.gradiometer_f3_save_real_mV(nRun) = 1000*lin_real3;
handles.gradiometer_f3_save_imag_mV(nRun) = 1000*lin_imag3;

handles.gradiometer_f3_save_complex_corrected(nRun) = lin_complex3_corr;
handles.gradiometer_f3_save_amp_corrected_mV(nRun) = 1000*lin_amp3_corr;
handles.gradiometer_f3_save_phase_corrected(nRun) = lin_phase3_corr;

handles.gradiometer_f0_save_mV(nRun) = 1000*lin_amp0;
handles.gradiometer_f5_save_mV(nRun) = 1000*lin_amp5;
handles.gradiometer_f4_save_mV(nRun) = 1000*lin_amp4;
handles.gradiometer_f2_save_mV(nRun) = 1000*lin_amp2;
handles.gradiometer_f3phase_save(nRun) = phase_31;
%     handles.datacrop_save = data_crop;

if nRun > 1
    if length(handles.datacrop_save(:,1)) ~= length(data_crop);
        %             handles.datacrop_save = [];
        display('Error saving datacrop_save -- Size of data_crop has changed');
        display('Error saving datacrop_save -- Size of data_crop has changed');
    end
end
handles.datacrop_save(:,nRun) = data_crop.';

plotVoltageTime(handles);

handles.saved_noise_on = evalin('base','saved_noise_on');

xfft_save(:,:,nRun) = xfft;
assignin('base','xfft_save', xfft_save);
assignin('base','data_f',maglog(:,1));
assignin('base','freq', f);
