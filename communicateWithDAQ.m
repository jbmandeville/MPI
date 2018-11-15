function handles = communicateWithDAQ(handles)
global myDeviceSettings myDaqStream
nRun = handles.runcount;  % alias nRun
amp_offset   = get(handles.slider1_amp,'Value');
phase_offset = get(handles.slider2_phase,'Value');
%   phase_offset2 =get(handles.slider4_phase,'Value');
%   amp_offset2 =get(handles.slider3_amp,'Value');
cancellation_term = 0.0+ amp_offset*sin(2*pi*75e3*handles.time+phase_offset).';
cancellation_term(end) = 0;
%cancellation_term2 = 0.0+ amp_offset2*sin(2*pi*50e3*handles.time+phase_offset2).';
% output_data_temp1 = W.*(handles.statictext_outputvoltage*sin(2*pi*handles.drive_freq*handles.time+pi).') + W.*(cancellation_term);
% output_data_temp2 = -W.*(handles.statictext_outputvoltage*sin(2*pi*handles.drive_freq*handles.time+pi).') +W.*(cancellation_term);
output_data_drive = (handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).') + (cancellation_term);
%     dt = handles.time(2)-handles.time(1);
%     padtime = 88e-3;
%     num_pad_pts = round(padtime/dt);
%     output_data_drive_padded = vertcat(zeros(num_pad_pts,1),output_data_drive);
% output_data_drive_padded = output_data_drive;
%     output_data_drive_padded(ceil(end/2):end) = zeros(size(output_data_drive_padded(ceil(end/2):end)));
%output_data_temp2 = -(handles.statictext_outputvoltage*sin(2*pi*handles.drive_freq*handles.time+pi).') +(cancellation_term);
%empty = zeros(length(output_data_temp1),1);
%output_data_shift = handles.shift_amp*ones(size(output_data_drive_padded));
output_data_shift = handles.shift_amp*ones(size(output_data_drive));

output_data =[output_data_drive, output_data_shift];  % drive and shift data in two channels
plotDAQInput(handles, output_data_drive, output_data_shift);

if ( myDeviceSettings.connectionState == 1 )
    queueOutputData(myDaqStream.session, output_data);
    temperatureData = inputSingleScan(myDaqStream.session);
    [captured_data] = myDaqStream.session.startForeground();
    handles.timetrack(nRun) = toc(handles.tstart);
else
    temperatureData = zeros(2);
    captured_data = output_data;
end
handles.data = captured_data(end-length(output_data_drive)+1:end,1);
handles.output = handles.data;
handles.Coil_Temp(nRun+1) = ceil(Thermistor(mean(temperatureData(:,2))));
set(handles.Temp_Disp, 'String', num2str(handles.Coil_Temp(end)));

