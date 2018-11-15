function handles = runPulses(hObject, handles)
global myDaqStream myDeviceSettings

if handles.runcount == 0
    handles.gradiometer_f3_save = [];  %%clears the data when clear button is pressed
end

% N = numel(handles.time);
% W = hamming(numel(handles.time));
% Wramp = linspace(0,1,ceil(N/5));
% W = [Wramp, ones(1,N-2*(ceil(N/5))), 1-Wramp].';

handles = computeShiftField(handles);

handles = communicateWithDAQ(handles);

% The analysis function changes the runcount
handles = analyzeDAQOutput(handles);  nRun = handles.runcount; %alias

plotf3(handles);

shift_on = evalin('base','shift_on');
if shift_on == 1
%    nRun = handles.runcount;  % alias nRun
%    shift_on = evalin('base','shift_on');
%    startproj_count = evalin('base','startproj_count');
%    handles.startproj_count = startproj_count;
%    proj_count = nRun-startproj_count+1;
%    figure(3), % hold on;
%    plot([nRun-proj_count+1:nRun], (handles.gradiometer_f3_save_amp_mV(nRun-proj_count+1:nRun)));
%    title('projection (f3 statictext_outputvoltage)');
%    set(gcf,'Visible', 'off');
    %
%    figure(4), % hold on;
%    plot([nRun-proj_count+1:nRun], (handles.gradiometer_f3_save_amp_corrected_mV(nRun-proj_count+1:nRun)));
%    title('projection (corrected f3 statictext_outputvoltage)');
%    set(gcf,'Visible', 'off');
    
    projection = evalin('base','projection');
    startproj_count = evalin('base','startproj_count');
    proj_count = nRun-startproj_count+1;
    proj_num = evalin('base','proj_num');
    
    num_pts = length(nRun-proj_count+1:nRun)
    projection.f3_amp(1:num_pts,proj_num) = handles.gradiometer_f3_save_amp_mV(nRun-proj_count+1:nRun);
    projection.f3_amp_corrected(1:num_pts,proj_num) = handles.gradiometer_f3_save_amp_corrected_mV(nRun-proj_count+1:nRun);
    projection.f3_complex(1:num_pts,proj_num) = handles.gradiometer_f3_save_complex(nRun-proj_count+1:nRun);
    projection.f3_complex_corrected(1:num_pts,proj_num) = handles.gradiometer_f3_save_complex_corrected(nRun-proj_count+1:nRun);
    
    assignin('base','projection',projection);
    
end
handles.shift_values(nRun) = handles.shift_amp;
handles.shift_values;
assignin('base','shift_values',handles.shift_values);

plotf0(handles);

%%plot noise trend
handles = plotNoiseTrend(handles);

handles.SNR_on = evalin('base','SNR_on');
if handles.SNR_on == 1;
    handles.saved_noise_mean = evalin('base','saved_noise_mean');
    handles.saved_noise = evalin('base','saved_noise');
    SNR = (handles.gradiometer_f3_save_amp_corrected_mV(nRun)-handles.saved_noise_mean)/handles.saved_noise;
    set(handles.SNR_update,'String',num2str(SNR));
end

%     datacrop_save(:,:,nRun) = data_crop;

assignin('base','f3_time',handles.gradiometer_f3_save_amp_mV);
assignin('base','f3_time_complex',handles.gradiometer_f3_save_complex);
%assignin('base','correction',correction);  % not modified, so unnecessary
assignin('base','f3_time_corrected',handles.gradiometer_f3_save_amp_corrected_mV);
assignin('base','f2_time',handles.gradiometer_f2_save_mV);
assignin('base','f5_time',handles.gradiometer_f5_save_mV);
assignin('base','f4_time',handles.gradiometer_f4_save_mV);
assignin('base','f0_time',handles.gradiometer_f0_save_mV);
assignin('base','data_t',handles.data(:,:));
assignin('base','datacrop_save', handles.datacrop_save);
assignin('base','timetrack', handles.timetrack);
assignin('base','f3_phase_time',handles.gradiometer_f3phase_save);
% assignin('base','datacrop_save', Differential);
assignin('base','runcount',nRun)

pause(handles.pausetime-.3);   %%%nidaq take ~300ms to play next pulse

guidata(hObject, handles);
