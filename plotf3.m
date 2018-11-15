function plotf3(handles)
%%%% PLOTS F3 DATA OVER TIME (MAGNITUDE, REAL AND IMAGINARY PARTS)
nRun = handles.runcount;  % alias nRun
correction = evalin('base','correction');
correction_on = evalin('base','correction_on');
correction_run_count = evalin('base','correction_run_count');

axes(handles.plot_f3_time)
%     plotyy([1:nRun], (handles.gradiometer_f3_save(1:nRun)), [1:nRun], (handles.gradiometer_f3_save_phase(1:nRun)));
plot(1:nRun, (handles.gradiometer_f3_save_amp_mV(1:nRun)),'b');
hold on, plot(1:nRun, (handles.gradiometer_f3_save_real_mV(1:nRun)),'r');
hold on, plot(1:nRun, (handles.gradiometer_f3_save_imag_mV(1:nRun)),'g');
if correction_on == 1
    hold on; plot(correction_run_count-20+1: correction_run_count, handles.gradiometer_f3_save_real_mV(correction_run_count-20+1: correction_run_count),'k*')
    hold on; plot(correction_run_count-20+1: correction_run_count, handles.gradiometer_f3_save_imag_mV(correction_run_count-20+1: correction_run_count),'k*')
    hold off;
end
hold off;

% plot([1:nRun], (handles.gradiometer_f3_save(1:nRun)+handles.gradiometer_f5_save(1:nRun)));
% plotyy([1:nRun], handles.gradiometer_f3_save(1:nRun),[1:nRun], handles.gradiometer_f3phase_save(1:nRun));
xlabel('run number'); title('f3 time series baseline');

%%%% PLOTS CORRECTED F3 DATA OVER TIME (MAGNITUDE)
axes(handles.plot_f3_corrected_time)
plot(1:nRun, (handles.gradiometer_f3_save_amp_corrected_mV(1:nRun)),'b');
text(0.5,0.9,['baseline correction = ', num2str(correction*1000), ' mV'],'Units','normalized')
xlabel('run number'); title('f3 time series corrected');
if correction_on == 1
    text(0.5,0.8,['corrected sig amp = ', num2str(handles.gradiometer_f3_save_amp_corrected_mV(nRun)), ' mV'],'Units','normalized')
    text(0.5,0.75,['corrected sig phase = ', num2str(handles.gradiometer_f3_save_phase_corrected(nRun)), ' rad' ],'Units','normalized')
end
noiseSamples = str2num(get(handles.editText_noiseSamples,'string'));
if handles.saved_noise_on == 1 && nRun > noiseSamples
    saved_noise_run_count = evalin('base','saved_noise_run_count');
    saved_noiseSamples = evalin('base','saved_noiseSamples');
    hold on; plot(saved_noise_run_count-saved_noiseSamples+1: saved_noise_run_count, handles.gradiometer_f3_save_amp_corrected_mV(saved_noise_run_count-saved_noiseSamples+1: saved_noise_run_count),'r')
    hold off;
end
hold off;

