clear all; %close all;


preamp_gain = 0;

v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);
s.Rate = 250e3;
addAnalogOutputChannel(s,d(1).ID, 0, 'Voltage');
addAnalogOutputChannel(s,d(1).ID, 1, 'Voltage');

pickupcoil = 0;

waveform(1) = 0; legendtext{1} = char(['ni-daq output']);   plot_scale(1) = .1;
waveform(end+1) = 3; legendtext{end+1} = char(['current sense']);  plot_scale(end+1) = 1;  termconfig = 'Differential';
%    wavefoPreamp output']); plot_scale(end+1) = 1;
%    waveform(end+1) = 2; legendtext{end+1} = chrm(end+1) = 3; legendtext{end+1} = char(['loop back']);  plot_scale(end+1) = 1;
%    waveform(end+1) = 4; legendtext{end+1} = char(['current sense']); pickupcoil = 0;

for input_count = 2:numel(waveform)
    ch2 = addAnalogInputChannel(s,d(1).ID, waveform(input_count), 'Voltage');
end

ch2.Range = [-10,10];
ch2.TerminalConfig = termconfig;

amp_vec = [0.05:.05:.6];
 amp_vec = 5*ones(1,20);
for ii = 1:numel(amp_vec)

%%%USER INPUT%%%%%%%%%%%%%%
squarewave = 0;   %switch
amp = amp_vec(ii); %/sqrt(10);  %Volts   %%current 1out of amplifier is roughly 20Xamp
numave = 1;
pausetime = .5;


%% NI-DAQ output
if squarewave == 1
    duration = .5;
    time = [0:1/s.Rate:duration];
    blocksize = duration*s.Rate;
    drive_freq = 1;
    output_data_temp = amp/2+amp/2*square((time-duration/2), .05).';
    
else
    drive_freq =25e3;
    duration = 1000/drive_freq;    
    blocksize = duration*s.Rate;
    time = [0:1/s.Rate:duration];
    output_data_temp = 1*amp*sin(2*pi*drive_freq*time).';% + 1*amp*sin(2*pi*75e3*time).';
end

output_data = [output_data_temp, zeros(size(output_data_temp))];

%%

figure(1);
btn = uicontrol('Style', 'pushbutton', 'String', 'stop',...
    'Position', [20 20 50 20],...
    'Callback', 'delete(gcbo)');

input_count = 1;
cyclecount = 1;



% while ishandle(btn)

   
    
    for aa = 1:numave
        queueOutputData(s,output_data);
        [single_data] = s.startForeground();
        single_data_all(aa,:,:)=single_data;
        pause(pausetime);
    end
    
    captured_data = squeeze(mean(single_data_all,1)).';
    
    %%plot time domain
    subplot(2,1,1);
    data(:,1) = [plot_scale(1)*output_data(2:end,1)];
    plot(time(2:end), data(:,1));
    xlabel('time (s)');
    hold on;
    

    
    for pp = 1:size(captured_data,2)
        data(:,pp+1) = [plot_scale(pp+1)*captured_data(2:end,pp)];
        
        amplitude = (max(data(end/2:end,pp+1))-min(data(end/2:end,pp+1)))/2;
        plot(time(2:end), data(:,pp+1));
        xlabel('time (s)');
        
%         text(0.03,0, ['current amplitude = ', num2str(20*amplitude)]);

        text(0.03,0, ['est curr amp = ', num2str(20*amplitude)]);
    end
    
%     legend(legendtext);
%     hold off;
%         subplot(2,2,2);
%         data(:,1) = [plot_scale(1)*output_data(2:end,1)];
%             plot(time(8000:end), data([8000:end],1));
%             xlabel('time (s)');
%             hold on;
%     
%     for pp = 1:size(captured_data,2)
%             data(:,pp+1) = [plot_scale(pp+1)*captured_data(2:end,pp)];
%             plot(time(8000:end), data([8000:end],pp+1));
%             xlabel('time (s)');
%     end
%     
    legend(legendtext);
    hold off;
    %title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
    title({['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V,'],[' num ave = ',num2str(numave),', preamp gain = ',num2str(preamp_gain),')']});
    
    %%
    
    
    %% frequency spectrum plot  
    [f,mag] = daqdocfft_lin(data(end/2+1:end,:),s.Rate,blocksize/2);
    [f,maglog] = daqdocfft(data(end/2+1:end,:),s.Rate,blocksize/2);
    
    subplot(2,1,2);
    plot(f,(maglog));
    
    ylim([-120, 60]);
    xlim([0, s.Rate/2]);
    
    I0 = find(f > drive_freq - 100 & f < drive_freq +100);
    lin_amp0 = max(mag(I0,end));
    log_amp0 = max(maglog(I0,end));
    I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
    lin_amp3 = max(mag(I3,end));
    log_amp3 = max(maglog(I3,end));
    diffamp = lin_amp3 - lin_amp0;
    logdiffamp = log_amp3 - log_amp0;
    amp3_save(cyclecount) = lin_amp3;
    Ylim = get(gca,'ylim');
    Ymax = Ylim(2);
    
    
    lin_amp0_save(ii) = lin_amp0;
    lin_amp3_save(ii) = lin_amp3;
    diff_amp_save(ii) = logdiffamp;
    current_amp(ii) = amplitude*20;
 
    ylabel('Magnitude (dB)')
    xlabel('Frequency (Hz)')
    title({['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V,'],[' num ave = ',num2str(numave),', preamp gain = ',num2str(preamp_gain),')']});
    legend(legendtext)

    text(0,55, ['fundamental amp = ', num2str(lin_amp0)]);
    text(0,45, ['3rd harmonic amp = ', num2str(lin_amp3)]);  
    text(0,35, ['harmonic difference = ', num2str(logdiffamp),'db']);
%     text(0,25, ['100x delta 3rd harm = ', num2str(100*(max(amp3_save)-min(amp3_save))),' ']);
  
% cd C:\Users\MPI\MPI\MATLAB\MPI_data\data_8_17\current_sense_monitor
% print('-f1',['InputAmp_',num2str(amp_vec(ii)),'V.png'],'-dpng')
% save 'harmonic tracking' 'lin_amp0_save' 'lin_amp3_save' 'amp_vec';
 

    cyclecount = cyclecount+1;
end

figure(2); plot(amp_vec,current_amp);
xlabel('input voltage (V)');
ylabel('estimated drive current (A)');
hold on; plot(amp_vec,lin_amp0_save*20,'-r');
hold on; plot(amp_vec,lin_amp3_save*200,'-r');
legend('time dom amp', 'fund amp', '3rd harm amp x10')

