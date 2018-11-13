function varargout = MPI_GUI_V2_currentsense(varargin)
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

% Last Modified by GUIDE v2.5 29-Jun-2016 13:35:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MPI_GUI_V2_currentsense_OpeningFcn, ...
                   'gui_OutputFcn',  @MPI_GUI_V2_currentsense_OutputFcn, ...
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
function MPI_GUI_V2_currentsense_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MPI_GUI_V2_currentsense (see VARARGIN)

% Choose default command line output for MPI_GUI_V2_currentsense
handles.output = hObject;

d  = daq.getDevices;
devID = d(1).ID;
handles.s = daq.createSession('ni');

handles.s.Rate = 500e3;

handles.ao0 = handles.s.addAnalogOutputChannel(devID, 0, 'Voltage');
handles.ao1 = handles.s.addAnalogOutputChannel(devID, 1, 'Voltage');

handles.ch1 = handles.s.addAnalogInputChannel(devID, 0, 'Voltage');
handles.ch1.Range = [-10,10];
handles.ch1.TerminalConfig = 'Differential';

handles.ch2 = handles.s.addAnalogInputChannel(devID, 4, 'Voltage');
handles.ch2.Range = [-10,10];
handles.ch2.TerminalConfig = 'Differential';
handles.runcount = 0;

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

% UIWAIT makes MPI_GUI_V2_currentsense wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MPI_GUI_V2_currentsense_OutputFcn(hObject, eventdata, handles) 
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

handles.ao0 = handles.s.addAnalogOutputChannel(devID, 0, 'Voltage');
handles.ao0.TerminalConfig = 'Differential';
handles.ao1 = handles.s.addAnalogOutputChannel(devID, 1, 'Voltage');
handles.ao1.TerminalConfig = 'Differential';



handles.ch1 = handles.s.addAnalogInputChannel(devID, 0, 'Voltage');
% handles.ch1.Range = [-10,10];
handles.ch1.TerminalConfig = 'Differential';

handles.ch2 = handles.s.addAnalogInputChannel(devID, 4, 'Voltage');
% handles.ch2.Range = [-10,10];
handles.ch2.TerminalConfig = 'Differential';



handles.ch1.Range = [-handles.rangelim,handles.rangelim];
handles.ch2.Range = [-10,10];

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
    
    handles.runcount = get(handles.runcount_string,'Value');
    
    if handles.runcount == 0
         handles.gradiometer_f3_save = [];  %%clears the data when clear button is pressed
    end
    
  phase_offset =get(handles.slider2_phase,'Value');
  amp_offset =get(handles.slider1_amp,'Value');
cancellation_term = 0.0+ amp_offset*sin(2*pi*75e3*handles.time+phase_offset).';


output_data_temp1 = 1*handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).' +cancellation_term;
output_data_temp2 = -1*handles.amp*sin(2*pi*handles.drive_freq*handles.time+pi).' +cancellation_term;
% handles.output_data =[output_data_temp, zeros(size(output_data_temp))];   
handles.output_data =[output_data_temp1 output_data_temp2];   

    
queueOutputData(handles.s, handles.output_data);
[captured_data] = handles.s.startForeground();
handles.data = captured_data(2:end,:);
handles.output = handles.data;

amplitude = (max(handles.data(end/2:end,1))-min(handles.data(end/2:end,1)))/2;

%%%gradiometer /preamp voltage time dom. plot
axes(handles.data_plot1);
plot(time(2:end), handles.data(:,1));
xlabel('time (s)');
h2 = text(.3*max(time),0, ['amplitude = ', num2str(amplitude)]);
set(h2,'fontsize',22);
title({['Acquired signal']; ['(duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']});

%%%current sense resistor voltage time dom. plot
axes(handles.data_plot2);
data_currentsense = (handles.data(:,2)-mean(handles.data(:,2)))/1.12;  %%%subtract out DC offset, divide out small gain from circuit
plot(time(2:end), data_currentsense);
amplitude2 = (max(data_currentsense(end/2:end,1))-min(data_currentsense(end/2:end,1)))/2;
xlabel('time (s)');
h2 = text(.3*max(time),0, ['amplitude = ', num2str(amplitude2)]);
set(h2,'fontsize',22);
title({['Acquired signal']; ['(duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']});



%%%gradiometer /preamp voltage freq dom. plot
axes(handles.data_plot_freq); datacursormode on;
data(:,1) = handles.data(:,1);  data(:,2) = data_currentsense;  assignin('base','data_full', data);
data_crop = data(end/2+1:end,:);  blocksize_crop = numel(data_crop(:,1)); assignin('base','data_crop', data_crop);
[f,mag,xfft] = daqdocfft_lin(data_crop,handles.s.Rate,blocksize_crop); assignin('base','xfft', xfft);
[f,maglog] = daqdocfft(data_crop,handles.s.Rate,blocksize_crop);
plot(f,maglog(:,1));
xlim([0, handles.s.Rate/2]);ylim([-120, 10]);

I0 = find(f > drive_freq - 100 & f < drive_freq +100);I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100); assignin('base','I3', I3);
lin_amp0 = max(mag(I0,end-1));
lin_amp3 = max(mag(I3,end-1)); lin_phase3 = (angle(xfft(I3,1)));
text(2e3,0, ['f0 amp gradiometer = ', num2str(lin_amp0)]);
text(2e3,-10, ['f3 amp gradiometer = ', num2str(1000*lin_amp3),'mV']); 
text(2e3,-20, ['f3 amp gradiometer = ', num2str(lin_phase3),'rad']); 


%%%current sense resistor voltage freq dom. plot
axes(handles.data_plot_freq2); datacursormode on;
plot(f,maglog(:,2));
xlim([0, handles.s.Rate/2]);
lin_amp02 = max(mag(I0,2));
lin_amp32 = max(mag(I3,2));
text(2e3,0, ['f0 amp current sense = ', num2str(lin_amp02)]);
text(2e3,-10, ['f3 amp current sense = ', num2str(1000*lin_amp32),'mV']); ylim([-120, 10]);


I0 = find(f > drive_freq - 100 & f < drive_freq +100);
lin_amp0 = max(mag(I0,end-1));
log_amp0 = max(maglog(I0,end-1));
I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100); assignin('base','I3', I3);
lin_amp3 = sum(mag(I3,end-1));
title(['Current = ',num2str(lin_amp02*10)]);
ylabel('Magnitude (dB)')
xlabel('Frequency (Hz)')





text(4e5,-20, ['amp = ', num2str(amp_offset)]);
text(4e5,-60, ['phase = ', num2str(phase_offset)]);

ylim([-120, 10]);



handles.runcount = handles.runcount+1;  set(handles.runcount_string, 'String', num2str(handles.runcount));
set(handles.runcount_string, 'Value', handles.runcount);
handles.gradiometer_f3_save(handles.runcount) = 1000*lin_amp3;
handles.gradiometer_f0_save(handles.runcount) = 1000*lin_amp0;

axes(handles.data_plot_time)
plot([1:handles.runcount], handles.gradiometer_f3_save(1:handles.runcount));
xlabel('run number'); title('f3 level');


axes(handles.data_plot_time_f0)
plot([1:handles.runcount], handles.gradiometer_f0_save(1:handles.runcount));
xlabel('run number');  title('f0 level');

assignin('base','f3_time',handles.gradiometer_f3_save);
assignin('base','data_t',handles.data(:,:));
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
set(handles.runcount_string,'Value',0);
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
set(handles.slider1_amp,'Value',0);
set(handles.slider2_phase,'Value',0);


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function runcount_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to runcount_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% handles.runcount_string = str2double(get(hObject,'String'));
guidata(hObject, handles);
