function varargout = simple_scope(varargin)
%SIMPLE_SCOPE M-file for simple_scope.fig
%      SIMPLE_SCOPE, by itself, creates a new SIMPLE_SCOPE or raises the existing
%      singleton*.
%
%      H = SIMPLE_SCOPE returns the handle to a new SIMPLE_SCOPE or the handle to
%      the existing singleton*.
%
%      SIMPLE_SCOPE('Property','Value',...) creates a new SIMPLE_SCOPE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to simple_scope_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SIMPLE_SCOPE('CALLBACK') and SIMPLE_SCOPE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SIMPLE_SCOPE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simple_scope

% Last Modified by GUIDE v2.5 28-Mar-2013 07:21:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simple_scope_OpeningFcn, ...
                   'gui_OutputFcn',  @simple_scope_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before simple_scope is made visible.
function simple_scope_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
global data
% Choose default command line output for simple_scope
handles.output = hObject;

%% Setup with generic settings
data.session = daq.createSession('ni');
data.devices = daq.getDevices;
data.selection = strfind('USB-6363',data.devices.Model);
data.dev = data.devices(data.selection).ID;
% d = daq.getDevices;
data.ch = 0:2;
data.session.addAnalogInputChannel(data.dev , data.ch, 'Voltage');
eval(['data.session.addTriggerConnection(''external'', ''' data.dev '/PFI0'', ''StartTrigger'');'])
data.session.TriggersPerRun = Inf;
data.session.ExternalTriggerTimeout = Inf;
for loop = 1:length(data.ch)
    %Valid values are 'Differential', 'SingleEnded', 'SingleEndedNonReferenced', 'PseudoDifferential'
    data.session.Channels(loop).TerminalConfig = 'Differential';
    % Valid inputs are [-10 10], [-5 5],[-1 1];[-.2 .2]
    data.session.Channels(loop).Range = [-.2 .2];
end
% data.session.Channels.TerminalConfig = 'Differential'; 
% data.session.Channels.Range = [-5 5]; 
data.session.IsContinuous = false;
% set(data.session,'SamplesPerTrigger',Inf);
data.session.Rate = 250000/length(data.ch);

% data.xlim = [0 1];
selection = get(handles.time_scale,'Value');
switch selection
    case 1
        data.xlim = [0 1];
    case 2
        data.xlim = [0 0.5];
    case 3
        data.xlim = [0 0.25];
    case 4
        data.xlim = [0 0.1];
    case 5
        data.xlim = [0 0.05];
    case 6
        data.xlim = [0 0.02];
end
% data.ylim = [-inf inf];
selection = get(handles.volts_scale,'Value');
switch selection
    case 1
        data.ylim = [-inf inf];
    case 2
        data.ylim = [-1 1];
    case 3
        data.ylim = [-0.5 0.5];
    case 4
        data.ylim = [-0.1 0.1];
end

% plot prelim data
data.xgrad = plot(handles.xgrad_ax,linspace(0,1,data.session.NumberOfScans),zeros(1,data.session.NumberOfScans),'r');
data.ygrad = plot(handles.ygrad_ax,linspace(0,1,data.session.NumberOfScans),zeros(1,data.session.NumberOfScans),'g');
data.zgrad = plot(handles.zgrad_ax,linspace(0,1,data.session.NumberOfScans),zeros(1,data.session.NumberOfScans),'m');
data.RF = plot(handles.RF_ax,linspace(0,1,data.session.NumberOfScans),zeros(1,data.session.NumberOfScans),'k');

% set axis limits
axis(handles.xgrad_ax,[data.xlim data.ylim]);
axis(handles.ygrad_ax,[data.xlim data.ylim]);
axis(handles.zgrad_ax,[data.xlim data.ylim]);
axis(handles.RF_ax,[data.xlim data.ylim]);

unused_ch = ismember(0:3,data.ch);
for ch = 0:3
    if unused_ch(ch+1)==0
        switch ch
            case 0
                set(handles.xgrad_ax,'Visible','off');
                set(handles.text2,'BackgroundColor','r');
                set(data.xgrad,'Visible','off');
            case 1
                set(handles.ygrad_ax,'Visible','off');
                set(handles.text3,'BackgroundColor','r');
                set(data.ygrad,'Visible','off');
            case 2
                set(handles.zgrad_ax,'Visible','off');
                set(handles.text4,'BackgroundColor','r');
                set(data.zgrad,'Visible','off');
            case 3
                set(handles.RF_ax,'Visible','off');
                set(handles.text5,'BackgroundColor','r');
                set(data.RF,'Visible','off');
        end
    else
        switch ch
            case 0
                set(handles.xgrad_ax,'Visible','on');
                set(handles.text2,'BackgroundColor','g');
                set(data.xgrad,'Visible','on');
            case 1
                set(handles.ygrad_ax,'Visible','on');
                set(handles.text3,'BackgroundColor','g');
                set(data.ygrad,'Visible','on');
            case 2
                set(handles.zgrad_ax,'Visible','on');
                set(handles.text4,'BackgroundColor','g');
                set(data.zgrad,'Visible','on');
            case 3
                set(handles.RF_ax,'Visible','on');
                set(handles.text5,'BackgroundColor','g');
                set(data.RF,'Visible','on');
        end
    end
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simple_scope wait for user response (see UIRESUME)
% uiwait(handles.figure1);
    

% --- Outputs from this function are returned to the command line.
function varargout = simple_scope_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in DAQsetup_button.
function DAQsetup_button_Callback(hObject, eventdata, handles)
% hObject    handle to DAQsetup_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data

data.session.stop();
% data.session.release();
if isfield(data, 'lh')
    delete(data.lh);
end


set(handles.DAQsetup_button,'Enable','off')
set(handles.time_scale,'Enable','off')
set(handles.volts_scale,'Enable','off')
set(handles.run_button,'Enable','off')

h = setupDAQ;
uiwait(h);

set(handles.DAQsetup_button,'Enable','on')
set(handles.time_scale,'Enable','on')
set(handles.volts_scale,'Enable','on')
set(handles.run_button,'Enable','on')

% Zero lines of channels that are not being used. Program assumes channel 1
% is Xgrad, 2 is Ygrad, etc.
tm = linspace(0,1,250000)';
v = zeros(250000,1);
unused_ch = ismember(0:3,data.ch);
for ch = 0:3
    if unused_ch(ch+1)==0
        switch ch
            case 0
                set(data.xgrad,'Xdata',tm,'Ydata',v,'Visible','off');
                set(handles.xgrad_ax,'Visible','off');
                set(handles.text2,'BackgroundColor','r');
            case 1
                set(data.ygrad,'Xdata',tm,'Ydata',v,'Visible','off');
                set(handles.ygrad_ax,'Visible','off');
                set(handles.text3,'BackgroundColor','r');
            case 2
                set(data.zgrad,'Xdata',tm,'Ydata',v,'Visible','off');
                set(handles.zgrad_ax,'Visible','off');
                set(handles.text4,'BackgroundColor','r');
            case 3
                set(data.RF,'Xdata',tm,'Ydata',v,'Visible','off');
                set(handles.RF_ax,'Visible','off');
                set(handles.text5,'BackgroundColor','r');
        end
    else
        switch ch
            case 0
                set(handles.xgrad_ax,'Visible','on');
                set(handles.text2,'BackgroundColor','g');
                set(data.xgrad,'Visible','on');
            case 1
                set(handles.ygrad_ax,'Visible','on');
                set(handles.text3,'BackgroundColor','g');
                set(data.ygrad,'Visible','on');
            case 2
                set(handles.zgrad_ax,'Visible','on');
                set(handles.text4,'BackgroundColor','g');
                set(data.zgrad,'Visible','on');
            case 3
                set(handles.RF_ax,'Visible','on');
                set(handles.text5,'BackgroundColor','g');
                set(data.RF,'Visible','on');
        end
    end
end

% set(handles.run_button,'Value',1);
run_button_Callback(handles.run_button, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function DAQsetup_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DAQsetup_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in volts_scale.
function volts_scale_Callback(hObject, eventdata, handles)
% hObject    handle to volts_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data
% Hints: contents = cellstr(get(hObject,'String')) returns volts_scale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from volts_scale
selection = get(hObject,'Value');

switch selection 
    case 1
        data.ylim = [-inf inf];
    case 2
        data.ylim = [-1 1];
    case 3
        data.ylim = [-0.5 0.5];
    case 4
        data.ylim = [-0.1 0.1];
end

axis(handles.xgrad_ax,[data.xlim data.ylim*data.session.Channels(1).Range.Max]);
axis(handles.ygrad_ax,[data.xlim data.ylim*data.session.Channels(1).Range.Max]);
axis(handles.zgrad_ax,[data.xlim data.ylim*data.session.Channels(1).Range.Max]);
axis(handles.RF_ax,[data.xlim data.ylim*data.session.Channels(1).Range.Max]);

% GUI does not trigger after change in parameters unless run button is
% toggled. This code does that.
if get(handles.run_button,'Value')==1
    set(handles.run_button,'Value',0);
    run_button_Callback(handles.run_button, eventdata, handles);

    pause(0.1);

    set(handles.run_button,'Value',1);
    run_button_Callback(handles.run_button, eventdata, handles);
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function volts_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volts_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in time_scale.
function time_scale_Callback(hObject, eventdata, handles)
% hObject    handle to time_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data
% Hints: contents = cellstr(get(hObject,'String')) returns time_scale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from time_scale
selection = get(hObject,'Value');

switch selection
    case 1
        data.xlim = [0 1];
    case 2
        data.xlim = [0 0.5];
    case 3
        data.xlim = [0 0.25];
    case 4
        data.xlim = [0 0.1];
    case 5
        data.xlim = [0 0.05];
    case 6
        data.xlim = [0 0.02];
end

axis(handles.xgrad_ax,[data.xlim data.ylim*data.session.Channels(1).Range.Max]);
axis(handles.ygrad_ax,[data.xlim data.ylim*data.session.Channels(1).Range.Max]);
axis(handles.zgrad_ax,[data.xlim data.ylim*data.session.Channels(1).Range.Max]);
axis(handles.RF_ax,[data.xlim data.ylim*data.session.Channels(1).Range.Max]);

% GUI does not trigger after change in parameters unless run button is
% toggled. This code does that.
if get(handles.run_button,'Value')==1
    set(handles.run_button,'Value',0);
    run_button_Callback(handles.run_button, eventdata, handles);

    pause(0.1);

    set(handles.run_button,'Value',1);
    run_button_Callback(handles.run_button, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function time_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data 

data.session.stop();
if isfield(data, 'lh')
    delete(data.lh);
end
data.session.inputSingleScan;

state = get(hObject,'Value');

switch state
    case 1
        set(handles.export_traces,'Enable','off');
        
        time = max(data.xlim);
        data.delay = str2double(get(handles.delay_box,'String'))/1000;
        data.session.DurationInSeconds = time + data.delay;

        data.tm = linspace(0,data.session.DurationInSeconds,data.session.NumberOfScans)';
    %     data.v = zeros(data.session.NumberOfScans,length(data.ch));
        data.v=[];

    %     % Plot initial zero line
    %     set(data.xgrad,'Xdata',data.tm,'Ydata',data.v(:,1));
    %     set(data.ygrad,'Xdata',data.tm,'Ydata',data.v(:,1));
    %     set(data.zgrad,'Xdata',data.tm,'Ydata',data.v(:,1));
    %     set(data.RF,'Xdata',data.tm,'Ydata',data.v(:,1));

    %     data.lh = data.session.addlistener('DataAvailable', @(src,event) ...
    %          plot(handles.xgrad_ax,linspace(0,(length(event.Data)-1)/data.session.Rate,length(event.Data)),event.Data));
    %     set(data.xgrad,'Xdata',linspace(0,(length(event.Data)-1)/data.session.Rate,length(event.Data)),'Ydata',event.Data));
        data.lh = data.session.addlistener('DataAvailable', @updatePlots);
        data.session.startBackground()
        set(hObject,'String','Stop');
%         if isempty(data.session.Connections)
%             % No trigger
            set(handles.scope_status,'String','Running','ForegroundColor','g');
%         else
%             % trigger
%             set(handles.scope_status,'String','Waiting for Trigger','ForegroundColor','g');
%         end

    case 0
        set(hObject,'String','Run');
        set(handles.scope_status,'String','Stopped','ForegroundColor','r');
        set(handles.export_traces,'Enable','on');
end


function delay_box_Callback(hObject, eventdata, handles)
% hObject    handle to delay_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delay_box as text
%        str2double(get(hObject,'String')) returns contents of delay_box as a double

% GUI does not trigger after change in parameters unless run button is
% toggled. This code does that.
if get(handles.run_button,'Value')==1
    set(handles.run_button,'Value',0);
    run_button_Callback(handles.run_button, eventdata, handles);

    pause(0.1);

    set(handles.run_button,'Value',1);
    run_button_Callback(handles.run_button, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function delay_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delay_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% function to update data
function updatePlots(src,event)
global data

% Append new data to array
data.v=[data.v; event.Data];

% The scan following a change still uses the old settings. Adjust length so
% no overflow
if length(data.v) > data.session.NumberOfScans
    data.v(1:end-data.session.NumberOfScans,:) = [];
end

% Have added a delay. Only plot data following the delay. Find index in time
% data that corresps to the end of the delay and plot from there on
ind = find(data.tm<=data.delay,1,'last');
if ind < length(data.v)
    for ch = 1:length(data.ch)
        switch ch
            case 1
                % set(data.xgrad,'Xdata',linspace(0,(length(event.Data)-1)/data.session.Rate,length(event.Data)),'Ydata',event.Data);
                set(data.xgrad,'Xdata',data.tm(1:length(data.v(ind+1:end,ch))),'Ydata',data.v(ind+1:end,ch));
            case 2
                set(data.ygrad,'Xdata',data.tm(1:length(data.v(ind+1:end,ch))),'Ydata',data.v(ind+1:end,ch));
            case 3
                set(data.zgrad,'Xdata',data.tm(1:length(data.v(ind+1:end,ch))),'Ydata',data.v(ind+1:end,ch));
            case 4
                set(data.RF,'Xdata',data.tm(1:length(data.v(ind+1:end,ch))),'Ydata',data.v(ind+1:end,ch));
        end
    end
end


% --- Executes on button press in export_traces.
function export_traces_Callback(hObject, eventdata, handles)
% hObject    handle to export_traces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data

traces = [];

% collect data
if strcmp(get(handles.xgrad_ax,'Visible'),'on')
    t = get(data.xgrad,'Xdata');
    traces = [traces; get(data.xgrad,'Ydata')];
end
if strcmp(get(handles.ygrad_ax,'Visible'),'on')
    t = get(data.ygrad,'Xdata');
    traces = [traces; get(data.ygrad,'Ydata')];
end
if strcmp(get(handles.zgrad_ax,'Visible'),'on')
    t = get(data.xgrad,'Xdata');
    traces = [traces; get(data.zgrad,'Ydata')];
end
if strcmp(get(handles.RF_ax,'Visible'),'on')
    t = get(data.xgrad,'Xdata');
    traces = [traces; get(data.RF,'Ydata')];
end

traces = [t; traces]';

[FileName,handles.export_PathName,filterindex] = uiputfile(...
    {'*.txt','Tab delimited text file (*.txt)';...
    '*.csv','Comma Separated Variable (*.csv)';...
    '*.mat','MAT-files (*.mat)';
    '*.*',  'All Files (*.*)'},...
    'Export traces as','traces.txt');

switch filterindex
    case 1
        % write header
        dlmwrite(fullfile(handles.export_PathName,FileName),...
            sprintf('Time\tX\tY\tZ\tRF'),'delimiter','\t','newline','pc');
        % write data
        dlmwrite(fullfile(handles.export_PathName,FileName),...
            traces,'delimiter','\t','newline','pc');
        
    case 2
        % write header
        dlmwrite(fullfile(handles.export_PathName,FileName),...
            sprintf('Time\tX\tY\tZ\tRF'),'delimiter',',','newline','pc');
        % write data
        dlmwrite(fullfile(handles.export_PathName,FileName),...
            traces,'delimiter',',','newline','pc');
        
    case 3
        % write data
        save(fullfile(handles.export_PathName,FileName),'traces');
        
    case 4
        % write header
        dlmwrite(fullfile(handles.export_PathName,FileName),...
            sprintf('Time\tX\tY\tZ\tRF'),'delimiter',' ','newline','pc');
        % write data
        dlmwrite(fullfile(handles.export_PathName,FileName),...
            traces,'delimiter',' ','newline','pc');
end

% Update handles structure
guidata(hObject, handles);