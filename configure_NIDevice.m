function configure_NIDevice(handles)
global myDeviceSettings myDaqStream
myDaqStream.session = daq.createSession('ni');
myDaqStream.session.Rate = myDeviceSettings.rateRateContinuous;

myDaqStream.device  = daq.getDevices;
devID = myDaqStream.device(1).ID;
handles.devID = devID;

myDaqStream.ao0 = myDaqStream.session.addAnalogOutputChannel(devID, 0, 'Voltage');
myDaqStream.ao1 = myDaqStream.session.addAnalogOutputChannel(devID, 1, 'Voltage');

myDaqStream.ch1 = myDaqStream.session.addAnalogInputChannel(devID, 0, 'Voltage');
myDaqStream.ch1.Range = [-0.5,0.5];
myDaqStream.ch1.TerminalConfig = 'SingleEnded';
myDaqStream.ch2 = myDaqStream.session.addAnalogInputChannel(devID, 1, 'Voltage');
myDaqStream.ch2.Range = [-10,10];
myDaqStream.ch2.TerminalConfig = 'SingleEnded';

