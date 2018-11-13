 clear all; 
for rr = 1:1 %%do multipy runs to check for consistency
offset_amp_vec = [0.0001:0.0001:0.0022];  offset_phase_vec = [0:pi/20:2*pi];

 % offset_phases = [-pi/2:pi/80:pi/2];  %offset_amps = 0.001*ones(size(offset_phases)); %offset_phases = zeros(size(offset_amps));

%  
%  a = -pi/2; b = pi/2;
%  offset_phases = a + (b-a).*rand(1,200); offset_amps = 0.0005*ones(size(offset_phases));
%  
 P = numel(offset_phase_vec);
for pp = 1:P
 phase_legend{pp} = ['phase=',num2str(offset_phase_vec(pp))];
A =numel(offset_amp_vec);
 tic
for aa = 1:A
   
    amp_legend{aa} = ['amp=',num2str(offset_amp_vec(aa))];
    offset_phase = offset_phase_vec(pp)*ones(size(offset_amp_vec));
 [f3_amp, f3_phase, data_raw] = f3_test_run([offset_amp_vec(aa),offset_phase(aa)],300,1,1, 0);



s.Rate = 500e3;
periodmult = 300; drive_freq = 25e3;
pw = periodmult/drive_freq;
time = [0:1/s.Rate:pw/2];
time = time(1:end-1);

[f,mag, xfft_out,xfft_full]= daqdocfft_lin(data_raw(end/2+1:end,:),500e3,numel(data_raw(end/2+1:end,1)));


% figure; subplot(1,2,1); plot(1000*abs(xfft_out(451,:)));hold on;  plot(f3_amp*ones(1,32));
% 
% subplot(1,2,2); plot(angle(xfft_out(451,:))); hold on; plot(f3_phase*ones(1,32));


f3_amp_all(aa) = f3_amp;  %aa is amp vector index
f3_phase_all(aa) = f3_phase;


end


toc


f3_amp_all_all(:,pp) = f3_amp_all;   %pp is phase vector index
f3_phase_all_all(:,pp) = f3_phase_all;




end

f3_amp_all_all_all(:,:,rr) = f3_amp_all_all;   %rr is run numbe index
f3_phase_all_all_all(:,:,rr) = f3_phase_all_all;

end
% 
% [Y,I] = sort(offset_phases);
% 
% figure; subplot(1,2,1); plot(1000*offset_amps,f3_amp_all_all);  xlabel('offset amps (mV)');  ylabel('resulting f3 amp'); title('f3 cal amp sweep, preamp gain 500, HPF in');
% subplot(1,2,2); plot(1000*offset_amps,f3_phase_all_all);  xlabel('offset amps (mV)'); ylabel('resulting f3 phase');
% title('f3 cal amp sweep, preamp gain 500, HPF in');
% 
% figure; subplot(1,2,1); plot(offset_phases,f3_amp_all_all);  xlabel('offset phases (rad)');  ylabel('resulting f3 amp (mV)'); title('f3 cal phase sweep, f3 amp = 0.0005, preamp gain 500, HPF in');
% subplot(1,2,2); plot(offset_phases,f3_phase_all_all);  xlabel('offset phases (rad)'); ylabel('resulting f3 phase (rad)');
% title('f3 cal phase sweep, f3 amp = 0.0005, preamp gain 500, HPF in');

% figure; subplot(1,2,1); plot(offset_phases(I),f3_amp_all_all(I));  xlabel('offset phases (rad)');  ylabel('resulting f3 amp (mV)'); title('f3 cal phase sweep, f3 amp = 0.0005, preamp gain 500, HPF in');
% subplot(1,2,2); plot(offset_phases(I),f3_phase_all_all(I));  xlabel('offset phases (rad)'); ylabel('resulting f3 phase (rad)');
% title('f3 cal phase sweep, f3 amp = 0.0005, preamp gain 500, HPF in');
% 
% 
% figure; subplot(1,2,1); plot(f3_amp_all_all);  xlabel('offset phases (rad)');  ylabel('resulting f3 amp (mV)'); title('f3 cal phase sweep, f3 amp = 0.0005, preamp gain 500, HPF in');
% subplot(1,2,2); plot(f3_phase_all_all);  xlabel('offset phases (rad)'); ylabel('resulting f3 phase (rad)');
% title('f3 cal phase sweep, f3 amp = 0.0005, preamp gain 500, HPF in');


f3_phase_unwrapped0 = [];

for pp = 1:numel(offset_amp_vec)
%     if f3_phase_all_all(pp,1) > 500
%         f3_phase_unwrapped0(pp,:) = f3_phase_all_all(pp,:) - 2*pi; 
%     else
%        f3_phase_unwrapped0(pp,:) = f3_phase_all_all(pp,:) ; 
%         
%     end
    
phase_unwrapped(pp,:) = unwrap(f3_phase_all_all(pp,:));
end


figure; subplot(2,2,1); plot(1000*offset_amp_vec,f3_amp_all_all);  xlabel('offset amps (mV)');  ylabel('resulting f3 amp (mV)'); title('f3 cal amp sweep, preamp gain 500, HPF in');
legend(phase_legend);

subplot(2,2,2); plot(offset_phase_vec,phase_unwrapped(2:end,:));  xlabel('offset phase (rad)'); ylabel('resulting f3 phase (rad)');
title('f3 cal amp and phase sweep, preamp gain 500, HPF in');  legend(amp_legend{2:end});  xlim([0,2*pi]);


subplot(2,2,3); plot(offset_phase_vec, f3_amp_all_all);  xlim([-pi/2, pi/2]);   xlabel('offset phase (rad)'); ylabel('resulting f3 amp (mV)');
title('f3 cal amp and phase sweep, preamp gain 500, HPF in');  legend(amp_legend); xlim([0,2*pi]);


subplot(2,2,4); plot(1000*offset_amp_vec, phase_unwrapped);   xlabel('offset amps (mV)');  ylabel('resulting f3 phase (rad)'); title('f3 cal amp sweep, preamp gain 500, HPF in');
legend(phase_legend);
