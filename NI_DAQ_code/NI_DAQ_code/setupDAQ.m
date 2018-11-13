function varargout = setupDAQ(varargin)
% SETUPDAQ MATLAB code for setupDAQ.fig
%      SETUPDAQ, by itself, creates a new SETUPDAQ or raises the existing
%      singleton*.
%
%      H = SETUPDAQ returns the handle to a new SETUPDAQ or the handle to
%      the existing singleton*.
%
%      SETUPDAQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETUPDAQ.M with the given input arguments.
%
%      SETUPDAQ('Property','Value',...) creates a new SETUPDAQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before setupDAQ_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to setupDAQ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help setupDAQ

% Last Modified by GUIDE v2.5 19-Jan-2013 16:48:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @setupDAQ_OpeningFcn, ...
                   'gui_OutputFcn',  @setupDAQ_OutputFcn, ...
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


% --- Executes just before setupDAQ is made visible.
function setupDAQ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to setupDAQ (see VARARGIN)
global data

% Populate device menu
set(handles.SelectDevice,'String',data.devices.Description)
set(handles.SelectDevice,'Value',data.selection)
set(handles.SamplingRate,'String',num2str(data.session.Rate*length(data.ch)))
switch data.session.Channels(1).Range.Max
    case 10
        set(handles.Range,'Value',1)
    case 5
        set(handles.Range,'Value',2)
    case 1
        set(handles.Range,'Value',3)
    case 0.2
        set(handles.Range,'Value',4)
end

if strcmpi(data.session.Channels(1).TerminalConfig, 'Differential')
    set(handles.Differential_rb,'Value',1)
    mode_panel_SelectionChangeFcn(handles.Differential_rb, eventdata, handles)
elseif strcmpi(data.session.Channels(1).TerminalConfig, 'SingleEnded')
    set(handles.SingleEnded_rb,'Value',1)
    mode_panel_SelectionChangeFcn(handles.SingleEnded_rb, eventdata, handles)
end

for loop = 1:length(data.ch)
    eval(['set(handles.' data.session.Channels(loop).ID '_cb,''Value'',1)']);
end

if size(data.session.Connections,2)==0
    set(handles.trigger_off,'Value',1);
    handles.Tr = false;
    
    set(handles.TrCh0,'Enable','off');
    set(handles.TrCh1,'Enable','off');
    set(handles.TrCh2,'Enable','off');
    set(handles.TrCh3,'Enable','off');
else
    set(handles.trigger_on,'Value',1);
    handles.Tr = true;
    
    handles.TrCh = data.session.Connections.Destination(end-3:end);
    switch handles.TrCh
        case 'PFI0'
            set(handles.TrCh0,'Value',1);
        case 'PFI1'
            set(handles.TrCh1,'Value',1);
        case 'PFI2'
            set(handles.TrCh2,'Value',1);
        case 'PFI3'
            set(handles.TrCh3,'Value',1);
    end
end

% Choose default command line output for setupDAQ
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes setupDAQ wait for user response (see UIRESUME)
% uiwait(handles.setupDAQ_fig);


% --- Outputs from this function are returned to the command line.
function varargout = setupDAQ_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ai0_cb.
function ai0_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai0_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai0_cb


% --- Executes on button press in ai1_cb.
function ai1_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai1_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai1_cb


% --- Executes on button press in ai2_cb.
function ai2_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai2_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai2_cb


% --- Executes on button press in ai3_cb.
function ai3_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai3_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai3_cb


% --- Executes on button press in ai4_cb.
function ai4_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai4_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai4_cb


% --- Executes on button press in ai5_cb.
function ai5_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai5_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai5_cb


% --- Executes on button press in ai6_cb.
function ai6_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai6_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai6_cb


% --- Executes on button press in ai7_cb.
function ai7_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai7_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai7_cb


% --- Executes on button press in ai8_cb.
function ai8_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai8_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai8_cb


% --- Executes on button press in ai9_cb.
function ai9_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai9_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai9_cb


% --- Executes on button press in ai10_cb.
function ai10_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai10_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai10_cb


% --- Executes on button press in ai11_cb.
function ai11_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai11_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai11_cb


% --- Executes on button press in ai12_cb.
function ai12_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai12_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai12_cb


% --- Executes on button press in ai13_cb.
function ai13_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai13_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai13_cb


% --- Executes on button press in ai14_cb.
function ai14_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai14_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai14_cb


% --- Executes on button press in ai15_cb.
function ai15_cb_Callback(hObject, eventdata, handles)
% hObject    handle to ai15_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai15_cb



function SamplingRate_Callback(hObject, eventdata, handles)
% hObject    handle to SamplingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data
% Hints: get(hObject,'String') returns contents of SamplingRate as text
%        str2double(get(hObject,'String')) returns contents of SamplingRate as a double
rate = str2double(get(hObject,'String'));
if ~(abs(rate) <= 250000)
    set(hObject,'String','250000');
end

% --- Executes during object creation, after setting all properties.
function SamplingRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SamplingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SelectDevice.
function SelectDevice_Callback(hObject, eventdata, handles)
% hObject    handle to SelectDevice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data
% Hints: contents = cellstr(get(hObject,'String')) returns SelectDevice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectDevice
data.selection = get(hObject,'Value');

data.dev = data.devices(selection).ID;


% --- Executes during object creation, after setting all properties.
function SelectDevice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectDevice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Range.
function Range_Callback(hObject, eventdata, handles)
% hObject    handle to Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Range contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Range


% --- Executes during object creation, after setting all properties.
function Range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in mode_panel.
function mode_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in mode_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if strcmpi(get(hObject,'Tag'),'Differential_rb')
    set(handles.ai8_cb,'Enable','off','Value',0)
    set(handles.ai9_cb,'Enable','off','Value',0)
    set(handles.ai10_cb,'Enable','off','Value',0)
    set(handles.ai11_cb,'Enable','off','Value',0)
    set(handles.ai12_cb,'Enable','off','Value',0)
    set(handles.ai13_cb,'Enable','off','Value',0)
    set(handles.ai14_cb,'Enable','off','Value',0)
    set(handles.ai15_cb,'Enable','off','Value',0)
elseif strcmpi(get(hObject,'Tag'),'SingleEnded_rb')
    set(handles.ai8_cb,'Enable','on')
    set(handles.ai9_cb,'Enable','on')
    set(handles.ai10_cb,'Enable','on')
    set(handles.ai11_cb,'Enable','on')
    set(handles.ai12_cb,'Enable','on')
    set(handles.ai13_cb,'Enable','on')
    set(handles.ai14_cb,'Enable','on')
    set(handles.ai15_cb,'Enable','on')
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data

switch get(handles.Range,'Value')
    case 1
        input_range = [-10 10];
    case 2
        input_range = [-5 5];
    case 3
        input_range = [-1 1];
    case 4
        input_range = [-.2 .2];
end

Channel = [get(handles.ai0_cb,'Value') get(handles.ai1_cb,'Value') get(handles.ai2_cb,'Value')...
    get(handles.ai3_cb,'Value') get(handles.ai4_cb,'Value') get(handles.ai5_cb,'Value')...
    get(handles.ai6_cb,'Value') get(handles.ai7_cb,'Value') get(handles.ai8_cb,'Value')...
    get(handles.ai9_cb,'Value') get(handles.ai10_cb,'Value') get(handles.ai11_cb,'Value')...
    get(handles.ai12_cb,'Value') get(handles.ai13_cb,'Value') get(handles.ai14_cb,'Value')...
    get(handles.ai15_cb,'Value')];

if size(data.session.Connections,2) > 0
    data.session.removeConnection(1);
end
data.session.removeChannel(1:length(data.ch))
data.ch = find(Channel)-1;

data.session.Rate = str2double(get(handles.SamplingRate,'String'))/length(data.ch);

if get(handles.SingleEnded_rb,'Value')
    mode = 'SingleEnded';
elseif get(handles.Differential_rb,'Value')    
    mode = 'Differential';
end

data.session.addAnalogInputChannel(data.dev, [data.ch], 'Voltage');

for loop = 1:length(data.ch)
    data.session.Channels(loop).TerminalConfig = mode;
    data.session.Channels(loop).Range = input_range;
end

% Setup Trigger
if handles.Tr
    eval(['data.session.addTriggerConnection(''external'', ''' data.dev '/' handles.TrCh ''', ''StartTrigger'');'])
%     set(data.session,'TriggerRepeat',Inf)
    data.session.TriggersPerRun = Inf;
    data.session.ExternalTriggerTimeout = Inf;
end

delete(handles.setupDAQ_fig)


% --- Executes on button press in trigger_on.
function trigger_on_Callback(hObject, eventdata, handles)
% hObject    handle to trigger_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trigger_on


% --- Executes on button press in trigger_off.
function trigger_off_Callback(hObject, eventdata, handles)
% hObject    handle to trigger_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trigger_off


% --- Executes when selected object is changed in Trigger_panel.
function Trigger_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Trigger_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global data

if strcmpi(get(hObject,'Tag'),'trigger_on')
    handles.Tr = true;
    set(handles.TrCh0,'Enable','on');
    set(handles.TrCh1,'Enable','on');
    set(handles.TrCh2,'Enable','on');
    set(handles.TrCh3,'Enable','on');
elseif strcmpi(get(hObject,'Tag'),'trigger_off')
    try
        data.session.removeConnection(1);
    end
    handles.Tr = false;
    set(handles.TrCh0,'Enable','off');
    set(handles.TrCh1,'Enable','off');
    set(handles.TrCh2,'Enable','off');
    set(handles.TrCh3,'Enable','off');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes when selected object is changed in TriggerCh_panel.
function TriggerCh_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in TriggerCh_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if strcmpi(get(hObject,'Tag'),'TrCh0')
    handles.TrCh = 'PFI0';
elseif strcmpi(get(hObject,'Tag'),'TrCh1')
    handles.TrCh = 'PFI1';
elseif strcmpi(get(hObject,'Tag'),'TrCh2')
    handles.TrCh = 'PFI2';
elseif strcmpi(get(hObject,'Tag'),'TrCh3')
    handles.TrCh = 'PFI3';
end

% Update handles structure
guidata(hObject, handles);
