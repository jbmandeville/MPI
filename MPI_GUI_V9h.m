function varargout = MPI_GUI_V9g(varargin)
% MPI_GUI_V2_currentsense MATLAB code for MPI_GUI_V2_currentsense.fig
%      MPI_GUI_V2_currentsense, by itself, creates a new MPI_GUI_V2_currentsense or raises the existing
%      singleton*.
%
%      H = MPI_GUI_V2_currentsense returns the handle to a new MPI_GUI_V2_currentsense or the handle to
%      the existing singleton*.
%
%      MPI_GUI_V2_currentsense('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MPI_GUI_V2_currentsense.M with the given input arguments.
%
%      MPI_GUI_V2_currentsense('Property','Value',...) creates a new MPI_GUI_V2_currentsense or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MPI_GUI_V2_currentsense_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MPI_GUI_V2_currentsense_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MPI_GUI_V2_currentsense

<<<<<<< HEAD
% Last Modified by GUIDE v2.5 14-Nov-2018 14:59:02
=======
% Last Modified by GUIDE v2.5 08-Nov-2018 17:06:29
>>>>>>> master

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MPI_GUI_V7_OpeningFcn, ...
    'gui_OutputFcn',  @MPI_GUI_V7_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
   
end
% End initialization code - DO NOT EDIT

% --- Executes just before MPI_GUI_V2_currentsense is made visible.
function MPI_GUI_V7_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MPI_GUI_V2_currentsense (see VARARGIN)

% Choose default command line output for MPI_GUI_V2_currentsense
%clc;  % clear console (command window)
handles.output = hObject;

% Global variables
global myDeviceSettings myDaqStream
<<<<<<< HEAD
myDeviceSettings.connectionState = 0;
myDeviceSettings.rateContinuous = 500e3; % 500 kHz
myDeviceSettings.ratePulse      =  10e3; %  10 kHz
myDeviceSettings.driveFrequency = 25e3;  % or 40 us period
myDeviceSettings.deltaF1        = 100;  % Hz
myDeviceSettings.deltaF3Wide    = 50;   % Hz
myDeviceSettings.deltaF3Narrow  = 20;   % Hz
=======
myDeviceSettings.connectionState = 1;
%myDeviceSettings.Rate = 500e3;
myDeviceSettings.Rate = 100e3;
>>>>>>> master

myDaqStream.session =0;
myDaqStream.device = 0;
myDaqStream.ao0 = 0;
myDaqStream.ao1 = 0;
myDaqStream.ch1 = 0;
myDaqStream.ch2 = 0;
<<<<<<< HEAD
myDaqStream.ch1.Range = [-10,10];

display(['connection state = ',num2str(myDeviceSettings.connectionState)]);
=======

>>>>>>> master
if ( myDeviceSettings.connectionState == 1 )
    configure_NIDevice(handles);
end

% myDaqStream.ch2 = myDaqStream.session.addAnalogInputChannel(devID, 4, 'Voltage');
% myDaqStream.ch2.Range = [-10,10];
% myDaqStream.ch2.TerminalConfig = 'Differential';
handles.runcount = 0;
set(handles.runcount_string,'String','0');
handles.tstart = tic;

<<<<<<< HEAD
% %handles.statictext_outputvoltage = 2;
=======
% %handles.amp = 2;
>>>>>>> master
% handles.numaveset = 1;
% handles.pausetime = .1;
% handles.drive_freq =25e3;
% handles.pw = handles.periodmult/handles.drive_freq;
% handles.blocksize = duration*myDaqStream.session.Rate;
% handles.time = [0:1/myDaqStream.session.Rate:handles.pw];
<<<<<<< HEAD
% output_data_temp = 1*handles.statictext_outputvoltage*sin(2*pi*handles.drive_freq*handles.time).';
% handles.output_data =[output_data_temp, zeros(size(output_data_temp))];

handles.runButtonStatus = 0;
set(handles.staticText_motorOn,'Visible','off');
=======
% output_data_temp = 1*handles.amp*sin(2*pi*handles.drive_freq*handles.time).';
% handles.output_data =[output_data_temp, zeros(size(output_data_temp))];

handles.stop_button_status = 0;
set(handles.text_motor_on,'Visible','off');
>>>>>>> master

handles.SNR_on = 0;
assignin('base','SNR_on',handles.SNR_on);
handles.saved_noise_on = 0;
assignin('base','saved_noise_on',handles.saved_noise_on);
assignin('base','correction',0);
assignin('base','correction_on',0);
assignin('base','correction_run_count',[]);
assignin('base','shift_on',0);
assignin('base','startproj_count',[]);
assignin('base','proj_pts',[]);
assignin('base','shift_amp_vals',[]);
assignin('base','proj_num',[]);
assignin('base','num_projections',[]);

figure(3), figure(4), figure(5); close 3 4 5 % reopen them to close them

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MPI_GUI_V2_currentsense wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function configure_NIDevice(handles)
global myDeviceSettings myDaqStream
myDaqStream.session = daq.createSession('ni');
<<<<<<< HEAD
myDaqStream.session.Rate = myDeviceSettings.rateRateContinuous;
=======
myDaqStream.session.Rate = myDeviceSettings.Rate;
>>>>>>> master

myDaqStream.device  = daq.getDevices;
devID = myDaqStream.device(1).ID;
handles.devID = devID;

myDaqStream.ao0 = myDaqStream.session.addAnalogOutputChannel(devID, 0, 'Voltage');
myDaqStream.ao1 = myDaqStream.session.addAnalogOutputChannel(devID, 1, 'Voltage');

myDaqStream.ch1 = myDaqStream.session.addAnalogInputChannel(devID, 0, 'Voltage');
<<<<<<< HEAD
myDaqStream.ch1.Range = [-0.5,0.5];
=======
myDaqStream.ch1.Range = [-10,10];
>>>>>>> master
myDaqStream.ch1.TerminalConfig = 'SingleEnded';
myDaqStream.ch2 = myDaqStream.session.addAnalogInputChannel(devID, 1, 'Voltage');
myDaqStream.ch2.Range = [-10,10];
myDaqStream.ch2.TerminalConfig = 'SingleEnded';

% --- Outputs from this function are returned to the command line.
function varargout = MPI_GUI_V7_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
axes(handles.data_plot1); cla;
axes(handles.data_plot_freq); cla;
axes(handles.data_plot_time); cla;

varargout{1} = handles.output;


% --- Executes on button press in run_button.
% function run_button_Callback(hObject, eventdata, handles)
% % hObject    handle to run_button (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
<<<<<<< HEAD
% statictext_outputvoltage = handles.statictext_outputvoltage;
=======
% amp = handles.amp;
>>>>>>> master
% pw = handles.pw;
% time = handles.time;
%
% drive_freq = handles.drive_freq;
% axes(handles.data_plot1);
% cla;
% guide

<<<<<<< HEAD
% while handles.runButtonStatus == 1
=======
% while handles.stop_button_status == 1
>>>>>>> master
% queueOutputData(myDaqStream.session, handles.output_data);
% [captured_data] = myDaqStream.session.startForeground();
% handles.data = captured_data(2:end,:);
% handles.output = handles.data;
%
% amplitude = (max(handles.data(end/4:end,1))-min(handles.data(end/2:end,1)))/2;
% plot(time(2:end), handles.data(:,1));
% xlabel('time (s)');
%
% text(.8*max(time),0, ['amplitude = ', num2str(amplitude)]);
<<<<<<< HEAD
% title(['Acquired signal (duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, staticText_outputVoltage = ',num2str(statictext_outputvoltage),'V)']);
=======
% title(['Acquired signal (duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
>>>>>>> master
% pause(.5);
% end
%
% guidata(hObject, handles);


<<<<<<< HEAD
% --- Executes on button press in toggleButton_startRun.
function toggleButton_startRun_Callback(hObject, ~, handles)
% hObject    handle to toggleButton_startRun (see GCBO)
=======
% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, ~, handles)
% hObject    handle to stop_button (see GCBO)
>>>>>>> master
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global myDaqStream myDeviceSettings
<<<<<<< HEAD
% Hint: get(hObject,'Value') returns toggle state of toggleButton_startRun
handles.runButtonStatus = get(hObject,'Value');
%disp(['stop button status = ', num2str(handles.runButtonStatus)]);
if ( handles.runButtonStatus == 1 )
    set(hObject,'String','Stop Run');
else
    set(hObject,'String','Start Run');
end
=======
% Hint: get(hObject,'Value') returns toggle state of stop_button
handles.stop_button_status = get(hObject,'Value');
disp(['stop button status = ', num2str(handles.stop_button_status)]);

>>>>>>> master
%d  = daq.getDevices;
%devID = d(1).ID;
%myDaqStream.session = daq.createSession('ni');

<<<<<<< HEAD
myDaqStream.session.Rate = myDeviceSettings.rateContinuous;
=======
%myDeviceSettings.Rate = 500e3;
myDeviceSettings.Rate = 100e3;
myDaqStream.session.Rate = myDeviceSettings.Rate;
>>>>>>> master

%myDaqStream.ao0 = myDaqStream.session.addAnalogOutputChannel(devID, 0:3, 'Voltage');
% myDaqStream.ao0.TerminalConfig = 'Differential';
%myDaqStream.ao1 = myDaqStream.session.addAnalogOutputChannel(devID, 1, 'Voltage');
% myDaqStream.ao1.TerminalConfig = 'Differential';



% myDaqStream.ch1 = myDaqStream.session.addAnalogInputChannel(devID, 0, 'Voltage');
% myDaqStream.ch1.Range = [-10,10];
% myDaqStream.ch1.TerminalConfig = 'SingleEnded';

% myDaqStream.ch2 = myDaqStream.session.addAnalogInputChannel(devID, 4, 'Voltage');
% % myDaqStream.ch2.Range = [-10,10];
% myDaqStream.ch2.TerminalConfig = 'Differential';


<<<<<<< HEAD
% handles.periodmult%handles.statictext_outputvoltage = 2;
handles.numaveset = 1;

handles.drive_freq = myDeviceSettings.driveFrequency;
=======

% myDaqStream.ch1.Range = [-handles.rangelim,handles.rangelim];
% myDaqStream.ch2.Range = [-10,10];

% handles.periodmult%handles.amp = 2;
handles.numaveset = 1;
% pausetime =  handles.pausetime;
handles.drive_freq =25e3;
>>>>>>> master
handles.pw = handles.periodmult/handles.drive_freq;
% handles.blocksize = duration*myDaqStream.session.Rate; % EM commented out; duration has built-in MATLAB definition & is not being defined. I think duration is supposed to = handles.periodmult. 
handles.time = 0 : 1/myDaqStream.session.Rate:handles.pw;

<<<<<<< HEAD
%disp('DAQ actual range = ');
%myDaqStream.ch1.Range
=======

myDaqStream.ch1.Range = [-handles.rangelim, handles.rangelim];
disp('DAQ actual range = '); myDaqStream.ch1.Range
    
>>>>>>> master

axes(handles.data_plot1);
handles.shift_amp = 0;
handles.runcount = get(handles.runcount_string,'Value');
% handles.shift_on = 0;

<<<<<<< HEAD
% continuous data acquisition here
=======
>>>>>>> master
while get(hObject,'Value')
     handles = run_pulses(hObject,handles);
end


datacursormode on;
guidata(hObject, handles);

<<<<<<< HEAD
function handles = run_pulses(hObject, handles)
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

function handles = analyzeDAQOutput(handles)
global myDeviceSettings
nRun = handles.runcount;  % alias nRun
%%%gradiometer /preamp voltage freq dom. plot
axes(handles.data_plot_freq); datacursormode on;
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

lin_amp0p3 = lin_amp0+lin_amp3;
amplitude = (max(handles.data(ceil(end/2):end,1))-min(handles.data(ceil(end/2):end,1)))/2;

%%%gradiometer /preamp voltage time dom. plot
time = handles.time;
axes(handles.data_plot1);
plot(time(1:end), handles.data(:,1));
xlabel('time (s)');
h1 = text(0,-.5*min(handles.data), ['amp =', num2str(1000*amplitude),' mV']); %unit change Erica 2-7-2018
set(h1,'fontsize',20,'Color','blue');
h2 = text(0,1*min(handles.data), ['f0+f3 =', num2str(1000*lin_amp0p3),' mV']); %unit change Erica 2-7-2018
set(h2,'fontsize',40,'Color','magenta');
title({'Acquired signal'; ['(duration = ',num2str(handles.amp),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(handles.amp),'V)']});


handles.saved_noise_on = evalin('base','saved_noise_on');

xfft_save(:,:,nRun) = xfft;
assignin('base','xfft_save', xfft_save);
assignin('base','data_f',maglog(:,1));
assignin('base','time',time(2:end));
assignin('base','freq', f);




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
figure(1), plot(output_data_drive);
figure(2), plot(output_data_shift);

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


function handles = computeShiftField(handles)
% output: handles.shift_amp
nRun = handles.runcount;  % alias nRun

shift_on = evalin('base','shift_on');
%display(['shift_on = ',num2str(shift_on)]);
startproj_count = evalin('base','startproj_count');
handles.startproj_count = startproj_count;
%proj_pts = evalin('base','proj_pts');
proj_count = nRun-startproj_count+1;
shift_amp_vals = evalin('base','shift_amp_vals');
proj_num = evalin('base','proj_num');
num_projections = evalin('base','num_projections');

if ( shift_on == 1 )
    set(handles.staticText_ShiftStatus,'ForegroundColor','Red');
    if nRun < startproj_count + length(shift_amp_vals)
        if proj_count == 1;
            handles.f = waitbar(0,'Scanning projection axis...');
            frames = java.awt.Frame.getFrames();
            frames(end).setAlwaysOnTop(1);
        end
        handles.shift_amp = shift_amp_vals(proj_count);
        disp(['shift amplitude = ', num2str(handles.shift_amp)]);
        waitbar(proj_count/length(shift_amp_vals),handles.f,['Projection ', num2str(proj_num),' of ',num2str(num_projections),': point ',num2str(proj_count),' of ',num2str(length(shift_amp_vals))]);
        
    elseif nRun >= startproj_count + length(shift_amp_vals) % once projection is finished
        close(handles.f); %close waitbar
        %             figure(3) % show projection plot
        %             figure(4) % show projection plot
        projection = evalin('base','projection');
        figure(3), hold on, plot(projection.f3_amp(:,proj_num));
        figure(4), hold on, plot(projection.f3_amp_corrected(:,proj_num));
        
        startproj_count = nRun; % next projection starts now
        assignin('base','startproj_count',startproj_count);
        proj_count = nRun-startproj_count+1; % start next projection
        
        % run up to total number of projections, and flip direction of shift_amp_vals for each
        if proj_num < num_projections
            proj_num = proj_num + 1; % advance to next projection
            assignin('base','proj_num',proj_num);
            
            shift_amp_vals = flip(shift_amp_vals);
            assignin('base','shift_amp_vals',shift_amp_vals);
            figure(5), hold off, plot(shift_amp_vals,'-o'); hold on, line([1 length(shift_amp_vals)],[0 0]);
        else
            shift_on = 0;
            handles.shift_amp = 0;
            assignin('base','shift_on',shift_on);
        end
        
        if proj_count == 1;
            handles.f = waitbar(0,'Scanning projection axis...');
            frames = java.awt.Frame.getFrames();
            frames(end).setAlwaysOnTop(1);
        end
        handles.shift_amp = shift_amp_vals(proj_count);
        disp(['shift amplitude = ', num2str(handles.shift_amp)]);
        waitbar(proj_count/length(shift_amp_vals),handles.f,['Projection ', num2str(proj_num),' of ',num2str(num_projections),': point ',num2str(proj_count),' of ',num2str(length(shift_amp_vals))]);
    end
elseif shift_on == 0
    set(handles.staticText_ShiftStatus,'ForegroundColor','Blue');
    handles.shift_amp = 0;
end



function plotf0(handles)
nRun = handles.runcount;  % alias nRun
axes(handles.f0_time_plot)
plot(1:nRun, handles.gradiometer_f0_save_mV(1:nRun));
xlabel('run number'); title('f0 time series');
% axes(handles.f4_time_plot)
% % plot([1:nRun], handles.gradiometer_f5_save(1:nRun));
% % xlabel('run number'); title('f5 level');
% plot([1:nRun], handles.gradiometer_f4_save(1:nRun));
% xlabel('run number'); title('f4 level');
% axes(handles.f2_time_plot)
% plot([1:nRun], handles.gradiometer_f2_save(1:nRun));
% xlabel('run number'); title('f2 level');

function plotf3(handles)
%%%% PLOTS F3 DATA OVER TIME (MAGNITUDE, REAL AND IMAGINARY PARTS)
nRun = handles.runcount;  % alias nRun
correction = evalin('base','correction');
correction_on = evalin('base','correction_on');
correction_run_count = evalin('base','correction_run_count');

axes(handles.data_plot_time)
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
axes(handles.data_plot_time_corrected)
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
    axes(handles.noise_plot);
    plot(1:handles.noisecount, handles.noise_trend);
    xlabel('noise count'); title('noise trend');
    set(handles.editText_currentNoiseMean, 'String', num2str(handles.noise_mean(handles.noisecount)));
    set(handles.editText_currentNoiseMean, 'Value', handles.noise_mean(handles.noisecount));
    set(handles.editText_currentNoiseStDev, 'String', num2str(handles.noise_trend(handles.noisecount)));
    set(handles.editText_currentNoiseStDev, 'Value', handles.noise_trend(handles.noisecount));
    handles.noisecount = handles.noisecount + 1;
end


    

function editText_outputVoltage_Callback(hObject, eventdata, handles)
% hObject    handle to staticText_outputVoltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of staticText_outputVoltage as text
%        str2double(get(hObject,'String')) returns contents of staticText_outputVoltage as a double
=======

function handles = run_pulses(hObject, handles)
global myDaqStream myDeviceSettings

    amp = handles.amp;
    pw = handles.pw;
    time = handles.time;
    pausetime =  handles.pausetime;
    
    correction = evalin('base','correction');
    correction_on = evalin('base','correction_on');
    correction_run_count = evalin('base','correction_run_count');

    drive_freq = handles.drive_freq;

    if handles.runcount == 0
        handles.gradiometer_f3_save = [];  %%clears the data when clear button is pressed
    end
    
    phase_offset =get(handles.slider2_phase,'Value');
    amp_offset =get(handles.slider1_amp,'Value');
    
    
    %   phase_offset2 =get(handles.slider4_phase,'Value');
    %   amp_offset2 =get(handles.slider3_amp,'Value');
    %

    cancellation_term = 0.0+ amp_offset*sin(2*pi*75e3*handles.time+phase_offset).';
    cancellation_term(end) = 0;
    
    %cancellation_term2 = 0.0+ amp_offset2*sin(2*pi*50e3*handles.time+phase_offset2).';
    % N = numel(handles.time);
    % W = hamming(numel(handles.time));
    % Wramp = linspace(0,1,ceil(N/5));
    % W = [Wramp, ones(1,N-2*(ceil(N/5))), 1-Wramp].';
    
    shift_on = evalin('base','shift_on');
    startproj_count = evalin('base','startproj_count');
    handles.startproj_count = startproj_count;
    %proj_pts = evalin('base','proj_pts');
    display(['shift_on = ',num2str(shift_on)]);
    proj_count = handles.runcount-startproj_count+1;
    shift_amp_vals = evalin('base','shift_amp_vals');
    proj_num = evalin('base','proj_num');
    num_projections = evalin('base','num_projections');

    if shift_on == 1
        if handles.runcount < startproj_count + length(shift_amp_vals) 
            if proj_count == 1;
                handles.f = waitbar(0,'Scanning projection axis...');
                frames = java.awt.Frame.getFrames();
                frames(end).setAlwaysOnTop(1);
            end
            handles.shift_amp = shift_amp_vals(proj_count);
            disp(['shift amplitude = ', num2str(handles.shift_amp)]);
            waitbar(proj_count/length(shift_amp_vals),handles.f,['Projection ', num2str(proj_num),' of ',num2str(num_projections),': point ',num2str(proj_count),' of ',num2str(length(shift_amp_vals))]);
            
        elseif handles.runcount >= startproj_count + length(shift_amp_vals) % once projection is finished
            close(handles.f); %close waitbar
%             figure(3) % show projection plot
%             figure(4) % show projection plot
            projection = evalin('base','projection');
            figure(3), hold on, plot(projection.f3_amp(:,proj_num)); 
            figure(4), hold on, plot(projection.f3_amp_corrected(:,proj_num)); 
    
            startproj_count = handles.runcount; % next projection starts now
            assignin('base','startproj_count',startproj_count);
            proj_count = handles.runcount-startproj_count+1; % start next projection
            
            % run up to total number of projections, and flip direction of shift_amp_vals for each
                if proj_num < num_projections
                    proj_num = proj_num + 1; % advance to next projection
                    assignin('base','proj_num',proj_num);

                    shift_amp_vals = flip(shift_amp_vals);
                    assignin('base','shift_amp_vals',shift_amp_vals);
                    figure(5), hold off, plot(shift_amp_vals,'-o'); hold on, line([1 length(shift_amp_vals)],[0 0]);
                else
                    shift_on = 0;
                    handles.shift_amp = 0;
                    assignin('base','shift_on',shift_on);
                end
            
            if proj_count == 1;
                handles.f = waitbar(0,'Scanning projection axis...');
                frames = java.awt.Frame.getFrames();
                frames(end).setAlwaysOnTop(1);
            end
            handles.shift_amp = shift_amp_vals(proj_count);
            disp(['shift amplitude = ', num2str(handles.shift_amp)]);
            waitbar(proj_count/length(shift_amp_vals),handles.f,['Projection ', num2str(proj_num),' of ',num2str(num_projections),': point ',num2str(proj_count),' of ',num2str(length(shift_amp_vals))]);
        end    
    elseif shift_on == 0
        handles.shift_amp = 0;
    end
    
  
    
    % output_data_temp1 = W.*(handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).') + W.*(cancellation_term);
    % output_data_temp2 = -W.*(handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).') +W.*(cancellation_term);
    output_data_drive = (handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).') + (cancellation_term);
%     dt = handles.time(2)-handles.time(1);
%     padtime = 88e-3; 
%     num_pad_pts = round(padtime/dt);
%     output_data_drive_padded = vertcat(zeros(num_pad_pts,1),output_data_drive);
    
    output_data_drive_padded = output_data_drive;
%     output_data_drive_padded(ceil(end/2):end) = zeros(size(output_data_drive_padded(ceil(end/2):end)));
    
%output_data_temp2 = -(handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).') +(cancellation_term);
    %empty = zeros(length(output_data_temp1),1);
    output_data_shift = handles.shift_amp*ones(size(output_data_drive_padded));

    %  output_data =[output_data_temp1, zeros(size(output_data_temp1))];
    output_data =[output_data_drive_padded, output_data_shift];
%     figure(1), plot(output_data_drive);
%     figure(2), plot(output_data_shift);
    
    queueOutputData(myDaqStream.session, output_data);
    telapsed_now = toc(handles.tstart);
    temp_data = inputSingleScan(myDaqStream.session);
    [captured_data] = myDaqStream.session.startForeground();
%     handles.data = captured_data(1:end,:);
    handles.data = captured_data(end-length(output_data_drive_padded)+1:end,1);
    handles.output = handles.data;
    handles.Coil_Temp(handles.runcount+1) = ceil(Thermistor(mean(temp_data(:,2))));
    set(handles.Temp_Disp, 'String', num2str(handles.Coil_Temp(end)));
    
    
    
    %%%gradiometer /preamp voltage freq dom. plot
    axes(handles.data_plot_freq); datacursormode on;
    data(:,1) = handles.data(:,1);  %data(:,2) = data_currentsense;
    assignin('base','data_full', data);
    data_crop = data(ceil(end/4)+1:end,:);
    %data_crop = data(ceil(end/4)+1:end-ceil(end/4)+1,:);
    blocksize_crop = numel(data_crop(:,1));
    assignin('base','data_crop', data_crop);
    
    [f,mag,xfft] = daqdocfft_lin(data_crop,myDeviceSettings.Rate,blocksize_crop); assignin('base','xfft', xfft);
    
    % I0 = find(f > drive_freq - 1000 & f < drive_freq +1000);
    % I3 = find(f > drive_freq*3 - 500 & f < drive_freq*3 +500); assignin('base','I3', I3);
    % I3 = find(f > drive_freq*3 - 50 & f < drive_freq*3 +50); assignin('base','I3', I3);
    % I3exact = I3;
    % lin_amp0 = max(mag(I0,1));
    % lin_amp3 = sum(mag(I3,1));
    
   
    I0 = find(f > drive_freq - 100 & f < drive_freq +100);
    lin_amp0 = max(mag(I0,1));
    I3 = find(f > drive_freq*3 - 50 & f < drive_freq*3 +50); assignin('base','I3', I3);
%     lin_amp3 = max(mag(I3,1));
I3
xfft(I3,1)
        lin_complex3 = xfft(I3,1);
        lin_amp3 = abs(lin_complex3);
        lin_phase3 = phase(lin_complex3);
        lin_real3 = real(lin_complex3);
        lin_imag3 = imag(lin_complex3);
        lin_complex3_corr = lin_complex3 - correction;
        lin_amp3_corr = abs(lin_complex3_corr);
        lin_phase3_corr = phase(lin_complex3_corr);
    I5 = find(f > drive_freq*5 - 100 & f < drive_freq*5 +100);
    lin_amp5 = max(mag(I5,1));
    I4 = find(f > drive_freq*4 - 100 & f < drive_freq*4 +100);
    lin_amp4 = max(mag(I4,1));
    I2 = find(f > drive_freq*2 - 100 & f < drive_freq*2 +100); assignin('base','I3', I3);
    lin_amp2 = max(mag(I2,1));
    
    % I3exact = find(f > drive_freq*3 - 50 & f < drive_freq*3 +50);
    I3exact = find(f > drive_freq*3 - 20 & f < drive_freq*3 +20);
    
    phase_31 = (angle(xfft(I3exact,1))); %phase_32  = angle(xfft(I3,2));
    
    
    
    [f,maglog] = daqdocfft(data_crop,myDeviceSettings.Rate,blocksize_crop);
    plot(f,maglog(:,1));
    hold on; plot(f(I3),maglog(I3),'rs','markerfacecolor',[0 0 0]);
    hold on; plot(f(I0),maglog(I0),'rs','markerfacecolor',[0 0 0]);
    xlabel('frequency (Hz)');
    text(2e3,0, ['DC offset = ', num2str(1000*max(mag(1,1))),'mV']); % unit change to mV - EM 2/6/2018
    text(2e3,-10, ['f0 amp gradiometer = ', num2str(1000*lin_amp0),'mV']); % unit change to mV - EM 2/6/2018
    text(2e3,-20, ['f3 amp gradiometer = ', num2str(1000*lin_amp3),'mV',', \phi = ', num2str(lin_phase3),' rad']);
    text(5e4,-30, ['(real = ', num2str(1000*lin_real3),'mV',', imag = ', num2str(1000*lin_imag3),' mV)']);
    text(2e3,-40, ['f5 amp gradiometer = ', num2str(1000*lin_amp5),'mV']);

    xlim([0, myDeviceSettings.Rate/2]);ylim([-120, 10]); hold off;
    
    
    
    
    
    text(10e4,-60, ['amp = ', num2str(amp_offset)]);
    text(10e4,-80, ['phase = ', num2str(phase_offset)]);
    ylim([-120, 10]);
    
    
    if handles.runcount == 0
        handles.timetrack = [];
    end
    
    handles.runcount = handles.runcount+1
%     handles.runcount;
    set(handles.runcount_string, 'String', num2str(handles.runcount));
    set(handles.runcount_string, 'Value', handles.runcount);
    
    lin_complex3
    handles.gradiometer_f3_save_complex(handles.runcount) = lin_complex3
    handles.gradiometer_f3_save_amp_mV(handles.runcount) = 1000*lin_amp3;
    handles.gradiometer_f3_save_phase(handles.runcount) = lin_phase3;
    handles.gradiometer_f3_save_real_mV(handles.runcount) = 1000*lin_real3;
    handles.gradiometer_f3_save_imag_mV(handles.runcount) = 1000*lin_imag3;
    
    handles.gradiometer_f3_save_complex_corrected(handles.runcount) = lin_complex3_corr;
    handles.gradiometer_f3_save_amp_corrected_mV(handles.runcount) = 1000*lin_amp3_corr;
    handles.gradiometer_f3_save_phase_corrected(handles.runcount) = lin_phase3_corr;
        
    handles.gradiometer_f0_save_mV(handles.runcount) = 1000*lin_amp0;
    handles.gradiometer_f5_save_mV(handles.runcount) = 1000*lin_amp5;
    handles.gradiometer_f4_save_mV(handles.runcount) = 1000*lin_amp4;
    handles.gradiometer_f2_save_mV(handles.runcount) = 1000*lin_amp2;
    handles.gradiometer_f3phase_save(handles.runcount) = phase_31;
%     handles.datacrop_save = data_crop;
    handles.timetrack(handles.runcount) = telapsed_now;
    
    if handles.runcount > 1
        if length(handles.datacrop_save(:,1)) ~= length(data_crop);
%             handles.datacrop_save = [];
              display('Error saving datacrop_save -- Size of data_crop has changed');
              display('Error saving datacrop_save -- Size of data_crop has changed');
        end
    end
    handles.datacrop_save(:,handles.runcount) = data_crop.';

    
    xfft_save(:,:,handles.runcount) = xfft;
    assignin('base','xfft_save', xfft_save);
    
    
    
    lin_amp0p3 = lin_amp0+lin_amp3;
    amplitude = (max(handles.data(ceil(end/2):end,1))-min(handles.data(ceil(end/2):end,1)))/2;
    
    %%%gradiometer /preamp voltage time dom. plot
    axes(handles.data_plot1);
    plot(time(1:end), handles.data(:,1));
    xlabel('time (s)');
    h1 = text(0,-.5*min(handles.data), ['amp =', num2str(1000*amplitude),' mV']); %unit change Erica 2-7-2018
    set(h1,'fontsize',20,'Color','blue');
    h2 = text(0,1*min(handles.data), ['f0+f3 =', num2str(1000*lin_amp0p3),' mV']); %unit change Erica 2-7-2018
    set(h2,'fontsize',40,'Color','magenta');
    title({'Acquired signal'; ['(duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']});
    
    
    N_noise = str2num(get(handles.Noise_Num,'string'));
    handles.saved_noise_on = evalin('base','saved_noise_on');

    %%%% PLOTS F3 DATA OVER TIME (MAGNITUDE, REAL AND IMAGINARY PARTS)
    axes(handles.data_plot_time)
%     plotyy([1:handles.runcount], (handles.gradiometer_f3_save(1:handles.runcount)), [1:handles.runcount], (handles.gradiometer_f3_save_phase(1:handles.runcount)));
    plot(1:handles.runcount, (handles.gradiometer_f3_save_amp_mV(1:handles.runcount)),'b');
    hold on, plot(1:handles.runcount, (handles.gradiometer_f3_save_real_mV(1:handles.runcount)),'r');
    hold on, plot(1:handles.runcount, (handles.gradiometer_f3_save_imag_mV(1:handles.runcount)),'g');
    if correction_on == 1
        hold on; plot(correction_run_count-20+1: correction_run_count, handles.gradiometer_f3_save_real_mV(correction_run_count-20+1: correction_run_count),'k*')
        hold on; plot(correction_run_count-20+1: correction_run_count, handles.gradiometer_f3_save_imag_mV(correction_run_count-20+1: correction_run_count),'k*')
        hold off;
    end
    hold off;
    
%     plot([1:handles.runcount], (handles.gradiometer_f3_save(1:handles.runcount)+handles.gradiometer_f5_save(1:handles.runcount)));
    % plotyy([1:handles.runcount], handles.gradiometer_f3_save(1:handles.runcount),[1:handles.runcount], handles.gradiometer_f3phase_save(1:handles.runcount));
    xlabel('run number'); title('f3 time series baseline');
    
    
    %%%% PLOTS CORRECTED F3 DATA OVER TIME (MAGNITUDE)
    axes(handles.data_plot_time_corrected)
    plot(1:handles.runcount, (handles.gradiometer_f3_save_amp_corrected_mV(1:handles.runcount)),'b');
    text(0.5,0.9,['baseline correction = ', num2str(correction*1000), ' mV'],'Units','normalized')
    xlabel('run number'); title('f3 time series corrected');
    if correction_on == 1
        text(0.5,0.8,['corrected sig amp = ', num2str(handles.gradiometer_f3_save_amp_corrected_mV(handles.runcount)), ' mV'],'Units','normalized')
        text(0.5,0.75,['corrected sig phase = ', num2str(handles.gradiometer_f3_save_phase_corrected(handles.runcount)), ' rad' ],'Units','normalized')        
    end
    if handles.saved_noise_on == 1 && handles.runcount > N_noise
        saved_noise_run_count = evalin('base','saved_noise_run_count');
        saved_N_noise = evalin('base','saved_N_noise');
        hold on; plot(saved_noise_run_count-saved_N_noise+1: saved_noise_run_count, handles.gradiometer_f3_save_amp_corrected_mV(saved_noise_run_count-saved_N_noise+1: saved_noise_run_count),'r')
        hold off;
    end
    hold off;
    
    
    if shift_on == 1
%         figure(3), % hold on;
%         plot([handles.runcount-proj_count+1:handles.runcount], (handles.gradiometer_f3_save_amp_mV(handles.runcount-proj_count+1:handles.runcount)));
%         title('projection (f3 amp)'); 
%         set(gcf,'Visible', 'off'); 
%         
%         figure(4), % hold on;
%         plot([handles.runcount-proj_count+1:handles.runcount], (handles.gradiometer_f3_save_amp_corrected_mV(handles.runcount-proj_count+1:handles.runcount)));
%         title('projection (corrected f3 amp)');
%         set(gcf,'Visible', 'off');
        
        projection = evalin('base','projection');
        
        num_pts = length(handles.runcount-proj_count+1:handles.runcount)
        projection.f3_amp(1:num_pts,proj_num) = handles.gradiometer_f3_save_amp_mV(handles.runcount-proj_count+1:handles.runcount);
        projection.f3_amp_corrected(1:num_pts,proj_num) = handles.gradiometer_f3_save_amp_corrected_mV(handles.runcount-proj_count+1:handles.runcount);
        projection.f3_complex(1:num_pts,proj_num) = handles.gradiometer_f3_save_complex(handles.runcount-proj_count+1:handles.runcount);
        projection.f3_complex_corrected(1:num_pts,proj_num) = handles.gradiometer_f3_save_complex_corrected(handles.runcount-proj_count+1:handles.runcount);
        
        assignin('base','projection',projection);

    end
    
    handles.shift_values(handles.runcount) = handles.shift_amp;
    handles.shift_values;
    assignin('base','shift_values',handles.shift_values);
    
    
    axes(handles.f0_time_plot)
    plot(1:handles.runcount, handles.gradiometer_f0_save_mV(1:handles.runcount));
    xlabel('run number'); title('f0 time series');
    % axes(handles.f4_time_plot)
    % % plot([1:handles.runcount], handles.gradiometer_f5_save(1:handles.runcount));
    % % xlabel('run number'); title('f5 level');
    % plot([1:handles.runcount], handles.gradiometer_f4_save(1:handles.runcount));
    % xlabel('run number'); title('f4 level');
    % axes(handles.f2_time_plot)
    % plot([1:handles.runcount], handles.gradiometer_f2_save(1:handles.runcount));
    % xlabel('run number'); title('f2 level');
    
    %%plot noise trend
    if(handles.runcount == N_noise)
        handles.noisecount = 1;
%         disp(['runcount = ', num2str(handles.runcount),'noisecount = ', num2str(handles.noisecount)]);
        handles.noise_trend = [];
    elseif handles.runcount >= N_noise
%         disp(['runcount = ', num2str(handles.runcount),'noisecount = ', num2str(handles.noisecount)]);
        handles.noise_trend(handles.noisecount) = std(handles.gradiometer_f3_save_amp_corrected_mV(handles.runcount-(N_noise-1):handles.runcount));
        handles.noise_mean(handles.noisecount) = mean(handles.gradiometer_f3_save_amp_corrected_mV(handles.runcount-(N_noise-1):handles.runcount));
        axes(handles.noise_plot);
        plot(1:handles.noisecount, handles.noise_trend);
        xlabel('noise count'); title('noise trend');
        set(handles.current_noise_mean_string, 'String', num2str(handles.noise_mean(handles.noisecount)));
        set(handles.current_noise_mean_string, 'Value', handles.noise_mean(handles.noisecount));
        set(handles.current_noise_string, 'String', num2str(handles.noise_trend(handles.noisecount)));
        set(handles.current_noise_string, 'Value', handles.noise_trend(handles.noisecount));
        handles.noisecount = handles.noisecount + 1;
    end
   
    handles.SNR_on = evalin('base','SNR_on');
    if handles.SNR_on == 1;
        handles.saved_noise_mean = evalin('base','saved_noise_mean');
        handles.saved_noise = evalin('base','saved_noise');
        SNR = (handles.gradiometer_f3_save_amp_corrected_mV(handles.runcount)-handles.saved_noise_mean)/handles.saved_noise;
    set(handles.SNR_update,'String',num2str(SNR));
    end
    
%     datacrop_save(:,:,handles.runcount) = data_crop;
    
    
    assignin('base','f3_time',handles.gradiometer_f3_save_amp_mV);
    assignin('base','f3_time_complex',handles.gradiometer_f3_save_complex);
    assignin('base','correction',correction);
    assignin('base','f3_time_corrected',handles.gradiometer_f3_save_amp_corrected_mV);    
    assignin('base','f2_time',handles.gradiometer_f2_save_mV);
    assignin('base','f5_time',handles.gradiometer_f5_save_mV);
    assignin('base','f4_time',handles.gradiometer_f4_save_mV);
    assignin('base','f0_time',handles.gradiometer_f0_save_mV);
    assignin('base','data_t',handles.data(:,:));
    assignin('base','data_f',maglog(:,1));
    assignin('base','time',time(2:end));
    assignin('base','freq', f);
    assignin('base','datacrop_save', handles.datacrop_save);
    assignin('base','timetrack', handles.timetrack);
    assignin('base','f3_phase_time',handles.gradiometer_f3phase_save);
    % assignin('base','datacrop_save', Differential);
    assignin('base','runcount',handles.runcount)
    assignin('base','N_noise',N_noise)

    pause(pausetime-.3);   %%%nidaq take ~300ms to play next pulse

guidata(hObject, handles);

    

function Amp_Callback(hObject, eventdata, handles)
% hObject    handle to Amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Amp as text
%        str2double(get(hObject,'String')) returns contents of Amp as a double
>>>>>>> master
handles.amp = str2double(get(hObject,'String'));
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
<<<<<<< HEAD
function editText_outputVoltage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to staticText_outputVoltage (see GCBO)
=======
function Amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amp (see GCBO)
>>>>>>> master
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.amp = str2double(get(hObject,'String'));
guidata(hObject, handles);



<<<<<<< HEAD
function editText_periodMultiplier_Callback(hObject, eventdata, handles)
% hObject    handle to editText_periodMultiplier (see GCBO)
=======
function P_mult_Callback(hObject, eventdata, handles)
% hObject    handle to P_mult (see GCBO)
>>>>>>> master
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.periodmult = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
<<<<<<< HEAD
function editText_periodMultiplier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_periodMultiplier (see GCBO)
=======
function P_mult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P_mult (see GCBO)
>>>>>>> master
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.periodmult = str2double(get(hObject,'String'));
guidata(hObject, handles);



function pause_time_Callback(hObject, eventdata, handles)
% hObject    handle to pause_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.pausetime = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pause_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pause_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.pausetime =str2double(get(hObject,'String'));
guidata(hObject, handles);


<<<<<<< HEAD
function editText_rangeInputChannel_Callback(hObject, eventdata, handles)
% hObject    handle to editText_rangeInputChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText_rangeInputChannel as text
%        str2double(get(hObject,'String')) returns contents of editText_rangeInputChannel as a double

% --- Executes during object creation, after setting all properties.
global myDaqStream
rangelim  = str2double(get(hObject,'String'));
myDaqStream.ch1.Range = [-rangelim, rangelim];
guidata(hObject, handles);


function editText_rangeInputChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_rangeInputChannel (see GCBO)
=======
function range_pos_Callback(hObject, eventdata, handles)
% hObject    handle to range_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range_pos as text
%        str2double(get(hObject,'String')) returns contents of range_pos as a double

% --- Executes during object creation, after setting all properties.
handles.rangelim  = str2double(get(hObject,'String'));
guidata(hObject, handles);


function range_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range_pos (see GCBO)
>>>>>>> master
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
<<<<<<< HEAD
global myDaqStream
=======
>>>>>>> master
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

<<<<<<< HEAD
rangelim  = str2double(get(hObject,'String'));
display(['define ch1 range ',num2str(rangelim)]);
myDaqStream.ch1.Range = [-rangelim, rangelim];
=======
handles.rangelim  = str2double(get(hObject,'String'));
>>>>>>> master
guidata(hObject, handles);


% --- Executes on button press in clear_button.
function clear_button_Callback(hObject, eventdata, handles)
% hObject    handle to clear_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.runcount_string,'Value',0);
saved_noise_on = 0;
assignin('base','saved_noise_on', saved_noise_on);
assignin('base','correction_on',0);
assignin('base','correction_run_count',[]);
assignin('base','correction',0);

% set(handles.runcount,'Value', 0);
% handles.gradiometer_f3_save = [];
% axes(handles.data_plot1); cla;
% axes(handles.data_plot_freq); cla;
% axes(handles.data_plot_time); cla;
guidata(hObject, handles);


% --- Executes on slider movement.
function slider1_amp_Callback(hObject, eventdata, handles)
% hObject    handle to slider1_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_phase_Callback(hObject, eventdata, handles)
% hObject    handle to slider2_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function slider2_phase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function offset_amp_disp_Callback(hObject, eventdata, handles)
% hObject    handle to offset_amp_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function offset_amp_disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_amp_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on button press in clear_offset_button.
function clear_offset_button_Callback(hObject, eventdata, handles)
% hObject    handle to clear_offset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%resets the values to zero
set(handles.slider1_amp,'Value',0);
set(handles.slider2_phase,'Value',0);

set(handles.slider3_amp,'Value',0);
set(handles.slider4_phase,'Value',0);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function runcount_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to runcount_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% handles.runcount_string = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes on slider movement.
function slider3_amp_Callback(hObject, eventdata, handles)
% hObject    handle to slider3_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function slider3_amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_phase_Callback(hObject, eventdata, handles)
% hObject    handle to slider4_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function slider4_phase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function PulseNum_Callback(hObject, eventdata, handles)
% hObject    handle to PulseNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function PulseNum_CreateFcn(hObject, eventdata,  handles)
% hObject    handle to PulseNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FwdButton.
function FwdButton_Callback(~, eventdata, handles)
% hObject    handle to FwdButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
number = str2double(get(handles.PulseNum,'string'));
length =str2double(get(handles.PulseTime,'string')) ;
direction = 1;
<<<<<<< HEAD
Pulse( number, length,direction, handles )
=======
set(handles.text_motor_on,'Visible','on');
Pulse( number, length,direction, handles )
set(handles.text_motor_on,'Visible','off');
>>>>>>> master


% --- Executes on button press in BackButton.
function BackButton_Callback(~, eventdata, handles)
% hObject    handle to BackButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


number = str2double(get(handles.PulseNum,'string'));%Gets the number and length of the pulse from the text boxes
length =str2double(get(handles.PulseTime,'string')) ;
direction = 0;%direction is 0 to go backwards

<<<<<<< HEAD
Pulse( number, length,direction,handles)%uses the Pulse function to pulse the stepper
=======
set(handles.text_motor_on,'Visible','on');%tells the user the motor is actually on with red text
Pulse( number, length,direction,handles)%uses the Pulse function to pulse the stepper
set(handles.text_motor_on,'Visible','off');%when the pulses finish turn off the text
>>>>>>> master



function PulseTime_Callback(hObject, eventdata, handles)
% hObject    handle to PulseTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes during object creation, after setting all properties.

function PulseTime_CreateFcn(hObject, eventdata, ~)
% hObject    handle to PulseTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Home_Callback(hObject, eventdata, handles)
% hObject    handle to Home (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function Home_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Home (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

<<<<<<< HEAD
function  Pulse( number, Length, direction, handles)
% Create bipolar square wave pulses with ON/OFF of equal duration
% number   : # of bipolar pulses
% Length   : lenght of each pulse in ms
% direction: 0=backward, 1=forward 
global myDaqStream myDeviceSettings

% Note that the motor is ON
set(handles.staticText_motorOn,'Visible','on');

=======
function  Pulse( number, Length, direction ,handles)
% Create bipolar square wave pulses with ON/OFF of equal duration
% number = # of bipolar pulses
% Length = lenght of each pulse in ms
global myDaqStream myDeviceSettings

>>>>>>> master
if myDaqStream.session.IsDone == 1
    stop(myDaqStream.session);
    release(myDaqStream.session)
    myDaqStream.session = daq.createSession('ni');%Initializes a new session with the DAQ
    myDaqStream.ao1 = myDaqStream.session.addDigitalChannel(handles.devID,'Port0/Line0:2','OutputOnly'); %Tells DAQ we will be outputting on analog out terminals 1-3
    addAnalogInputChannel(myDaqStream.session,handles.devID,2,'Voltage');
<<<<<<< HEAD
    myDaqStream.session.Rate = myDeviceSettings.ratePulse;    
    
    for i = 0:((2*number)+1) %This loop creates a square wave where number is the number of pulses in the square wave and length is the length of each square in ms
        if mod(i,2)==0%Checking if i is even or odd, even values make the HIGH and odd values of i make the LOW of the Sq wave
            output_data(i*Length+1:(i+1)*Length,1)= 1; %makes a HIGH section of the wave and assigns it to the output data vector
        else
            output_data(i*Length+1:(i+1)*Length,1)= 0;
        end
    end
    
    DirectionData = zeros(length(output_data),1); % initializing the Direction Data vector
    DirectionData(1:end) = 1*direction;           % sets all the direction values to be 5 or 0 (logicals determine the direction)

    Enable = zeros(length(output_data),1); % inializes the enable pin data
    Enable(1:end) = 1;                     % fills the enable vector with all HIGH values (5)
    Enable(end-10:(end)) = 0;              % sets the last few values in the enable pin to be low, this ensures the DAQ "latches" low and makes sure the stepper is properly turned off
    
    queueOutputData(myDaqStream.session, [Enable,DirectionData,output_data]); %queues all the data into 3 channnels
    myDaqStream.session.startForeground(); % outputs the pulses
    
    reset(myDaqStream.session) % What does this do?
end
% turn OFF the motor indicator
set(handles.staticText_motorOn,'Visible','off');
=======
    myDeviceSettings.Rate = 10000;  %sets the DAQ rate to 10kHz
    myDaqStream.session.Rate = myDeviceSettings.Rate;    
    
    for i = 0:((2*number)+1) %This loop creates a square wave where number is the number of pulses in the square wave and length is the length of each square in ms
        
        if mod(i,2)==0%Checking if i is even or odd, even values make the HIGH and odd values of i make the LOW of the Sq wave
            output_data_temp(i*Length+1:(i+1)*Length,1)= 1; %makes a HIGH section of the wave and assigns it to the output data vector
        else
            output_data_temp(i*Length+1:(i+1)*Length,1)= 0;
        end
    end
    
    output_data =output_data_temp;
    DirectionData = zeros(length(output_data),1); %initializing the Direction Data vector
    Enable = zeros(length(output_data),1); %inializes the enable pin data
    
    Enable(1:end) = 1;%fills the enable vector with all HIGH values (5)
    
    
    DirectionData(1:end) = 1*direction;%sets all the direction values to be 5 or 0 (logicals determine the direction)
    
    Enable(end-10:(end)) = 0;%sets the last few values in the enable pin to be low, this ensures the DAQ "latches" low and makes sure the stepper is properly turned off
    
    
    queueOutputData(myDaqStream.session, [ Enable,DirectionData,output_data]);%queues all the data
    myDaqStream.session.startForeground();%outputs the pulses
    
    reset(myDaqStream.session) 
end
>>>>>>> master


% --- Executes on button press in togglebutton3_CalcOff.
function togglebutton3_CalcOff_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3_CalcOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3_CalcOff


% --- Executes on button press in pushbutton12_ClearOff.
function pushbutton12_ClearOff_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12_ClearOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

<<<<<<< HEAD
%Clears the statictext_outputvoltage and phase offsets by setting them to zero
=======
%Clears the amp and phase offsets by setting them to zero
>>>>>>> master
set(handles.slider7_Amp_5,'Value',0);
set(handles.slider8_Phase_5,'Value',0);
guidata(hObject, handles);



% --- Executes on slider movement.
function slider7_Amp_5_Callback(hObject, eventdata, handles)
% hObject    handle to slider7_Amp_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function slider7_Amp_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7_Amp_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Phase_5_Callback(hObject, eventdata, handles)
% hObject    handle to slider8_Phase_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function slider8_Phase_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8_Phase_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider2_phase.
function slider2_phase_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider2_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save_current_noise.
function save_current_noise_Callback(hObject, eventdata, handles)
% hObject    handle to save_current_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

<<<<<<< HEAD
noiseSamples = evalin('base','noiseSamples'); %gets value of noiseSamples and runcount
saved_noise_run_count= evalin('base','runcount');
saved_noiseSamples= noiseSamples; %saves the noiseSamples as saved noise(because noiseSamples may change if the user changes the noise sample number in GUI)

if saved_noise_run_count > noiseSamples %Ensures there is enough run counts for the given noiseSamples
=======
N_noise = evalin('base','N_noise'); %gets value of N_noise and runcount
saved_noise_run_count= evalin('base','runcount');
saved_N_noise= N_noise; %saves the N_noise as saved noise(because N_noise may change if the user changes the noise sample number in GUI)

if saved_noise_run_count > N_noise %Ensures there is enough run counts for the given N_noise
>>>>>>> master
    
    
    %This body of code is simply saving and setting the variables at the
    %time when it is called.
    
<<<<<<< HEAD
    saved_noise_mean = get(handles.editText_currentNoiseMean,'Value');
    saved_noise = get(handles.editText_currentNoiseStDev,'Value');
=======
    saved_noise_mean = get(handles.current_noise_mean_string,'Value');
    saved_noise = get(handles.current_noise_string,'Value');
>>>>>>> master
    
    handles.saved_noise_mean = saved_noise_mean;
    handles.saved_noise = saved_noise;
    handles.saved_noise_run_count = saved_noise_run_count;
<<<<<<< HEAD
    handles.saved_noiseSamples= saved_noiseSamples;
=======
    handles.saved_N_noise= saved_N_noise;
>>>>>>> master
    
    set(handles.noise_for_SNR_calc,'String',num2str(saved_noise));
    set(handles.noise_mean_for_SNR_calc,'String',num2str(saved_noise_mean));
    
    assignin('base','saved_noise_mean',handles.saved_noise_mean);
    assignin('base','saved_noise',handles.saved_noise);
    assignin('base','saved_noise_run_count',saved_noise_run_count);
<<<<<<< HEAD
    assignin('base','saved_noiseSamples',saved_noiseSamples);
=======
    assignin('base','saved_N_noise',saved_N_noise);
>>>>>>> master
    
    handles.saved_noise_on = 1; %Notes the noise values have been saved
    assignin('base','saved_noise_on',handles.saved_noise_on)
    
    guidata(hObject, handles);
end



function noise_for_SNR_calc_Callback(hObject, eventdata, handles)
% hObject    handle to noise_for_SNR_calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function noise_for_SNR_calc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_for_SNR_calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calc_SNR.
function calc_SNR_Callback(hObject, eventdata, handles)
% hObject    handle to calc_SNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f3_time_corrected = evalin('base','f3_time_corrected');  %gets values of f3_time, saved noise mean, and saved noise from general code variables to use within the function
saved_noise_mean = evalin('base','saved_noise_mean');
saved_noise = evalin('base','saved_noise');
runcount = evalin('base','runcount');

sig_single_pt = f3_time_corrected(runcount); %saves only the most recent point

SNR = (sig_single_pt-saved_noise_mean)/saved_noise; %SNR = delta signal/ St.Dev

set(handles.SNR,'String',num2str(SNR));
handles.SNR_on = 1; %tells the outer function that SNR tracking is now on
assignin('base','SNR_on',handles.SNR_on);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function SliderStepAdj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderStepAdj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SliderStepAdj_Callback(hObject, eventdata, handles)
% hObject    handle to SliderStepAdj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in SetStep.
function SetStep_Callback(hObject, eventdata, handles)
% hObject    handle to SetStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


StepSize = str2double(get(handles.SliderStepAdj,'string')); % Retrieves the text in the SliderStepAdj text box--Assigns it to StepSize

CurrentStep = (get(handles.slider1_amp,'SliderStep')); %Gets the step sizes that are currently assigned 
StepUpdate = [StepSize, CurrentStep(2)]; % the step size is a 1x2 -- the button only changes the first value (when you press arrow)
set(handles.slider1_amp,'SliderStep',StepUpdate); %sets it to both sliders
set(handles.slider2_phase,'SliderStep',StepUpdate);


<<<<<<< HEAD
=======

function Noise_Num_Callback(hObject, eventdata, handles)
% hObject    handle to Noise_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function Noise_Num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Noise_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


>>>>>>> master
% --- Executes on button press in projections.
function projections_Callback(hObject, eventdata, handles)
% hObject    handle to projections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

<<<<<<< HEAD
% set(handles.toggleButton_startRun,'Value',0);
=======
% set(handles.stop_button,'Value',0);
>>>>>>> master
% guidata(hObject,handles);

figure(3)
figure(4)
close 3 4 
startproj_count = handles.runcount+1; % projection starts on next run
<<<<<<< HEAD
proj_pts = str2double(get(handles.editText_numberPointsInProjection,'String')); % proj_pts = 64;
=======
proj_pts = str2double(get(handles.text_num_pts_in_projection,'String')); % proj_pts = 64;
>>>>>>> master
num_projections = str2double(get(handles.text_num_projections,'String')); % num_projections = 13;

m = 0;
shift_amp_max = 7.44-m;
<<<<<<< HEAD
% generate linearly spaced vectors in + and - directions
shift_amp_vals1 = linspace(0,shift_amp_max,round(proj_pts/2))+m;
shift_amp_vals2 = linspace(-shift_amp_max,0,round(proj_pts/2))+m;
% and then concatenate them
=======
shift_amp_vals1 = linspace(0,shift_amp_max,round(proj_pts/2))+m;
shift_amp_vals2 = linspace(-shift_amp_max,0,round(proj_pts/2))+m;

>>>>>>> master
shift_amp_vals = horzcat(shift_amp_vals1(end:-1:1),shift_amp_vals2(end-1:-1:1));

figure(5), plot(shift_amp_vals,'-o'); hold on, line([1 length(shift_amp_vals)],[0 0]);
% set(gcf,'Visible', 'off');
            

projection.f3_amp = zeros(length(shift_amp_vals),num_projections);
projection.f3_amp_corrected = zeros(length(shift_amp_vals),num_projections);
projection.f3_complex = zeros(length(shift_amp_vals),num_projections);
projection.f3_complex_corrected = zeros(length(shift_amp_vals),num_projections);
assignin('base','projection',projection);
<<<<<<< HEAD
=======

>>>>>>> master
 
assignin('base','shift_amp_vals',shift_amp_vals)            
assignin('base','shift_on',1);
assignin('base','proj_pts',proj_pts);
assignin('base','startproj_count',startproj_count);
assignin('base','num_projections',num_projections);
assignin('base','proj_num',1);

guidata(hObject, handles);


function Temp = Thermistor(V)
 
R = (28.32/V-5.63)*10^3;
A1 = 3.354016E-03; 
B1 = 2.569850E-04; 
C1 = 2.620131E-06; 
D1 = 6.383091E-08;


Rref = 10e3;
Temp = 1./(A1 + B1*log(R/Rref)+C1*(log(R/Rref)).^2 + D1*(log(R/Rref)).^3)-273.15;


% --- Executes on button press in saveprojectionbutton.
function saveprojectionbutton_Callback(hObject, eventdata, handles)
% hObject    handle to saveprojectionbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% f3_time = evalin('base','f3_time');
projection = evalin('base','projection');
shift_amp_vals = evalin('base','shift_amp_vals');
uisave({'shift_amp_vals','projection'},'save_projection')


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

N_correction = 20;
<<<<<<< HEAD
%correction = evalin('base','correction')
%correction_on= evalin('base','correction_on')

current_run_count = evalin('base','runcount')
=======
correction = evalin('base','correction')
correction_on= evalin('base','correction_on')

current_run_count= evalin('base','runcount')
>>>>>>> master

if current_run_count > N_correction
    f3_time_complex = evalin('base','f3_time_complex');
    
    correction = mean(f3_time_complex(current_run_count - N_correction:current_run_count));
  
    correction_run_count = current_run_count;

    assignin('base','correction',correction);
    assignin('base','correction_run_count',correction_run_count);    
    assignin('base','correction_on',1)

end


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','correction',0);
assignin('base','correction_on',0);
assignin('base','correction_run_count',[]);



% --- Executes during object creation, after setting all properties.
function clear_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clear_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on clear_button and none of its controls.
function clear_button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to clear_button (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stop_projections.
function stop_projections_Callback(hObject, eventdata, handles)
% hObject    handle to stop_projections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shift_on = 0;
handles.shift_amp = 0;

assignin('base','shift_on',shift_on);
guidata(hObject, handles);



<<<<<<< HEAD
function editText_numberPointsInProjection_Callback(hObject, eventdata, handles)
% hObject    handle to editText_numberPointsInProjection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText_numberPointsInProjection as text
%        str2double(get(hObject,'String')) returns contents of editText_numberPointsInProjection as a double


% --- Executes during object creation, after setting all properties.
function editText_numberPointsInProjection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_numberPointsInProjection (see GCBO)
=======
function text_num_pts_in_projection_Callback(hObject, eventdata, handles)
% hObject    handle to text_num_pts_in_projection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_num_pts_in_projection as text
%        str2double(get(hObject,'String')) returns contents of text_num_pts_in_projection as a double


% --- Executes during object creation, after setting all properties.
function text_num_pts_in_projection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_num_pts_in_projection (see GCBO)
>>>>>>> master
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_num_projections_Callback(hObject, eventdata, handles)
% hObject    handle to text_num_projections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_num_projections as text
%        str2double(get(hObject,'String')) returns contents of text_num_projections as a double


% --- Executes during object creation, after setting all properties.
function text_num_projections_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_num_projections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
<<<<<<< HEAD


% --- Executes on button press in pushButton_selectMonitorPanel.
function pushButton_selectMonitorPanel_Callback(hObject, eventdata, handles)
% hObject    handle to pushButton_selectMonitorPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panel_Monitor,'visible','on');
set(handles.panel_Setup,'visible','off');
set(handles.pushButton_selectMonitorPanel,'BackgroundColor',[1 1 1]);
set(handles.pushButton_selectSetupPanel,'BackgroundColor',[0.9 0.9 0.9]);

% --- Executes on button press in pushButton_selectSetupPanel.
function pushButton_selectSetupPanel_Callback(hObject, eventdata, handles)
% hObject    handle to pushButton_selectSetupPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panel_Setup,'visible','on');
set(handles.panel_Monitor,'visible','off');
set(handles.pushButton_selectSetupPanel,'BackgroundColor',[1 1 1]);
set(handles.pushButton_selectMonitorPanel,'BackgroundColor',[0.9 0.9 0.9]);

function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function editText_noiseSamples_Callback(hObject, eventdata, handles)
% hObject    handle to editText_noiseSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText_noiseSamples as text
%        str2double(get(hObject,'String')) returns contents of editText_noiseSamples as a double


% --- Executes during object creation, after setting all properties.
function editText_noiseSamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_noiseSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editText_driveFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to editText_driveFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText_driveFrequency as text
%        str2double(get(hObject,'String')) returns contents of editText_driveFrequency as a double


% --- Executes during object creation, after setting all properties.
function editText_driveFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_driveFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editText_deltaF1_Callback(hObject, eventdata, handles)
% hObject    handle to editText_deltaF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of editText_deltaF1 as text
%        str2double(get(hObject,'String')) returns contents of editText_deltaF1 as a double
global myDeviceSettings
myDeviceSettings.deltaF1 = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function editText_deltaF1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_deltaF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editText_deltaF3Wide_Callback(hObject, eventdata, handles)
% hObject    handle to editText_deltaF3Wide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of editText_deltaF3Wide as text
%        str2double(get(hObject,'String')) returns contents of editText_deltaF3Wide as a double
global myDeviceSettings
myDeviceSettings.deltaF3Wide = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function editText_deltaF3Wide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_deltaF3Wide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editText_deltaF3Narrow_Callback(hObject, eventdata, handles)
% hObject    handle to editText_deltaF3Narrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of editText_deltaF3Narrow as text
%        str2double(get(hObject,'String')) returns contents of editText_deltaF3Narrow as a double
global myDeviceSettings
myDeviceSettings.deltaF3Narrow = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function editText_deltaF3Narrow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_deltaF3Narrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editText_continuousRate_Callback(hObject, eventdata, handles)
% hObject    handle to editText_continuousRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of editText_continuousRate as text
%        str2double(get(hObject,'String')) returns contents of editText_continuousRate as a double
global myDeviceSettings
myDeviceSettings.ratePulse = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function editText_continuousRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_continuousRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editText_ratePulsed_Callback(hObject, eventdata, handles)
% hObject    handle to editText_ratePulsed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of editText_ratePulsed as text
%        str2double(get(hObject,'String')) returns contents of editText_ratePulsed as a double
global myDeviceSettings
myDeviceSettings.rateContinuous = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function editText_ratePulsed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_ratePulsed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function staticText_ShiftStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to staticText_ShiftStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
=======
>>>>>>> master
