
clear; clc;
initSimulation;
global num_steps avg_reward draw avg_cost
global center angle 
global pol_params tar_params epsilon alpha gamma
global h_text h_car
avg_reward = 0;
avg_cost = 0;
draw = 0;

%% ----- Main loop
while(true)
    
    pause(0.1);
    
    % Main loop for Neural Network method
    if( strcmp(mode,'Start') )  
    mode = '';
    
    for j = j:max_trials
        createStadium([mapXlim; mapYlim], [arenaXlim; arenaYlim], nDynObs, maxRad);
        dynObsInit(maxVel, nDynObs);
%         goal = [30*rand()+60, -20+rand()*40];
        subplot(h_plot(1));
%         if num_steps <= DecayUntil
%             goal = [95, -15];
%             delete(h_goal);
%             h_goal = patch([goal(1)-0.5,goal(1)+0.5,goal(1)+0.5,goal(1)-0.5], ...
%                 [goal(2)-0.5, goal(2)-0.5, goal(2)+0.5,goal(2)+0.5], 'r');
%         else
            goal = [95, 20];
%             delete(h_goal);
%             h_goal = patch([goal(1)-0.5,goal(1)+0.5,goal(1)+0.5,goal(1)-0.5], ...
%                 [goal(2)-0.5, goal(2)-0.5, goal(2)+0.5,goal(2)+0.5], 'r');
%         end
        [path, right, left] = createCorridor(pathPoints, goal, margin, spacing);
        cor_mat = [right; left];
%         subplot(h_plot(1)); hold on; plot(right(:,1),right(:,2),'r');
%         plot(left(:,1),left(:,2),'b'); hold off;
        delete(h_car);
        center = pathPoints(end,:); angle = pi/2; goal = [95,20];
%         center = [25 10]; angle = 0;
            
%         rnd = rand();
%         if rnd < 0.2
%         center = [20 -20]; angle = pi/2;
%         elseif rnd < 0.35,  center = [15 0]; angle = pi/2;
%         elseif rnd < 0.5,  center = [25 10]; angle = 0;
%         else
%             center = pathPoints(end,:); angle = 0; 
%         end
        
        createCarCircle(radius, sensor_range, 'b', center, angle);
        info_s1 = sprintf('%s%11d%21s%13d%22s%10.2f', 'Trial:', j, 'Step:', ...
            num_steps, 'Reward:', avg_reward);
        
        [n_crash, n_out, i, info_s2] = ...
            nnTrials(memory_size, miniBatch_size, tgt_upd, onStreamSizes, n_crash, ...
            n_out, radius, nDynObs, maxRad, info_s1, trainAfter, eps_min, eps_init, ...
            DecayUntil, path, cor_mat, margin, max_steps, input);

        if(strcmp(mode,'Pause') || num_steps == max_steps)
            avg_reward = 0; avg_cost = 0; break;
        end
        
        info_s = sprintf('%s\n%s', info_s1, info_s2);
        set(h_text, 'String', info_s);
        info_string2 = sprintf('%s%13d\n\n%s%24.5f\n\n%s%21.4f\n\n%s%21.4f',...
                  'Maxsteps:', max_steps, 'Alpha:', alpha, 'Gamma:', gamma, ...
                  'Epsilon:', epsilon);
        task_panel = uipanel(NN_panel, 'title', 'Params','Position', ...
                                [0.54, 0.032, 0.2, 0.31]);
        uicontrol(task_panel, 'Style', 'text', 'HorizontalAlignment', 'left', ...
                     'FontSize', 11, 'FontName', 'Calibri', 'String', ...
                     info_string2, 'Position', [20, 0, 300, 215]);
        
%         if  num_steps > trainAfter       
            n = n+1; x2(n) = n-1; y3(n) = avg_cost; y4(n) = avg_reward;
            avg_reward = 0;
            subplot(h_plot(2)); plot(x2,y3);
            title('Average cost VS episode');
            xlabel('episode'); ylabel('Average cost');
            subplot(h_plot(3)); plot(x2,y4);
            title('Average reward VS episode');
            xlabel('episode'); ylabel('Average reward');
            subplot(h_plot(1));
            drawnow;
%         end
        
        if(mod(j,500) == 0), clc; end
        Tekst = sprintf('Trials: %d', j);
        fprintf([Tekst,'\n']);
        
        if num_steps > 2*DecayUntil, epsilon = 0.01; end
        
    end
    end
    
    %Reset for Neural Network
    if( strcmp(mode,'Reset') )
        mode = '';
        draw = 1; j = 1; reward = 0;
        average_reward = 0; average_cost = 0; n_crash = 0; 
        epsilon = 0;
        trainAfter = 10*trainSize;
        cla(h_plot(2));
        cla(h_plot(3));
    end
    
    %Upload for Neural Network
    if( strcmp(mode,'Upload') )
        mode = '';        
        load('NN_savefile.mat');
        subplot(h_plot(2)); plot(x2,y3);
        subplot(h_plot(3)); plot(x2,y4);
        n_crash = 0; j = 1;
    end
    
    %Save for Neural Network
    if( strcmp(mode,'Save') )
        mode = '';
        % Store paramters
        save('NN_savefile.mat', 'pol_params', 'tar_params', 'j', 'n', 'x2', ...
            'y3', 'y4', 'avg_reward', 'avg_cost', 'n_crash');
        save('NN_parameters.mat', 'memory_size', 'miniBatch_size', 'tgt_upd', ...
            'alpha', 'gamma', 'epsilon', 'onStreamSizes', ...
            'trainAfter', 'eps_min', 'DecayUntil')
        % Store MATLAB figure
        savefig('nn_fig');
        set(h_button(5), 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off');
    end
end

