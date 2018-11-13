
close all;
clear all;


v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);






ch1 = addAnalogInputChannel(s,d(1).ID, 1, 'Voltage');
s.Rate = 125000;
s.DurationInSeconds = .1;
%ch2 = addAnalogInputChannel(s,d(1).ID, 9, 'Voltage');




figure;
for kk = 1:100

[data,time] = s.startForeground;
% figure(1); plot(time,data(:,1)-data(:,2))
 plot(time,data)
xlabel('Time (Secs)');

pause(.1);
end