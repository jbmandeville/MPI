% Code for setting up/using DAQ
% Our device is the NI USB-6211
% Documentation available online at http://sine.ni.com/psp/app/doc/p/id/psp-96/lang/en
clear all

%% In Matlab, must first create session
s = daq.createSession('ni');

% Next, add device
device = daq.getDevices;
dev = strfind(device.Model,'USB-6211');

% Now add acquisition channel(s)
s.addAnalogInputChannel(device(dev).ID, 0, 'Voltage');
s.Channels.TerminalConfig = 'Differential'; %Valid values are 'Differential', 'SingleEnded', 'SingleEndedNonReferenced', 'PseudoDifferential'
s.Channels.Range = [-10 10]; % Valid inputs are [-10 10], [-5 5],[-1 1];[-.2 .2]

% Add external trigger
% s.addTriggerConnection('external',['''' device(dev).ID '/PFI1'''],'StartTrigger')
s.addTriggerConnection('external','Dev1/PFI0','StartTrigger');
s.TriggersPerRun = Inf;
% set(s,'TriggersPerRun',Inf);
s.ExternalTriggerTimeout = Inf;

% scan settings
s.IsContinuous = false;
s.Rate = 250000;

% Visualize data
lh = s.addlistener('DataAvailable', @(src,event) plot(event.Data));

s.startBackground()

%% stop execution
s.stop();
s.release();
delete(lh);