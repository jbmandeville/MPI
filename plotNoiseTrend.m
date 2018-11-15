function handles = plotNoiseTrend(handles)
nRun = handles.runcount;  % alias nRun
noiseSamples = str2num(get(handles.editText_noiseSamples,'string'));
assignin('base','N_noise',noiseSamples)
if(nRun == noiseSamples)
    handles.noisecount = 1;
    %         disp(['runcount = ', num2str(nRun),'noisecount = ', num2str(handles.noisecount)]);
    handles.noise_trend = [];
elseif nRun >= noiseSamples
    %         disp(['runcount = ', num2str(nRun),'noisecount = ', num2str(handles.noisecount)]);
    handles.noise_trend(handles.noisecount) = std(handles.gradiometer_f3_save_amp_corrected_mV(nRun-(noiseSamples-1):nRun));
    handles.noise_mean(handles.noisecount) = mean(handles.gradiometer_f3_save_amp_corrected_mV(nRun-(noiseSamples-1):nRun));
    axes(handles.plot_noise_time);
    plot(1:handles.noisecount, handles.noise_trend);
    xlabel('noise count'); title('noise trend');
    set(handles.editText_currentNoiseMean, 'String', num2str(handles.noise_mean(handles.noisecount)));
    set(handles.editText_currentNoiseMean, 'Value', handles.noise_mean(handles.noisecount));
    set(handles.editText_currentNoiseStDev, 'String', num2str(handles.noise_trend(handles.noisecount)));
    set(handles.editText_currentNoiseStDev, 'Value', handles.noise_trend(handles.noisecount));
    handles.noisecount = handles.noisecount + 1;
end
