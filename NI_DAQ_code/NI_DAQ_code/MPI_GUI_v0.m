function varargout = MPI_GUI_v0(varargin)

gui_Singleton = 1;
% gui_State = struct('gui_Name',       mfilename, ...
%                    'gui_Singleton',  gui_Singleton, ...
%                    'gui_OpeningFcn', @MPI_GUI_v0_OpeningFcn, ...
%                    'gui_OutputFcn',  @MPI_GUI_v0_OutputFcn, ...
%                    'gui_LayoutFcn',  [] , ...
%                    'gui_Callback',   []);
% if nargin && ischar(varargin{1})
%     gui_State.gui_Callback = str2func(varargin{1});
% end
% 
% if nargout
%     [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
% else
%     gui_mainfcn(gui_State, varargin{:});
% end

    fighandle = openfig('MPI_GUI_V0.fig','reuse');  % create figure handle 
	HOOK = guihandles(fighandle);  % generate structure of all GUI object handles, and store in 'HOOK' 
    
%     % Initialize default values for scanning parameters (stored in HOOK structure)
%     HOOK.scansize = 6000; % set default scan size 6000 nm
%     HOOK.scansens = 900; % set default scan sensitivity 950 nm/V
%     HOOK.f_fastscan = 2; % set default fast scan freq. 2 Hz
%     HOOK.numlines = 32; % set default # of lines is 32
%     HOOK.imagedir = -1;  % default imaging diretion is downward
%     HOOK.f_zmod = 2;  % default force spec. freq. is 2Hz
%     HOOK.amp_zmod = 8; % default force spec. amplitude is 8 V;
    % a few variables will be globals, so their values can change while the continuous plot function runs 
d  = daq.getDevices;
devID = d(1).ID;
HOOK.s = daq.createSession('ni');
% HOOK.s = s;
HOOK.s.Rate = 500e3;

HOOK.ao0 = HOOK.s.addAnalogOutputChannel(devID, 0, 'Voltage');
HOOK.ao1 = HOOK.s.addAnalogOutputChannel(devID, 1, 'Voltage');
                 
HOOK.ch1 = HOOK.s.addAnalogInputChannel(devID, 0, 'Voltage');
HOOK.ch1.Range = [-10,10];
HOOK.ch1.TerminalConfig = 'SingleEnded';

HOOK.ch2 = HOOK.s.addAnalogInputChannel(devID, 4, 'Voltage');
HOOK.ch2.Range = [-10,10];
HOOK.ch2.TerminalConfig = 'SingleEnded';
% HOOK.RealOutRate=HOOK.s.Rate;

    
    
    HOOK.amp = 2;
    HOOK.numaveset = 1;
    HOOK.pausetime = .1;
    HOOK.drive_freq =25e3;
    HOOK.pw = 50/HOOK.drive_freq;    
    HOOK.blocksize = duration*HOOK.s.Rate;
    HOOK.time = [0:1/HOOK.s.Rate:HOOK.pw];
    output_data_temp = 1*HOOK.amp*sin(2*pi*HOOK.drive_freq*HOOK.time).';
    HOOK.output_data =[output_data_temp, zeros(size(output_data_temp))];


   %%%%taken from simulataneous_output_input_8_19

%     
%     % ---------------------------------------------------------------------------
%     % Initialize DAQ output parameters 
%     HOOK.ao=analogoutput('nidaq',1); % create analog output object
%     HOOK.AOchan=addchannel(HOOK.ao,[0:1]); % use channels DAC0OUT and DAC1OUT for output 
%     %set(HOOK.ao,'SampleRate',20000);  % use max. possible output sample rate (20kHz)
%     set(HOOK.ao,'SampleRate',100000);  % downstairs boards can do 1MHz; use 100kHz for sane vector length
%     set(HOOK.ao,'TriggerType','Immediate'); % use immediate triggering (contolled by 'start' command)
%     set(HOOK.ao, 'RepeatOutput',inf);
%     HOOK.RealOutRate=get(HOOK.ao,'SampleRate'); % make sure we know what actual sample rate we're getting
% 
%     % Initialize DAQ input parameters
%     HOOK.ai=analoginput('nidaq',1); % create analog input object
%     HOOK.AIchan=addchannel(HOOK.ai,[1:3]);  %add channels 0 through 2 to it
%     set(HOOK.ai.Channel,'InputRange',[-10 10]);  %otherwise defaults to [-5 5] on some machines 
%     set(HOOK.ai,'InputType','NonReferencedSingleEnded');
%     set(HOOK.ai,'TriggerType','Software');
%     set(HOOK.ai,'TriggerChannel',HOOK.AIchan(2));  % trigger ch. is fast-scan {HW ch. 1 (SW ch. 2)}
%     set(HOOK.ai,'TriggerCondition','Rising'); % default trigger is on rising waveform ('retrace')
%     set(HOOK.ai,'TriggerConditionValue',0);
%     set(HOOK.ai,'TriggerDelayUnits','Samples'); 
%     
    guidata(fighandle, HOOK);  % store HOOK structure in application data
    
% End initialization code - DO NOT EDIT


% % --- Executes just before MPI_GUI_v0 is made visible.
% function MPI_GUI_v0_OpeningFcn(hObject, eventdata, handles, varargin)
% 
% 
% % This function has no output args, see OutputFcn.
% % hObject    handle to figure
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % varargin   command line arguments to MPI_GUI_v0 (see VARARGIN)
% 
% 
% 
% % Choose default command line output for MPI_GUI_v0
% handles.output = hObject;
% 
% % Update handles structure
% guidata(hObject, handles);
% 
% initialize_gui(hObject, handles, false);


% --------------------------------------------------------------------
% function initialize_gui(fig_handle, handles, isreset, hObject)
% 
% handles.output = hObject;
% 
% 
% %%%%taken from simulataneous_output_input_8_19
% v = daq.getVendors;
% d  = daq.getDevices;
% s = daq.createSession(v.ID);
% s.Rate = 500e3;
% 
% s.addAnalogOutputChannel(d(1).ID, 0, 'Voltage');
% s.addAnalogOutputChannel(d(1).ID, 1, 'Voltage');
%                  
% ch1 = s.addAnalogInputChannel(d(1).ID, 0, 'Voltage');
% ch1.Range = [-10,10];
% ch1.TerminalConfig = 'SingleEnded';
% 
% ch2 = s.addAnalogInputChannel(d(1).ID, 4, 'Voltage');
% ch2.Range = [-10,10];
% ch2.TerminalConfig = 'SingleEnded';
% 
% 
% 
% %%%USER INPUT%%%%%%%%%%%%%%
% amp = 2;
% numaveset = 1;
% pausetime = .1;
% 
% 
% %% NI-DAQ output
%     drive_freq =25e3;
%     pw = 50/drive_freq;    
%     blocksize = duration*s.Rate;
%     time = [0:1/s.Rate:pw];
%     output_data_temp = 1*amp*sin(2*pi*drive_freq*time).';
%     
%    handles.pulseparams.amp = amp;
%    handles.pulseparams.pw = pw;
%    handles.pulseparams.blocksize = blocksize;
%    handles.pulseparams.time = time;
%    handles.pulseparams.drive_freq = drive_freq;
%    
% output_data = [output_data_temp, zeros(size(output_data_temp))];
% 
% guidata(hObject, handles);




% --- Outputs from this function are returned to the command line.
function varargout = MPI_GUI_v0_OutputFcn(h, eventdata, HOOK) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in run_button_tag.
function run_button_tag_Callback(h, eventdata, HOOK)

amp = HOOK.pulseparams.amp;
% s = handles.s;
pw = HOOK.pulseparams.pw;
% amp = pulseparams.amp;
drive_freq = HOOK.pulseparams.drive_freq;

% hObject    handle to run_button_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(HOOK.acq_data_fig);

% while stopbuttonpressed ==  0 
    
    queueOutputData(HOOK.s, HOOK.output_data);
    [captured_data] = HOOK.s.startForeground();
    data = captured_data(2:end,:)
    
    subplot(3,1,1);
   
    amplitude = (max(data(end/4:end,1))-min(data(end/2:end,1)))/2;
    plot(time(2:end), data(:,1));
    xlabel('time (s)');
    
    text(.8*max(time),0, ['amplitude = ', num2str(amplitude)]);
    title(['Acquired signal (duration = ',num2str(pw),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
 guidata(h, HOOK); 




% --- Executes on button press in stop_button_tag.
function stop_button_tag_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
