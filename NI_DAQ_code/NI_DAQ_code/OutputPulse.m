function [] = OutputPulse( number, Length,direction )

d  = daq.getDevices;

devID = d(1).ID;

s = daq.createSession('ni');
s.Rate = 10000;
    s.addAnalogOutputChannel(devID, 1:3, 'Voltage');

%ch1 = s.addAnalogInputChannel(devID, 0, 'Voltage');
%ch1.TerminalConfig = 'SingleEnded';

if nargin <4
    off = 0;
end



    for i = 0:((2*number)+1)
        if mod(i,2)==0
            output_data_temp(i*Length+1:(i+1)*Length,1)= 5;
        else
            output_data_temp(i*Length+1:(i+1)*Length,1)= 0;
            
        end
    end
    
    output_data =[output_data_temp];
    DirectionData = zeros(length(output_data),1);
    Enable = zeros(length(output_data),1);
    Enable(1:end) = 5;
    
    
    DirectionData(1:end) = 5*direction;
    Enable(end-10:(end)) = 0;
    
   figure(2), plot(output_data, '-*'); hold on, plot(Enable);
    
    queueOutputData(s, [Enable,DirectionData,output_data]);
    [captured_data] = s.startForeground();
    

end

