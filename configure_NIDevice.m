function configure_NIDevice(handles)
global myDeviceSettings myDaqStream

myDaqStream.session = daq.createSession('ni');
myDaqStream.session.Rate = myDeviceSettings.rateContinuous;
set(handles.editText_continuousRate,'String',num2str(myDaqStream.session.Rate));

myDaqStream.device  = daq.getDevices;
devID = myDaqStream.device(1).ID;
handles.devID = devID;

myDaqStream.ao0 = myDaqStream.session.addAnalogOutputChannel(devID, 0, 'Voltage');  % drive field
myDaqStream.ao1 = myDaqStream.session.addAnalogOutputChannel(devID, 1, 'Voltage');  % shift field

myDaqStream.ch1 = myDaqStream.session.addAnalogInputChannel(devID, 0, 'Voltage');   % receive signal (volts)
myDaqStream.ch1.Range = [-0.5,0.5];  % query after setting to get actual value
myDaqStream.ch1.TerminalConfig = 'SingleEnded';
myDaqStream.ch2 = myDaqStream.session.addAnalogInputChannel(devID, 1, 'Voltage');   % temperature
myDaqStream.ch2.Range = [-10,10];   % query after setting to get actual value
myDaqStream.ch2.TerminalConfig = 'SingleEnded';

