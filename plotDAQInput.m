function plotDAQInput(handles, output_data_drive, output_data_shift)
%%%gradiometer /preamp voltage time domain plot
show = strcmp(get(handles.panel_currentData,'visible'),'on');
enabled = get(handles.radioButton_acquireEachPulse,'Value') == 1.0;
if ( show && enabled )
    axes(handles.plot_driveField); plot(output_data_drive);
    axes(handles.plot_shiftField); plot(output_data_shift);
end