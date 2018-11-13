function varargout = MPI_GUI_V2_calcoffset(varargin)
% MPI_GUI_V2_calcoffset MATLAB code for MPI_GUI_V2_calcoffset.fig
%      MPI_GUI_V2_calcoffset, by itself, creates a new MPI_GUI_V2_calcoffset or raises the existing
%      singleton*.
%
%      H = MPI_GUI_V2_calcoffset returns the handle to a new MPI_GUI_V2_calcoffset or the handle to
%      the existing singleton*.
%
%      MPI_GUI_V2_calcoffset('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MPI_GUI_V2_calcoffset.M with the given input arguments.
%
%      MPI_GUI_V2_calcoffset('Property','Value',...) creates a new MPI_GUI_V2_calcoffset or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MPI_GUI_V2_calcoffset_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MPI_GUI_V2_calcoffset_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MPI_GUI_V2_calcoffset

% Last Modified by GUIDE v2.5 15-Jun-2016 17:25:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MPI_GUI_V2_calcoffset_OpeningFcn, ...
                   'gui_OutputFcn',  @MPI_GUI_V2_calcoffset_OutputFcn, ...
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


% --- Executes just before MPI_GUI_V2_calcoffset is made visible.
function MPI_GUI_V2_calcoffset_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MPI_GUI_V2_calcoffset (see VARARGIN)

% Choose default command line output for MPI_GUI_V2_calcoffset
handles.output = hObject;

d  = daq.getDevices;
devID = d(1).ID;
handles.s = daq.createSession('ni');

handles.s.Rate = 500e3;

handles.ao0 = handles.s.addAnalogOutputChannel(devID, 0, 'Voltage');
handles.ao1 = handles.s.addAnalogOutputChannel(devID, 1, 'Voltage');

handles.ch1 = handles.s.addAnalogInputChannel(devID, 4, 'Voltage');
handles.ch1.Range = [-10,10];
handles.ch1.TerminalConfig = 'Differential';

handles.ch2 = handles.s.addAnalogInputChannel(devID, 0, 'Voltage');
handles.ch2.Range = [-10,10];
handles.ch2.TerminalConfig = 'Differential';
handles.runcount = 0;
% 
% %handles.amp = 2;
% handles.numaveset = 1;
% handles.pausetime = .1;
% handles.drive_freq =25e3;
% handles.pw = handles.periodmult/handles.drive_freq;
% handles.blocksize = duration*handles.s.Rate;
% handles.time = [0:1/handles.s.Rate:handles.pw];
% output_data_temp = 1*handles.amp*sin(2*pi*handles.drive_freq*handles.time).';
% handles.output_data =[output_data_temp, zeros(size(output_data_temp))];

handles.stop_button_status = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MPI_GUI_V2_calcoffset wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MPI_GUI_V2_calcoffset_OutputFcn(hObject, eventdata, handles) 
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
% amp = handles.amp;
% pw = handles.pw;
% time = handles.time;
% 
% drive_freq = handles.drive_freq;
% axes(handles.data_plot1);
% cla;
% guide

% while handles.stop_button_status == 1
% queueOutputData(handles.s, handles.output_data);
% [captured_data] = handles.s.startForeground();
% handles.data = captured_data(2:end,:);
% handles.output = handles.data;
% 
% amplitude = (max(handles.data(end/4:end,1))-min(handles.data(end/2:end,1)))/2;
% plot(time(2:end), handles.data(:,1));
% xlabel('time (s)');
% 
% text(.8*max(time),0, ['amplitude = ', num2str(amplitude)]);
% title(['Acquired signal (duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
% pause(.5);
% end
% 
% guidata(hObject, handles);


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stop_button
handles.stop_button_status = get(hObject,'Value');
disp(['stop button status = ', num2str(handles.stop_button_status)]);


d  = daq.getDevices;
devID = d(1).ID;
handles.s = daq.createSession('ni');

handles.s.Rate = 500e3;

handles.ao1 = handles.s.addAnalogOutputChannel(devID, 1, 'Voltage');
handles.ao1.TerminalConfig = 'SingleEnded';
%handles.ao1 = handles.s.addAnalogOutputChannel(devID, 1, 'Voltage');

handles.ch1 = handles.s.addAnalogInputChannel(devID, 0, 'Voltage');
% handles.ch1.Range = [-10,10];
handles.ch1.TerminalConfig = 'Differential';

handles.ch2 = handles.s.addAnalogInputChannel(devID, 4, 'Voltage');
% handles.ch2.Range = [-10,10];
handles.ch2.TerminalConfig = 'Differential';



handles.ch1.Range = [-handles.rangelim,handles.rangelim];
handles.ch2.Range = [-handles.rangelim,handles.rangelim];

% handles.periodmult%handles.amp = 2;
handles.numaveset = 1;
pausetime =  handles.pausetime;
handles.drive_freq =25e3;
handles.pw = handles.periodmult/handles.drive_freq;
handles.blocksize = duration*handles.s.Rate;
handles.time = [0:1/handles.s.Rate:handles.pw];



amp = handles.amp;
pw = handles.pw;
time = handles.time;

drive_freq = handles.drive_freq;
axes(handles.data_plot1);


while get(hObject,'Value')
  phase_offset =get(handles.slider2_phase,'Value');
  amp_offset =get(handles.slider1_amp,'Value');
cancellation_term = 0.0+ amp_offset*sin(2*pi*75e3*handles.time+phase_offset).';


output_data_temp = 1*handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).' +cancellation_term;
% handles.output_data =[output_data_temp, zeros(size(output_data_temp))];   
handles.output_data =[output_data_temp];   

    
queueOutputData(handles.s, handles.output_data);
[captured_data] = handles.s.startForeground();
handles.data = captured_data(2:end,:);
handles.output = handles.data;

amplitude = (max(handles.data(end/2:end,1))-min(handles.data(end/2:end,1)))/2;


axes(handles.data_plot1);
plot(time(2:end), handles.data(:,:));
xlabel('time (s)');
h2 = text(.8*max(time),0, ['amplitude = ', num2str(amplitude)]);
set(h2,'fontsize',22);
title({['Acquired signal']; ['(duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']});


axes(handles.data_plot_freq);

datacursormode on;


data = handles.data;
data_crop = data(end/2+1:end,:);  blocksize_crop = numel(data_crop(:,1));

[f,mag,xfft] = daqdocfft_lin(data_crop,handles.s.Rate,blocksize_crop);
[f,maglog] = daqdocfft(data_crop,handles.s.Rate,blocksize_crop);

assignin('base','xfft', xfft);

plot(f,maglog(:,1));


% plot(f,mag(:,1));
xlim([0, handles.s.Rate/2]);

I0 = find(f > drive_freq - 100 & f < drive_freq +100);
lin_amp0 = max(mag(I0,end-1));
log_amp0 = max(maglog(I0,end-1));
I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);

assignin('base','I3', I3);

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
% title({['Acquired signal']; ['(duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']});%', preamp gain = ',num2str(preamp_gain),')']});

text(2.6e5,-20, ['amp offset = ', num2str(amp_offset)]);
text(2.6e5,-60, ['phase offset = ', num2str(phase_offset)]);


assignin('base','I3b', I3b);

Ylim = get(gca,'ylim');
Ymax = Ylim(2);


ylim([-120, 10]);


text(1.3e5,0, ['f0 amp gradiometer = ', num2str(lin_amp0)]);
text(1.3e5,-10, ['f3 amp gradiometer = ', num2str(1000*lin_amp3),'mV']);

handles.runcount = handles.runcount+1;
handles.gradiometer_f3_save(handles.runcount) = 1000*lin_amp3;
handles.gradiometer_f0_save(handles.runcount) = 1000*lin_amp0;

axes(handles.data_plot_time)
plot([1:handles.runcount], handles.gradiometer_f3_save(1:handles.runcount));
xlabel('run number'); title('f3 level');


axes(handles.data_plot_time_f0)
plot([1:handles.runcount], handles.gradiometer_f0_save(1:handles.runcount));
xlabel('run number');  title('f0 level');

assignin('base','f3_time',handles.gradiometer_f3_save);
assignin('base','data_t',handles.data(:,1));
assignin('base','data_f',maglog(:,1));
assignin('base','time',time(2:end));
assignin('base','freq', f);

% saveas(gcf, ['run_',num2str(handles.runcount),'.png']);
pause(pausetime-.3);   %%%nidaq take ~300ms to play next pulse
end


datacursormode on;
guidata(hObject, handles);



function Amp_Callback(hObject, eventdata, handles)
% hObject    handle to Amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Amp as text
%        str2double(get(hObject,'String')) returns contents of Amp as a double
handles.amp = str2double(get(hObject,'String'));
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function Amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.amp = 0.05;
guidata(hObject, handles);



function P_mult_Callback(hObject, eventdata, handles)
% hObject    handle to P_mult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P_mult as text
%        str2double(get(hObject,'String')) returns contents of P_mult as a double
handles.periodmult = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function P_mult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P_mult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.periodmult = 300;
guidata(hObject, handles);



function pause_time_Callback(hObject, eventdata, handles)
% hObject    handle to pause_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pause_time as text
%        str2double(get(hObject,'String')) returns contents of pause_time as a double
handles.pausetime = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pause_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pause_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.pausetime = 1;
guidata(hObject, handles);


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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.rangelim =  10;
guidata(hObject, handles);


% --- Executes on button press in clear_button.
function clear_button_Callback(hObject, eventdata, handles)
% hObject    handle to clear_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.runcount = 0;
handles.gradiometer_f3_save = [];
axes(handles.data_plot1); cla;
axes(handles.data_plot_freq); cla;
axes(handles.data_plot_time); cla;
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

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


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

% Hints: get(hObject,'String') returns contents of offset_amp_disp as text
%        str2double(get(hObject,'String')) returns contents of offset_amp_disp as a double



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


% --- Executes on button press in calc_offset_button.
function calc_offset_button_Callback(hObject, eventdata, handles)
% hObject    handle to calc_offset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of calc_offset_button
% handles.cal_offset_button_status = get(hObject,'Value');
% disp(['cal offset button status = ', num2str(handles.cal_offset_button_status)]);


%%copied from run/stop button callback
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
handles.ch1.Range = [-handles.rangelim,handles.rangelim];
handles.ch2.Range = [-handles.rangelim,handles.rangelim];
handles.numaveset = 1;
pausetime =  handles.pausetime;
handles.drive_freq =25e3;
handles.pw = handles.periodmult/handles.drive_freq;
handles.blocksize = duration*handles.s.Rate;
handles.time = [0:1/handles.s.Rate:handles.pw];
amp = handles.amp;
pw = handles.pw;
time = handles.time;
drive_freq = handles.drive_freq;
axes(handles.data_plot1);
%%end copied from run/stop button callback

% if handles.stop_button_status == 10
for calnum = 1:10
    %%copied from run/stop button callback
    phase_offset =get(handles.slider2_phase,'Value');
    amp_offset =get(handles.slider1_amp,'Value');
    cancellation_term = 0.0+ amp_offset*handles.amp*sin(2*pi*75e3*handles.time+phase_offset).';
    output_data_temp = 1*handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).' +cancellation_term;
    handles.output_data =[output_data_temp];
    queueOutputData(handles.s, handles.output_data);
    [captured_data] = handles.s.startForeground();
    handles.data = captured_data(2:end,:);
    handles.output = handles.data;
    amplitude = (max(handles.data(end/2:end,1))-min(handles.data(end/2:end,1)))/2;
    axes(handles.data_plot1);
    plot(time(2:end), handles.data(:,1));
    xlabel('time (s)');
    h2 = text(.8*max(time),0, ['amplitude = ', num2str(amplitude)]);
    set(h2,'fontsize',22);
    title({['Acquired signal']; ['(duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']});
    axes(handles.data_plot_freq);
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
    handles.runcount = handles.runcount+1;
    handles.gradiometer_f3_save(handles.runcount) = 1000*lin_amp3;
    handles.gradiometer_f0_save(handles.runcount) = 1000*lin_amp0;
    axes(handles.data_plot_time)
    plot([1:handles.runcount], handles.gradiometer_f3_save(1:handles.runcount));
    xlabel('run number'); title('f3 level');
    axes(handles.data_plot_time_f0)
    plot([1:handles.runcount], handles.gradiometer_f0_save(1:handles.runcount));
    xlabel('run number');  title('f0 level');
    assignin('base','I3', I3);
    assignin('base','f3_time',handles.gradiometer_f3_save);
    assignin('base','data_t',handles.data(:,1));
    assignin('base','data_f',maglog(:,1));
    assignin('base','time',time(2:end));
    assignin('base','freq', f);
    pause(pausetime-.3);   %%%nidaq take ~300ms to play next pulse
    %%end copied from run/stop button callback
    
    data_cal(:,calnum) = data_crop(:,1);
    assignin('base','data_cal', data_cal);
    
    
    
   
end
% end

datacursormode on;

% handles.cal_offset_button_status = set(hObject,0);




guidata(hObject, handles);
