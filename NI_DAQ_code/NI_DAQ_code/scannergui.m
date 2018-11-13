function varargout = scannergui(varargin)
% SCANNERGUI Application M-file for scannergui.fig
%    FIG = SCANNERGUI launch scannerGUI GUI.
%    SCANNERGUI('callback_name', ...) invoke the named callback.
% Last Modified by MShusteff 17-Feb-2005
% Updated 12-Oct-2005 by MShusteff 
%           (added minor gridlines and solid major gridlines for Z-mod plotting)
% Updated 6-Oct-2006 by MShusteff 
%           (added 'save force curve' and fixed 'save image' buttons)

if nargin == 0  % LAUNCH GUI

	fighandle = openfig(mfilename,'reuse');  % create figure handle 
	HOOK = guihandles(fighandle);  % generate structure of all GUI object handles, and store in 'HOOK' 
    
    % Initialize default values for scanning parameters (stored in HOOK structure)
    HOOK.scansize = 6000; % set default scan size 6000 nm
    HOOK.scansens = 900; % set default scan sensitivity 950 nm/V
    HOOK.f_fastscan = 2; % set default fast scan freq. 2 Hz
    HOOK.numlines = 32; % set default # of lines is 32
    HOOK.imagedir = -1;  % default imaging diretion is downward
    HOOK.f_zmod = 2;  % default force spec. freq. is 2Hz
    HOOK.amp_zmod = 8; % default force spec. amplitude is 8 V;
    % a few variables will be globals, so their values can change while the continuous plot function runs 
    global filepath; filepath = 'C:\BioInst\data\newdata.txt';
    
    % ---------------------------------------------------------------------------
    % Initialize DAQ output parameters 
    HOOK.ao=analogoutput('nidaq',1); % create analog output object
    HOOK.AOchan=addchannel(HOOK.ao,[0:1]); % use channels DAC0OUT and DAC1OUT for output 
    %set(HOOK.ao,'SampleRate',20000);  % use max. possible output sample rate (20kHz)
    set(HOOK.ao,'SampleRate',100000);  % downstairs boards can do 1MHz; use 100kHz for sane vector length
    set(HOOK.ao,'TriggerType','Immediate'); % use immediate triggering (contolled by 'start' command)
    set(HOOK.ao, 'RepeatOutput',inf);
    HOOK.RealOutRate=get(HOOK.ao,'SampleRate'); % make sure we know what actual sample rate we're getting

    % Initialize DAQ input parameters
    HOOK.ai=analoginput('nidaq',1); % create analog input object
    HOOK.AIchan=addchannel(HOOK.ai,[1:3]);  %add channels 0 through 2 to it
    set(HOOK.ai.Channel,'InputRange',[-10 10]);  %otherwise defaults to [-5 5] on some machines 
    set(HOOK.ai,'InputType','NonReferencedSingleEnded');
    set(HOOK.ai,'TriggerType','Software');
    set(HOOK.ai,'TriggerChannel',HOOK.AIchan(2));  % trigger ch. is fast-scan {HW ch. 1 (SW ch. 2)}
    set(HOOK.ai,'TriggerCondition','Rising'); % default trigger is on rising waveform ('retrace')
    set(HOOK.ai,'TriggerConditionValue',0);
    set(HOOK.ai,'TriggerDelayUnits','Samples'); 
    
    guidata(fighandle, HOOK);  % store HOOK structure in application data
    
    % ------------------------------------------
    if (nargout > 0)  varargout{1} = fighandle;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
	try
		if (nargout) [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end
end

% ------SCAN SIZE---------------------------------------------------------
function varargout = IN_scansz_Callback(h, eventdata, HOOK, varargin)

scansz_in = str2double(get(h,'string')); %get  data and convert string to number
if isnan(scansz_in) errordlg('"Scan size" must be a numeric value','Bad Input','modal');
end;
HOOK.scansize = scansz_in;
guidata(h, HOOK);

% -----SCAN SENS----------------------------------------------------------
function varargout = IN_sens_Callback(h, eventdata, HOOK, varargin)

sens_in = str2double(get(h,'string')); %get  data and convert string to number
if isnan(sens_in) errordlg('"Scan sensitivity" must be a numeric value','Bad Input','modal');
end;
HOOK.scansens = sens_in;
guidata(h, HOOK);

% ------SCAN FREQ--------------------------------------------------------
function varargout = IN_fscan_Callback(h, eventdata, HOOK, varargin)

fscan_in = str2double(get(h,'string')); %get  data and convert string to number
if isnan(fscan_in) errordlg('"Scan frequency" must be a numeric value','Bad Input','modal');
end;
HOOK.f_fastscan = fscan_in;
guidata(h, HOOK)

% ------NUMLINES----------------------------------------------------------
function varargout = IN_nlines_Callback(h, eventdata, HOOK, varargin)

nlines_in = str2double(get(h,'string')); %get  data and convert string to number
if isnan(nlines_in) errordlg('"Number or lines" must be a numeric value','Bad Input','modal');
end;
HOOK.numlines = nlines_in;
guidata(h, HOOK);

% -----ZMOD FREQUENCY----------------------------------------------------------
function varargout = IN_fzmod_Callback(h, eventdata, HOOK, varargin)

fzmod_in = str2double(get(h,'string')); %get  data and convert string to number
if isnan(fzmod_in) errordlg('"Z-mod frequency" must be a numeric value','Bad Input','modal');
end;
HOOK.f_zmod = fzmod_in;
guidata(h, HOOK);

% -----ZMOD AMPLITUDE----------------------------------------------------------
function varargout = IN_ampzmod_Callback(h, eventdata, HOOK, varargin)

ampzmod_in = str2double(get(h,'string')); %get  data and convert string to number
if isnan(ampzmod_in) errordlg('"Z-mod amplitude" must be a numeric value','Bad Input','modal');
end;
HOOK.amp_zmod = ampzmod_in;
guidata(h, HOOK);

% ----- SET SAVE FILE PATH ---------------------------------------------------------
function varargout = IN_filepath_Callback(h, eventdata, HOOK, varargin)

global filepath;  % make local 'filepath' pointer to memory location of global
filepath = get(h,'string'); % get string from control
%fprintf(1,'\n Filepath is set to: %-50s', filepath);
clear filepath;  % delete local pointer (string remains in memory)
guidata(h, HOOK);

% ----- TRACE/RETRACE RADIO BUTTONS -------------------------------------------------
function varargout = IN_trace_Callback(h, eventdata, HOOK, varargin)
status = get(HOOK.ai,'Running');
if (status(2) == 'n')
    set(HOOK.IN_trace,'Value',0); set(HOOK.IN_retrace,'Value',1);
    errordlg('Can''t change scan direction while scan is running.  To set ""trace"" stop and restart scan.','Illegal action','modal');
else 
    set(HOOK.IN_retrace,'Value',0); set(HOOK.IN_trace,'Value',1);
    set(HOOK.ai,'TriggerCondition','Falling');
end;
guidata (h, HOOK);

function varargout = IN_retrace_Callback(h, eventdata, HOOK, varargin)
status = get(HOOK.ai,'Running');
if (status(2) == 'n') 
    set(HOOK.IN_retrace,'Value',0); set(HOOK.IN_trace,'Value',1);
    errordlg('Can''t change scan direction while scan is running.  To set ""retrace"" stop and restart scan.','Illegal action','modal');
else 
    set(HOOK.IN_trace,'Value',0); set(HOOK.IN_retrace,'Value',1);
    set(HOOK.ai,'TriggerCondition','Rising');
end;
guidata (h, HOOK);

% -----UPWARD/DOWNWARD SCAN RADIO BUTTONS -----------------------------------------------
function varargout = IN_upward_Callback(h, eventdata, HOOK, varargin)
set(HOOK.IN_downward,'Value',0); set(HOOK.IN_upward,'Value',1); 
HOOK.imagedir = 1;
guidata (h, HOOK);

function varargout = IN_downward_Callback(h, eventdata, HOOK, varargin)
set(HOOK.IN_upward,'Value',0); set(HOOK.IN_downward,'Value',1);
HOOK.imagedir = -1;
guidata (h, HOOK);

% -----SCAN BUTTON----------------------------------------------------------
function varargout = scanButton_Callback(h, eventdata, HOOK, varargin)

stop(HOOK.ai);  stop(HOOK.ao); % in case anything else happens to be going

clear global image;  % clear any existing image from memory
%clear global saveflag; global saveflag; saveflag = 'off'; % same with saveflag (keeps track of save status)

% HOOK.ai.UserData is used to store the number of the current scanline
% the initial value below is set by the peculiarities of triggering on trace or retrace
if (get(HOOK.IN_trace,'Value') == 1) HOOK.ai.UserData = 2;
else HOOK.ai.UserData = 1;
end;

HOOK.f_slowscan = HOOK.f_fastscan/(2*HOOK.numlines);  % calculate slow scan freq. from fast scan freq. & # lines
HOOK.scaling = HOOK.scansize/(HOOK.scansens*2); % calc. scaling voltage needed to drive desired scan size
HOOK.outtime = (0:(1/HOOK.RealOutRate):(1/HOOK.f_slowscan))';  % time vector, based on sampling freq.
Xwaveout=HOOK.scaling*sawtooth(2*pi*HOOK.f_fastscan*HOOK.outtime,0.5);
Ywaveout=HOOK.imagedir*HOOK.scaling*sawtooth(2*pi*HOOK.f_slowscan*HOOK.outtime,0.5);
putdata(HOOK.ao,[Xwaveout Ywaveout]);  % queue output waveforms to corresponding channels

HOOK.RealInRate=get(HOOK.ai,'SampleRate');
HOOK.numpoints = ceil(HOOK.RealInRate*1/(2*HOOK.f_fastscan));  % makes all lines of image the same length

global image; image = zeros(HOOK.numpoints,HOOK.numlines);  % initialize image 

set(HOOK.ai,'TriggerDelay',0.2*HOOK.RealInRate*(1/(HOOK.f_fastscan)));
set(HOOK.ai,'SamplesPerTrigger',0.6*HOOK.RealInRate*(1/(HOOK.f_fastscan)));
set(HOOK.ai,'TriggerRepeat',inf); % keep taking data ad infinitum
set(HOOK.ai,'TriggerFcn', {@CONTscan_Callback, HOOK});  % every trigger event, call this function

start(HOOK.ao); start(HOOK.ai);  % start everything going

guidata (h, HOOK);  % re-save HOOK structure 

% ------ CONTINUOUS SCAN PLOTTING -----------------------------------
function CONTscan_Callback(ai, event, HOOK)

if (HOOK.ai.SamplesAvailable > HOOK.ai.SamplesPerTrigger) % this ensures there's always enough data in buffer 
    dataline=getdata(HOOK.ai);  % grab chunk of data from DAQ input buffer (SamplesPerTrigger long)
    fastscanline=dataline(:,2);  % take 2nd column of data  - fast scan (trigger) channel
    slowscanline=dataline(:,3); % take slow scan channel
    
    % check slope of slow scan to see if we're going up or down - increment line index accordingly
    if (mean(slowscanline(1:25)) - mean(slowscanline(end-25:end)) < 0) imgind = HOOK.ai.UserData; % if slope negative (going upward), index image forwards
    else  imgind = HOOK.numlines - HOOK.ai.UserData + 1;   % if going downward, index going backwards
    end;
    
    global image; % pointer to global image variable (already exists and contains previous data)
    
    if (get(HOOK.IN_trace,'Value') == 1)
        [peak,Ipeak]=min(fastscanline); % if using 'retrace' data, find MIN point of fast-scan waveform
        image(:,imgind)=dataline(Ipeak:(Ipeak+HOOK.numpoints-1),1); % grab numpoints of data after MIN point
    else
        [peak,Ipeak]=max(fastscanline); % if using 'trace' data, find MAX point of fast-scan waveform
        image(:,imgind)=dataline(Ipeak:(Ipeak+HOOK.numpoints-1),1); % grab numpoints of data after MAX point
        image(:,imgind)=flipud(image(:,imgind)); % reverse order of each line so image looks same as for 'trace' direction
    end;

% the next block plots the image updated with the current line of data on the GUI figures
% for plots to appear correctly, 'HandleVisibility' for each (axes) must be set to 'on' not 'callback'
    foo=1:1:HOOK.numpoints;
    axes(HOOK.data_axes);
    plot(foo,image(:,imgind)); grid;
    axes(HOOK.scans_axes);
    plot(foo,dataline(Ipeak:(Ipeak+HOOK.numpoints-1),2),foo,dataline(Ipeak:(Ipeak+HOOK.numpoints-1),3)); grid;
    % plot image surface (use transpose for correct orientation) and set color properties 
    axes(HOOK.image_axes);  colormap(copper);
    set(surf(image'),'EdgeColor','none','FaceColor','interp');
    view(2); axis ([1 HOOK.numpoints 1 HOOK.numlines]);
    
    % global saveflag;  % access memory locations containing filepath and saveflag 
    clear image;
    if (HOOK.ai.UserData >= HOOK.numlines) HOOK.ai.UserData = 1; % check if reached edge of image
    else HOOK.ai.UserData = HOOK.ai.UserData + 1; %increment line counter
    end;
    
% the next block deals with saving image data, doing flag manipulation and writing data to file
%     if (HOOK.ai.UserData >= HOOK.numlines) HOOK.ai.UserData = 1; % check if reached edge of image
%         if saveflag == 'set' saveflag = 'sav';  % if "save" button was pressed, set flag to "save" mode at start of image
%             fprintf(1,'\n Saving Current Image to File: %-50s', filepath);
%         elseif saveflag == 'sav' % if flag is in "save" mode, full image ready to be written
%             
%             fileID = fopen(filepath,'w'); % open file for writing, 'fileID' is handle
%             for ind = 1:1:HOOK.numpoints
%                 fprintf(fileID, '%g ' ,image(ind,:)); %write data, line by line
%                 fprintf(fileID, '\n');
%             end;
%             fclose(fileID); saveflag = 'off';  % close file, reset saveflag
%             fprintf(1,'\n Image Data Written to File: %-50s \n', filepath);
%         else saveflag = 'off';
%         end;
%     else HOOK.ai.UserData = HOOK.ai.UserData + 1;  % if in middle of image, just increment line counter
%     end;
end;

% -----SAVE BUTTON ------------------------------------------------
function varargout = saveButton_Callback(h, eventdata, HOOK, varargin)

global image; %access previous image data pointer (data already stored in the global variable)
global filepath;
sz=max(HOOK.numpoints, HOOK.numlines);
OUTimage = imresize(image',[sz sz],'bilinear'); %make the matrix square (interpolate)
dlmwrite (filepath, OUTimage, 'newline','pc');
clear filepath;
clear image;
guidata (h,HOOK);

% ------ SAVE FORCE CURVE DATA --------------------------------------------
function varargout= FCsaveButton_Callback(h, eventdata, HOOK, varargin)

global Fcurve;
global filepath;
OUTdata = Fcurve;
dlmwrite (filepath, OUTdata, 'newline','pc');
clear filepath;
clear Fcurve;
guidata (h,HOOK);

% -----ZMOD BUTTON----------------------------------------------------------
function varargout = zmodButton_Callback(h, eventdata, HOOK, varargin)

clear global Fcurve; % clears anything pre-existing force curve data

stop(HOOK.ai); % stop any data acq. in progress
stop(HOOK.ao); % stop any data output in progress

HOOK.outtime = (0:(1/HOOK.RealOutRate):(1/HOOK.f_zmod))';  % time vector, based on sampling freq.
set(HOOK.ao, 'RepeatOutput',inf);
BOTHwaveout=HOOK.amp_zmod*sin(2*pi*HOOK.f_zmod*HOOK.outtime);
putdata(HOOK.ao,[BOTHwaveout BOTHwaveout]);  % queue identical outputs to both output channels

HOOK.RealInRate=get(HOOK.ai,'SampleRate');

set(HOOK.ai,'SamplesPerTrigger',HOOK.RealInRate*(1/(HOOK.f_zmod)));
set(HOOK.ai,'TriggerRepeat',inf); % keep doing this ad infinitum
set(HOOK.ai,'TriggerFcn', {@ZMODplot_Callback, HOOK});

global Fcurve; Fcurve = zeros(2,HOOK.ai.SamplesPerTrigger);
clear Fcurve;

start(HOOK.ao);
start(HOOK.ai);
guidata(h,HOOK);

% ------ FORCE-CURVE CONTINUOUS PLOTTING -----------------------------------
function ZMODplot_Callback(ai, event, HOOK)

if (HOOK.ai.SamplesAvailable > HOOK.ai.SamplesPerTrigger) % this ensures there's always enough data in buffer 
    dataline=getdata(HOOK.ai);  % grab one chunk of data from DAQ input buffer (SamplesPerTrigger long)
    xdata=dataline(:,3);  % take 2nd column of data  - fast scan (trigger) channel
    ydata=dataline(:,1);  % 1st data column is cantilever deflection
    
    axes(HOOK.image_axes);
    plot(xdata,ydata);  % do an X-Y plot of the two vectors
    grid; set(HOOK.image_axes,'GridLineStyle','-'); grid minor;
    xlim([-1.25*HOOK.amp_zmod 1.25*HOOK.amp_zmod]);
    
    global Fcurve; Fcurve = [xdata ydata];
    clear Fcurve; %release pointer
    %fprintf (1,'-xmin %6.3g xmax %6.3g \n',min(xdata),max(xdata));
end;


% ------STOP BUTTON--------------------------------------------------------
function varargout = stopButton_Callback(h, eventdata, HOOK, varargin)
% function stops any data I/O in progress and zeros the output channels by outputting zero vectors

stop(HOOK.ao);  % stop any data output in progress
stop(HOOK.ai);  % stop any data acquisition in progress

time = (0:1/HOOK.RealOutRate:0.1)';

set(HOOK.ao, 'RepeatOutput',0);  % set output data to be sent only once
zerodata = zeros (length(time),1);  % create zero vector 
putdata(HOOK.ao,[zerodata zerodata]);  % queue zero vectors on output channels

start(HOOK.ao); % send zero vectors to output channels
waittilstop(HOOK.ao,0.5); stop(HOOK.ao); % stop any data output just for good measure
set(HOOK.ao, 'RepeatOutput',inf); % set output repeat back to infinity for scan functions

guidata(h,HOOK);


% fprintf ('%15s %5g \n', 'and after: ', HOOK.ai.SamplesAvailable)
% fprintf ('\n %20g %10g %10g %10g %10g %10g', size(image,1), size(image,2), HOOK.ai.UserData, Ipeak, HOOK.numpoints, size(dataline,1));

%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HOOK, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HOOK is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. HOOK.figure1, HOOK.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, HOOK) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.
