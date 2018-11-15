function handles = computeShiftField(handles)
% output: handles.shift_amp
nRun = handles.runcount;  % alias nRun

shift_on = evalin('base','shift_on');
%display(['shift_on = ',num2str(shift_on)]);
startproj_count = evalin('base','startproj_count');
handles.startproj_count = startproj_count;
%proj_pts = evalin('base','proj_pts');
proj_count = nRun-startproj_count+1;
shift_amp_vals = evalin('base','shift_amp_vals');
proj_num = evalin('base','proj_num');
num_projections = evalin('base','num_projections');

if ( shift_on == 1 )
    set(handles.staticText_ShiftStatus,'ForegroundColor','Red');
    if nRun < startproj_count + length(shift_amp_vals)
        if proj_count == 1;
            handles.f = waitbar(0,'Scanning projection axis...');
            frames = java.awt.Frame.getFrames();
            frames(end).setAlwaysOnTop(1);
        end
        handles.shift_amp = shift_amp_vals(proj_count);
        disp(['shift amplitude = ', num2str(handles.shift_amp)]);
        waitbar(proj_count/length(shift_amp_vals),handles.f,['Projection ', num2str(proj_num),' of ',num2str(num_projections),': point ',num2str(proj_count),' of ',num2str(length(shift_amp_vals))]);
        
    elseif nRun >= startproj_count + length(shift_amp_vals) % once projection is finished
        close(handles.f); %close waitbar
        %             figure(3) % show projection plot
        %             figure(4) % show projection plot
        projection = evalin('base','projection');
        show    = strcmp(get(handles.panel_currentData,'visible'),'on');
        if ( show )
            axes(handles.plot_f3_projections);           hold on, plot(projection.f3_amp(:,proj_num));
            axes(handles.plot_f3_corrected_projections); hold on, plot(projection.f3_amp_corrected(:,proj_num));
        end
        
        startproj_count = nRun; % next projection starts now
        assignin('base','startproj_count',startproj_count);
        proj_count = nRun-startproj_count+1; % start next projection
        
        % run up to total number of projections, and flip direction of shift_amp_vals for each
        if proj_num < num_projections
            proj_num = proj_num + 1; % advance to next projection
            assignin('base','proj_num',proj_num);
            
            shift_amp_vals = flip(shift_amp_vals);
            assignin('base','shift_amp_vals',shift_amp_vals);
            show = strcmp(get(handles.panel_currentData,'visible'),'on');
            if ( show )
                axes(handles.plot_shift_values); hold off, plot(shift_amp_vals,'-o'); hold on, line([1 length(shift_amp_vals)],[0 0]);
            end
        else
            shift_on = 0;
            handles.shift_amp = 0;
            assignin('base','shift_on',shift_on);
        end
        
        if proj_count == 1;
            handles.f = waitbar(0,'Scanning projection axis...');
            frames = java.awt.Frame.getFrames();
            frames(end).setAlwaysOnTop(1);
        end
        handles.shift_amp = shift_amp_vals(proj_count);
        disp(['shift amplitude = ', num2str(handles.shift_amp)]);
        waitbar(proj_count/length(shift_amp_vals),handles.f,['Projection ', num2str(proj_num),' of ',num2str(num_projections),': point ',num2str(proj_count),' of ',num2str(length(shift_amp_vals))]);
    end
elseif shift_on == 0
    set(handles.staticText_ShiftStatus,'ForegroundColor','Blue');
    handles.shift_amp = 0;
end

