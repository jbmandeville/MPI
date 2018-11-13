clear all; %close all;


preamp_gain = 0;

v = daq.getVendors;
d  = daq.getDevices;
s = daq.createSession(v.ID);
s.Rate = 250e3;
addAnalogOutputChannel(s,d(1).ID, 0, 'Voltage');
addAnalogOutputChannel(s,d(1).ID, 1, 'Voltage');

pickupcoil = 0;
sub_baseline = 0;
baseline_ave = 1;

waveform(1) = 0; legendtext{1} = char(['ni-daq output']);   plot_scale(1) = .1;
 waveform(end+1) = 1; legendtext{end+1} = char(['preamp']);  plot_scale(end+1) = 1;  termconfig = 'SingleEnded';
 %   waveform(end+1) = 2;  legendtext{end+1} = char([' ']);  plot_scale(end+1) = 1;  termconfig = 'Differential'
%    waveform(end+1) = 4; legendtext{end+1} = char(['current sense']); pickupcoil = 0;

for input_count = 2:numel(waveform)
    ch2 = addAnalogInputChannel(s,d(1).ID, waveform(input_count), 'Voltage');
end

ch2.Range = [-5,5];
ch2.TerminalConfig = termconfig;

% ch2.TerminalConfig = 'SingleEnded'

%%%USER INPUT%%%%%%%%%%%%%%
squarewave = 0;   %switch
amp = .4; %/sqrt(10);  %Volts   %%current 1out of amplifier is roughly 20Xamp
numave = 2;
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
    duration = 500/drive_freq;    
    blocksize = duration*s.Rate;
    time = [0:1/s.Rate:duration];
    output_data_temp = 1*sin(2*pi*drive_freq*time).';% + 1*amp*sin(2*pi*75e3*time).';
end

output_data = [output_data_temp, zeros(size(output_data_temp))];

%%

figure(1);
% btn = uicontrol('Style', 'pushbutton', 'String', 'stop',...
%     'Position', [20 20 50 20],...
%     'Callback', 'delete(gcbo)');

input_count = 1;
cyclecount = 1;
amp_vec = [.1:.1:.7];



for nn = 1:numel(amp_vec)
    amp = amp_vec(nn);
    output_data = amp*[output_data_temp, zeros(size(output_data_temp))];

    
    for aa = 1:numave
        queueOutputData(s,output_data);
        [single_data] = s.startForeground();
        single_data_all(aa,:,:)=single_data;
        pause(pausetime);
    end
    
    captured_data = squeeze(mean(single_data_all,1)).';
    
    %%plot time domain
    figure(1)
    subplot(2,1,1);
    no_sample_data(:,nn) = captured_data(2:end,1);

    
prompt = 'insert sample, then press enter'; 
input(prompt);
    

 plot(time(2:end), output_data(2:end,1).','-b'); hold on;
 
  for aa = 1:numave
        queueOutputData(s,output_data);
        [single_data] = s.startForeground();
        single_data_all(aa,:,:)=single_data;
        pause(pausetime);
    end
    
    captured_data = squeeze(mean(single_data_all,1)).';
    
 
    for pp = 1:size(captured_data,2)

        data(:,pp+1) = [plot_scale(pp+1)*captured_data(2:end,pp)] - no_sample_data(:,nn);
        sample_data(:,nn) = [plot_scale(pp+1)*captured_data(2:end,pp)];

        amplitude = (max(data(end/2:end,pp+1))-min(data(end/2:end,pp+1)))/2;
        plot(time(2:end), data(:,pp+1),'-r');
        xlabel('time (s)');
        
        text(.8*max(time),0, ['amplitude = ', num2str(amplitude)]);
    end
    
    legend(legendtext(2));
    hold off;
    %title(['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V)']);
    title({['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V,'],[' num ave = ',num2str(numave),')']});%', preamp gain = ',num2str(preamp_gain),')']});
    
    %%
    
    
    %% frequency spectrum plot  
    [f,mag] = daqdocfft_lin(data(end/2+1:end,:),s.Rate,blocksize/2);
    [f,maglog] = daqdocfft(data(end/2+1:end,:),s.Rate,blocksize/2);
    
    subplot(2,1,2);
    plot(f,(mag(:,1)),'-b'); hold on;
   plot(f,(mag(:,2)),'-r');   hold off;
    

    xlim([0, s.Rate/2]);
    
    I0 = find(f > drive_freq - 100 & f < drive_freq +100);
    lin_amp0 = max(mag(I0,end));
    log_amp0 = max(maglog(I0,end));
    I3 = find(f > drive_freq*3 - 100 & f < drive_freq*3 +100);
    lin_amp3 = max(mag(I3,end));
    log_amp3 = max(maglog(I3,end));
    
    I2 = find(f > drive_freq*2 - 100 & f < drive_freq*2 +100);
    lin_amp2 = max(mag(I2,end));
    log_amp2 = max(maglog(I2,end));
    I4 = find(f > drive_freq*4 - 100 & f < drive_freq*4 +100);
    lin_amp4 = max(mag(I4,end));
    log_amp4 = max(maglog(I4,end));
    
    
    
    diffamp = lin_amp3 - lin_amp0;
    logdiffamp = log_amp3 - log_amp0;

    amp3_save(nn) = lin_amp3;

        
   
 
    ylabel('Magnitude (dB)')
    xlabel('Frequency (Hz)')
    title({['Acquired signal (duration = ',num2str(duration),'s, freq = ',num2str(drive_freq),'Hz, Amp = ',num2str(amp),'V,'],[' num ave = ',num2str(numave),')']});%', preamp gain = ',num2str(preamp_gain),')']});
    legend(legendtext)

    
    %%linear plot
    ylim([0, 70e-3/3.16]);
    Ylim = get(gca,'ylim');
    Ymax = Ylim(2);
    text(0,.95*Ymax, ['fundamental amp = ', num2str(lin_amp0)]);
    text(0,.85*Ymax, ['3rd harmonic amp = ', num2str(1000*lin_amp3),'mV']);  
    text(0,.75*Ymax, ['harmonic difference = ', num2str(logdiffamp),'db']);
    if cyclecount ~= 1 
    text(0,.65*Ymax, ['1000x delta 3rd harm = ', num2str(1000*(max(amp3_save)-min(amp3_save))),' ']);
    end
   text(5.5e4,55, ['2nd harmonic amp = ', num2str(lin_amp2)]);
    text(5.5e4,45, ['4th harmonic amp = ', num2str(lin_amp4)]);
  


%     %log plot
%      text(0,55, ['fundamental amp = ', num2str(lin_amp0)]);
%     text(0,45, ['3rd harmonic amp = ', num2str(1000*lin_amp3),'mV']);  
%     text(0,35, ['harmonic difference = ', num2str(logdiffamp),'db']);
%     if cyclecount ~= 1 
%     text(0,25, ['1000x delta 3rd harm = ', num2str(1000*(max(amp3_save)-min(amp3_save))),' ']);
%     end
%    text(5.5e4,55, ['2nd harmonic amp = ', num2str(lin_amp2)]);
%     text(5.5e4,45, ['4th harmonic amp = ', num2str(lin_amp4)]);
%          ylim([-150, 60]);

figure(2);
plot(amp_vec(1:nn),amp3_save(1:nn));

prompt = 'remove sample, then press enter';
input(prompt);

end



figure(2);
h2 = figure(2);
xlabel('voltage input to Techron (V)');
ylabel('delta 3rd harmonic voltage from sample (V)');
title({['MPI signal versus drive voltage - used tuned Tx ,'],['tuned Rx  -> preamp gain 200 -> highpass filter fc =35khz']});
save('data_withRcs.mat' , 'no_sample_data', 'sample_data', 'amp_vec');

savefig(h2, 'amp_increase_trend.fig');
print(h2, 'amp_increase_trend.png', '-dpng');


[f,dataresult] = daqdocfft_lin(sample_data(end/2+1:end,:)-no_sample_data(end/2+1:end,:),s.Rate,blocksize/2);
figure; plot(f,dataresult); xlabel('voltage input to Techron (V)');
title('difference signal with Tx filter');

SNR  = max(dataresult)./std(dataresult(780:940,:))
h3 = figure(3); plot(amp_vec,SNR);  title('SNR with Tx filter');
print(h3, 'SNR.png', '-dpng');


[f,dataresult] = daqdocfft_lin(no_sample_data(end/2+1:end,:),s.Rate,blocksize/2);

