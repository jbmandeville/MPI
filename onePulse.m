function  onePulse( number, Length, direction, handles)
% Create bipolar square wave pulses with ON/OFF of equal duration
% number   : # of bipolar pulses
% Length   : lenght of each pulse in ms
% direction: 0=backward, 1=forward 
global myDaqStream myDeviceSettings

% Note that the motor is ON
set(handles.staticText_motorOn,'Visible','on');

if myDaqStream.session.IsDone == 1
    stop(myDaqStream.session);
    release(myDaqStream.session)
    myDaqStream.session = daq.createSession('ni');%Initializes a new session with the DAQ
    myDaqStream.ao1 = myDaqStream.session.addDigitalChannel(handles.devID,'Port0/Line0:2','OutputOnly'); %Tells DAQ we will be outputting on analog out terminals 1-3
    addAnalogInputChannel(myDaqStream.session,handles.devID,2,'Voltage');
    myDaqStream.session.Rate = myDeviceSettings.ratePulse;    
    
    for i = 0:((2*number)+1) %This loop creates a square wave where number is the number of pulses in the square wave and length is the length of each square in ms
        if mod(i,2)==0%Checking if i is even or odd, even values make the HIGH and odd values of i make the LOW of the Sq wave
            output_data(i*Length+1:(i+1)*Length,1)= 1; %makes a HIGH section of the wave and assigns it to the output data vector
        else
            output_data(i*Length+1:(i+1)*Length,1)= 0;
        end
    end
    
    DirectionData = zeros(length(output_data),1); % initializing the Direction Data vector
    DirectionData(1:end) = 1*direction;           % sets all the direction values to be 5 or 0 (logicals determine the direction)

    Enable = zeros(length(output_data),1); % inializes the enable pin data
    Enable(1:end) = 1;                     % fills the enable vector with all HIGH values (5)
    Enable(end-10:(end)) = 0;              % sets the last few values in the enable pin to be low, this ensures the DAQ "latches" low and makes sure the stepper is properly turned off
    
    queueOutputData(myDaqStream.session, [Enable,DirectionData,output_data]); %queues all the data into 3 channnels
    myDaqStream.session.startForeground(); % outputs the pulses
    
    reset(myDaqStream.session) % What does this do?
end
% turn OFF the motor indicator
set(handles.staticText_motorOn,'Visible','off');

