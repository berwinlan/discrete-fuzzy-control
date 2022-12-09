function cost = costFn(fis, model)
    % Update workspace variable for the controller.
    assignin('base','costFnFis',fis)

    % Run simulation programatically
    simOut = sim(model, ...
                 'SimulationMode', 'normal', ...
                 'SaveState','on', ...
                 'StateSaveName','xout', ...
                 'SaveOutput','on', ...
                 'OutputSaveName','yout', ...
                 'SaveFormat','dataset');

    % Get data for cost function (practice)
    cart_pos = simOut.yout.get('cart_pos').Values;
    pen_pos = simOut.yout.get('pen_pos').Values;

    % Cost function
    cart_pos_rms = rms(cart_pos.data);
    pen_pos_rms = rms(pen_pos.data);
    cost = 0.1 * cart_pos_rms + 3 * pen_pos_rms;
end

% function cost = costFcn(fis,model,minLevel,refLevel,wsVarNames,varargin)
% % Evaluate model, generate output, and find the cost.
%  
% %  Copyright 2021 The MathWorks, Inc.
%  
% % Update workspace variable for the controller.
% assignin('base',wsVarNames(1),fis)
%  
% % Update workspace variable for closeloop control.
% assignin('base',wsVarNames(2),1)
%  
% % Get simulation output. 
% out = sim(model);
%  
% % Get glucose levels, insulin doses, and CHO from simulation output.
% glucose = out.yout.signals(1).values;
% insulin = out.yout.signals(2).values;
% cho = out.yout.signals(3).values;
% tout = out.yout.time;
%  
% % Calculate error from the nominal value.
% err = glucose - refLevel;
%  
% % Specify high error values for the glucose levels below the minimum level.
% err(glucose<minLevel) = 100;
%  
% % Calculate cost as the root mean square of the error.
% errSquare = err.^2;
% meanSquare = mean(errSquare);
% cost = sqrt(meanSquare);
%  
% if isempty(varargin)
%     return
% end
%  
% % Update minimum cost data.
% data = varargin{1};
% if cost < data.MinCost
%     data.MinCost = cost;
%     data.MinGlucose = glucose;
%     data.MinInsulin = insulin;
%     data.fisTMin = fis;
%     data.Tout = tout;
% end
%  
% % Plot minimum and current data.
% subplot(3,1,1)
% plot(data.Tout,data.MinGlucose)
% ax = gca;
% ax.XLim(2) = max(data.Tout(end));
% ylabel(sprintf('Blood\nGlucose\n(mg/dl)'))
% title(sprintf('Min Cost = %g',data.MinCost))
% grid on
%  
% subplot(3,1,2)
% plot(data.Tout,data.MinInsulin)
% ax = gca;
% ax.XLim(2) = max(data.Tout(end));
% xlabel('Runtime (sec)')
% ylabel(sprintf('Insulin\nDosage\n'))
% grid on
%  
% subplot(3,1,3)
% plot(tout,cho)
% ax = gca;
% ax.XLim(2) = tout(end);
% ylabel(sprintf('Carbohydrate\nIntake\n(g)'))
% grid on
%  
% end
