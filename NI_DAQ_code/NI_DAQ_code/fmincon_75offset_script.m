
  
%   options = optimoptions('fmincon','Algorithm','interior-point'); % run interior-point algorithm
  drive_amp = 1;   
%   Xpred  =[-0.00101;1.3521];  %%prediction
% %   ub = [0.001, pi/2];
% %   lb = [-0.001, -pi/2];
% %   X0  =[-0.000;-0.0];
% 
%   ub = [Xpred(1)*0.9, Xpred(2)*1.1];
%   lb = [Xpred(1)*1.1, Xpred(2)*0.9];
%    x = fmincon(@(x) myfun(x,300,1,drive_amp),X0,[],[],[],[],lb,ub);
  
gaoptczc = gaoptimset('PopulationSize', 10, 'Display', 'diagnose','PlotFcns',{@gaplotscores, @gaplotbestf},'Generations',10);
% 
%  x = ga(@(x) myfun(x,300,1,drive_amp),2,[],[],[],[],lb,ub,[],gaoptczc);
 X0 = [2.1e-3, 4.1];
   ub = [X0(1)*1.25, X0(2)*1.25];
  lb = [X0(1)*0.75, X0(2)*0.75];
  

%   ub = [0.004, 2*pi];
%   lb = [0, 0];
%   X0  =[-0.0001;-0.0];
%   saopt = saoptimset('TolFun', 0.1, 'MaxFunEvals', 50,'MaxIter', 50, 'ObjectiveLimit', 0.01, 'Display', 'diagnose', 'PlotFcns', {@saplotbestf, @saplotf, @saplotstopping});
%   x = simulannealbnd(@(x) myfun(x,100,0.5,drive_amp), X0,lb,ub,saopt);
%   psopt = optimoptions('patternsearch','TolFun', 0.1, 'MaxFunEvals', 50,'MaxIter', 50, 'ObjectiveLimit', 0.01, 'Display', 'diagnose', 'PlotFcns', {@saplotbestf, @saplotf, @saplotstopping});
 options = optimoptions('particleswarm','SwarmSize',10); 
%  = optimoptions('patternsearch','Display','iter','PlotFcn',@psplotbestf);
  x = particleswarm(@(x) myfun(x,100,0.5,drive_amp), 2,lb,ub,options);


 
starting_amp =myfun([0,0],300,1,drive_amp);
resulting_amp =myfun(x,300,1,drive_amp);


% [f3_amp, f3_phase, data_raw] = f3_test_run([0,0],300,1,1, drive_amp);


display(['starting amp = ', num2str(starting_amp),', res amp = ', num2str(resulting_amp), ', offset amp = ',num2str(x(1)),', offset phase = ', num2str(x(2))]);