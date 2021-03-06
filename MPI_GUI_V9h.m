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

% Last Modified by GUIDE v2.5 16-Nov-2018 10:39:19

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
myDeviceSettings.connectionState = 0;
myDeviceSettings.rateContinuous = 500e3; % 500 kHz
myDeviceSettings.ratePulse      =  10e3; %  10 kHz
myDeviceSettings.driveFrequency = 25e3;  % or 40 us period
myDeviceSettings.deltaF1        = 100;  % Hz
myDeviceSettings.deltaF3Wide    = 50;   % Hz
myDeviceSettings.deltaF3Narrow  = 20;   % Hz

myDaqStream.session =0;
myDaqStream.device = 0;
myDaqStream.ao0 = 0;
myDaqStream.ao1 = 0;
myDaqStream.ch1 = 0;
myDaqStream.ch2 = 0;
myDaqStream.ch1.Range = [-10,10];

myDeviceSettings.connectionState = get(handles.checkBox_DAQConnected,'Value');
if ( myDeviceSettings.connectionState == 1 )
    display('connected to DAQ');
    configure_NIDevice(handles);
else
    display('assume no connection: DAQ not initialized');
end
disp(['rateContinuous = ', num2str(myDeviceSettings.rateContinuous)]);

% myDaqStream.ch2 = myDaqStream.session.addAnalogInputChannel(devID, 4, 'Voltage');
% myDaqStream.ch2.Range = [-10,10];
% myDaqStream.ch2.TerminalConfig = 'Differential';
handles.runcount = 0;
set(handles.runcount_string,'String','0');
handles.tstart = tic;

% %handles.statictext_outputvoltage = 2;
% handles.numaveset = 1;
% handles.pausetime = .1;
% handles.drive_freq =25e3;
% handles.pw = handles.periodmult/handles.drive_freq;
% handles.blocksize = duration*myDaqStream.session.Rate;
% handles.time = [0:1/myDaqStream.session.Rate:handles.pw];
% output_data_temp = 1*handles.statictext_outputvoltage*sin(2*pi*handles.drive_freq*handles.time).';
% handles.output_data =[output_data_temp, zeros(size(output_data_temp))];

handles.runButtonStatus = 0;
set(handles.staticText_motorOn,'Visible','off');

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

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MPI_GUI_V2_currentsense wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = MPI_GUI_V7_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
axes(handles.plot_voltage_time); cla;
axes(handles.plot_freq_time); cla;
axes(handles.plot_f3_time); cla;

varargout{1} = handles.output;


% --- Executes on button press in run_button.
% function run_button_Callback(hObject, eventdata, handles)
% % hObject    handle to run_button (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% statictext_outputvoltage = handles.statictext_outputvoltage;
% pw = handles.pw;
% time = handles.time;
%
% drive_freq = handles.drive_freq;
% axes(handles.plot_voltage_time);
% cla;
% guide

% while handles.runButtonStatus == 1
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
% title(['Acquired signal (duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, staticText_outputVoltage = ',num2str(statictext_outputvoltage),'V)']);
% pause(.5);
% end
%
% guidata(hObject, handles);


% --- Executes on button press in toggleButton_startRun.
function toggleButton_startRun_Callback(hObject, ~, handles)
% hObject    handle to toggleButton_startRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global myDaqStream myDeviceSettings
% Hint: get(hObject,'Value') returns toggle state of toggleButton_startRun
handles.runButtonStatus = get(hObject,'Value');
%disp(['stop button status = ', num2str(handles.runButtonStatus)]);
if ( handles.runButtonStatus == 1 )
    set(hObject,'String','Stop Run');
else
    set(hObject,'String','Start Run');
end
%d  = daq.getDevices;
%devID = d(1).ID;
%myDaqStream.session = daq.createSession('ni');

myDaqStream.session.Rate = myDeviceSettings.rateContinuous;

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


% handles.periodmult%handles.statictext_outputvoltage = 2;
handles.numaveset = 1;

handles.drive_freq = myDeviceSettings.driveFrequency;
handles.pw = handles.periodmult/handles.drive_freq;
% handles.blocksize = duration*myDaqStream.session.Rate; % EM commented out; duration has built-in MATLAB definition & is not being defined. I think duration is supposed to = handles.periodmult. 
display(['myDaqStream.session.Rate =',num2str(myDaqStream.session.Rate)]);

handles.time = 0 : 1/myDaqStream.session.Rate:handles.pw;  % time = 0 to pw in steps of 1/rate

%disp('DAQ actual range = ');
%myDaqStream.ch1.Range

handles.shift_amp = 0;
handles.runcount = get(handles.runcount_string,'Value');
% handles.shift_on = 0;

% continuous data acquisition here
while get(hObject,'Value')
     handles = runPulses(hObject,handles);
end


datacursormode on;
guidata(hObject, handles);


function editText_outputVoltage_Callback(hObject, eventdata, handles)
% hObject    handle to staticText_outputVoltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of staticText_outputVoltage as text
%        str2double(get(hObject,'String')) returns contents of staticText_outputVoltage as a double
handles.amp = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editText_outputVoltage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to staticText_outputVoltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.amp = str2double(get(hObject,'String'));
guidata(hObject, handles);


function editText_periodMultiplier_Callback(hObject, eventdata, handles)
% hObject    handle to editText_periodMultiplier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.periodmult = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editText_periodMultiplier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_periodMultiplier (see GCBO)
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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global myDaqStream
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

rangelim  = str2double(get(hObject,'String'));
display(['define ch1 range ',num2str(rangelim)]);
myDaqStream.ch1.Range = [-rangelim, rangelim];
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
% axes(handles.plot_voltage_time); cla;
% axes(handles.plot_freq_time); cla;
% axes(handles.plot_f3_time); cla;
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
onePulse( number, length,direction, handles )

% --- Executes on button press in BackButton.
function BackButton_Callback(~, eventdata, handles)
% hObject    handle to BackButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
number = str2double(get(handles.PulseNum,'string'));%Gets the number and length of the pulse from the text boxes
length =str2double(get(handles.PulseTime,'string')) ;
direction = 0;%direction is 0 to go backwards

onePulse( number, length,direction,handles)%uses the Pulse function to pulse the stepper

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

%Clears the statictext_outputvoltage and phase offsets by setting them to zero
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

noiseSamples = evalin('base','noiseSamples'); %gets value of noiseSamples and runcount
saved_noise_run_count= evalin('base','runcount');
saved_noiseSamples= noiseSamples; %saves the noiseSamples as saved noise(because noiseSamples may change if the user changes the noise sample number in GUI)

if saved_noise_run_count > noiseSamples %Ensures there is enough run counts for the given noiseSamples
    
    
    %This body of code is simply saving and setting the variables at the
    %time when it is called.
    
    saved_noise_mean = get(handles.editText_currentNoiseMean,'Value');
    saved_noise = get(handles.editText_currentNoiseStDev,'Value');
    
    handles.saved_noise_mean = saved_noise_mean;
    handles.saved_noise = saved_noise;
    handles.saved_noise_run_count = saved_noise_run_count;
    handles.saved_noiseSamples= saved_noiseSamples;
    
    set(handles.noise_for_SNR_calc,'String',num2str(saved_noise));
    set(handles.noise_mean_for_SNR_calc,'String',num2str(saved_noise_mean));
    
    assignin('base','saved_noise_mean',handles.saved_noise_mean);
    assignin('base','saved_noise',handles.saved_noise);
    assignin('base','saved_noise_run_count',saved_noise_run_count);
    assignin('base','saved_noiseSamples',saved_noiseSamples);
    
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


% --- Executes on button press in projections.
function projections_Callback(hObject, eventdata, handles)
% hObject    handle to projections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set(handles.toggleButton_startRun,'Value',0);
% guidata(hObject,handles);

axes(handles.plot_f3_projections);           cla reset;
axes(handles.plot_f3_corrected_projections); cla reset;

startproj_count = handles.runcount+1; % projection starts on next run
handles.editText_numberPointsInProjection
proj_pts = str2double(get(handles.editText_numberPointsInProjection,'String')); % proj_pts = 64;
num_projections = str2double(get(handles.text_num_projections,'String')); % num_projections = 13;

m = 0;
shift_amp_max = 7.44-m;
% generate linearly spaced vectors in + and - directions
shift_amp_vals1 = linspace(0,shift_amp_max,round(proj_pts/2))+m;
shift_amp_vals2 = linspace(-shift_amp_max,0,round(proj_pts/2))+m;
% and then concatenate them
shift_amp_vals = horzcat(shift_amp_vals1(end:-1:1),shift_amp_vals2(end-1:-1:1));

show = strcmp(get(handles.panel_currentData,'visible'),'on');
if ( show )
    axes(handles.plot_shift_values); plot(shift_amp_vals,'-o'); hold on, line([1 length(shift_amp_vals)],[0 0]);
end
% set(gcf,'Visible', 'off');
            

projection.f3_amp = zeros(length(shift_amp_vals),num_projections);
projection.f3_amp_corrected = zeros(length(shift_amp_vals),num_projections);
projection.f3_complex = zeros(length(shift_amp_vals),num_projections);
projection.f3_complex_corrected = zeros(length(shift_amp_vals),num_projections);
assignin('base','projection',projection);
 
assignin('base','shift_amp_vals',shift_amp_vals)            
assignin('base','shift_on',1);
assignin('base','proj_pts',proj_pts);
assignin('base','startproj_count',startproj_count);
assignin('base','num_projections',num_projections);
assignin('base','proj_num',1);

guidata(hObject, handles);


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
%correction = evalin('base','correction')
%correction_on= evalin('base','correction_on')

current_run_count = evalin('base','runcount')

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


function editText_numberPointsInProjection_Callback(hObject, eventdata, handles)
% hObject    handle to editText_numberPointsInProjection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of editText_numberPointsInProjection as text
%        str2double(get(hObject,'String')) returns contents of editText_numberPointsInProjection as a double


% --- Executes during object creation, after setting all properties.
function editText_numberPointsInProjection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText_numberPointsInProjection (see GCBO)
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


% --- Executes on button press in pushButton_selectCumulativeDataPanel.
function pushButton_selectCumulativeDataPanel_Callback(hObject, eventdata, handles)
% hObject    handle to pushButton_selectCumulativeDataPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panel_cumulativeData,'visible','on');
set(handles.panel_currentData,'visible','off');
set(handles.panel_Setup,'visible','off');
set(handles.pushButton_selectCumulativeDataPanel,'BackgroundColor',[1 1 1]);
set(handles.pushButton_selectCurrentDataPanel,'BackgroundColor',[0.9 0.9 0.9]);
set(handles.pushButton_selectSetupPanel,'BackgroundColor',[0.9 0.9 0.9]);

% --- Executes on button press in pushButton_selectCurrentDataPanel.
function pushButton_selectCurrentDataPanel_Callback(hObject, eventdata, handles)
% hObject    handle to pushButton_selectCurrentDataPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panel_currentData,'visible','on');
set(handles.panel_cumulativeData,'visible','off');
set(handles.panel_Setup,'visible','off');
set(handles.pushButton_selectCurrentDataPanel,'BackgroundColor',[1 1 1]);
set(handles.pushButton_selectCumulativeDataPanel,'BackgroundColor',[0.9 0.9 0.9]);
set(handles.pushButton_selectSetupPanel,'BackgroundColor',[0.9 0.9 0.9]);

% --- Executes on button press in pushButton_selectSetupPanel.
function pushButton_selectSetupPanel_Callback(hObject, eventdata, handles)
% hObject    handle to pushButton_selectSetupPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panel_Setup,'visible','on');
set(handles.panel_cumulativeData,'visible','off');
set(handles.panel_currentData,'visible','off');
set(handles.pushButton_selectSetupPanel,'BackgroundColor',[1 1 1]);
set(handles.pushButton_selectCumulativeDataPanel,'BackgroundColor',[0.9 0.9 0.9]);
set(handles.pushButton_selectCurrentDataPanel,'BackgroundColor',[0.9 0.9 0.9]);

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


% --- Executes on button press in pushButton_saveCurrentNoise.
function pushButton_saveCurrentNoise_Callback(hObject, eventdata, handles)
% hObject    handle to pushButton_saveCurrentNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushButton_CalcSNR.
function pushButton_CalcSNR_Callback(hObject, eventdata, handles)
% hObject    handle to pushButton_CalcSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushButton_setBaseline.
function pushButton_setBaseline_Callback(hObject, eventdata, handles)
% hObject    handle to pushButton_setBaseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushButton_clearBaseline.
function pushButton_clearBaseline_Callback(hObject, eventdata, handles)
% hObject    handle to pushButton_clearBaseline (see GCBO)
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


% --- Executes during object creation, after setting all properties.
function panel_currentData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to panel_currentData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function plot_driveField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_driveField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate plot_driveField


% --- Executes during object creation, after setting all properties.
function plot_shiftField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_shiftField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate plot_shiftField


% --- Executes during object creation, after setting all properties.
function plot_shift_values_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_shift_values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate plot_shift_values


% --- Executes during object creation, after setting all properties.
function plot_f3_projections_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_f3_projections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate plot_f3_projections


% --- Executes during object creation, after setting all properties.
function plot_f3_corrected_projections_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_f3_corrected_projections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate plot_f3_corrected_projections


% --- Executes on button press in checkBox_DAQConnected.
function checkBox_DAQConnected_Callback(hObject, eventdata, handles)
% hObject    handle to checkBox_DAQConnected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkBox_DAQConnected
global myDeviceSettings
myDeviceSettings.connectionState = get(hObject,'Value');
if ( myDeviceSettings.connectionState == 1 )
    configure_NIDevice(handles);
end
