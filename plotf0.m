function plotf0(handles)
nRun = handles.runcount;  % alias nRun
axes(handles.plot_f0_time)
plot(1:nRun, handles.gradiometer_f0_save_mV(1:nRun));
xlabel('run number'); title('f0 time series');
% axes(handles.f4_time_plot)
% % plot([1:nRun], handles.gradiometer_f5_save(1:nRun));
% % xlabel('run number'); title('f5 level');
% plot([1:nRun], handles.gradiometer_f4_save(1:nRun));
% xlabel('run number'); title('f4 level');
% axes(handles.f2_time_plot)
% plot([1:nRun], handles.gradiometer_f2_save(1:nRun));
% xlabel('run number'); title('f2 level');

