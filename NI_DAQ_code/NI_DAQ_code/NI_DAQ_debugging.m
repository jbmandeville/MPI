close all
clear all

% communicating with NI USB-6229 DAQ (16 bit, 250 KS/s)
% Driver from http://www.ni.com/download/ni-daqmx-9.9/4707/en/

v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);

addAnalogOutputChannel(s,d(1).ID,0,'Voltage');
addAnalogOutputChannel(s,d(1).ID,1,'Voltage');

s.Rate = 250000;
outputSingleValue = 2;
outputSingleScan(s,[outputSingleValue outputSingleValue]);
time = [0:1/s.Rate:60];
outputSignal = .1*sin(2*pi*25e3*time');
outputSignal = 1*square(2*pi*100*time, 50).';
plot(time,outputSignal);
xlabel('Time');
ylabel('Voltage');

queueOutputData(s,[outputSignal outputSignal]);

s.startForeground;
% %% Output signal
% if ~sum(size(s.Channels)) && ~sum(strcmp({s.Channels.ID},'ao0'))
%     ch = addAnalogOutputChannel(s,d(1).ID,0,'Voltage');
% end
% s.Rate = 250000;
% %s.IsContinuous=false;
% s.IsContinuous=true;
% 
% % Add trigger
% 
% % if ~sum(size(s.Connections))
% %     addTriggerConnection(s,'External',[d(1).ID '/PFI0'],'StartTrigger');
% % end
% % s.ExternalTriggerTimeout = 30;
% % 
% % c = s.Connections(1);
% % c.TriggerCondition = 'RisingEdge';
% % % s.TriggersPerRun = 1;
% 
% %% Set up scan data
% duration = 10;
% delay = 0;
% f_start_Hz = 105;
% f_step_Hz = 0;
% Amp_start_Vpp = 5;
% Amp_step_Vpp = 0;
% number_steps = 0;
% f_NA = 10;
% 
% freq = [];
% amp = [];
% t_out = [];
% y_out = [];
% for meas = 0:number_steps
%     for NA = 1:f_NA
%         freq = [freq; f_start_Hz + meas*f_step_Hz];
%         amp = [amp; Amp_start_Vpp + meas*Amp_step_Vpp];
% 
%         % now figure out time vector so each burst has int # of cycles and ends at 0.
%         Ts = 1/freq(end);
%         rem_time = rem(duration,Ts);
%         if rem_time >= delay
%             rem_time = rem_time - delay;
%         end
%         t = linspace(-rem_time-delay,duration-rem_time,(duration+delay)*s.Rate)';
%         y = amp(end) * sin(2*pi * freq(end) * t)/2;
%         y(t <= 0) = 0;
% 
%         t_out = [t_out t+rem_time+delay];
%         y_out = [y_out y];
% 
%     end
% end
% 
% %% Send signal to DAQ
% % s.NotifyWhenScansQueuedBelow = s.Rate * duration * .5;
% % 
% % global out y_out s
% % out = 1;
% % outputData = y_out(:,out);
% % queueOutputData(s,outputData);
% % 
% % startBackground(s);
% % 
% % lh = addlistener(s,'DataRequired', @getMoreData);
% 
% for out = 1:length(freq)
%     outputData = y_out(:,out);
%     queueOutputData(s,outputData);
%     startForeground(s);
% end
% 
% % %% Read signal
% % if ~sum(strcmp({s.Channels.ID},'ai0'))
% %     addAnalogInputChannel(s,d(1).ID,0,'Voltage');
% % end
% % data = s.startForeground();
% % plot(data)
% % 
% % %% end
% % delete(s)
% 
% %%
% delete(lh)
% 
% %%
% release(s);