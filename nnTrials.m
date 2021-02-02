function [n_crash, n_out, i, info_s2] = ...
    nnTrials(memory_size, miniBatch_size, tgt_upd, onStreamSizes, n_crash, n_out, ...
    radius, nDynObs, maxRad, info_s1, trainAfter, eps_min, eps_init, ...
    DecayUntil, path, cor_mat, margin, maxsteps, input)

global mode num_steps avg_reward avg_cost memory ActionMem V S draw
global headings speeds centers 
global pol_params tar_params actions experience epsilon alpha gamma
global center angle h_text h_car h_poly h_plot h_circ arena Vmax Wmax

%% ----- Initialization
params_temp = pol_params;
Fmax = Vmax;
lampda = 1;
sensor_range = 20;
K_danger = 1;
n_sensors = input;
f = @(x) x;
info_s2 = [];
backSpace = 3;
rpath = center; opath = {}; plt = {};

%% ----- Observe initial sensor values
obs_mat = obs2Mat(h_circ, h_poly, nDynObs, maxRad);
dynSpace = obs2Mat([], arena, nDynObs, maxRad);
backline = createBackline(path, backSpace, margin, 1);  pathId = 1;   
d2obs = dis2Obs(obs_mat, center, angle, sensor_range+radius, ...
                    n_sensors) - radius;
d2cor = dis2Obs([cor_mat; backline], center, angle, sensor_range+radius, ...
                    n_sensors) - radius;
d2cor = [d2cor(0.75*n_sensors+1:end); d2cor(1:0.25*n_sensors)];
d_past = d2obs;
velocities = d2obs-d_past;
ActionMem = zeros(5,1);
spatial = [d2obs; d2cor; ActionMem]/sensor_range;
temporal = velocities/sensor_range;

%% ----- Trial with max_steps   
for i = 1:maxsteps
    % Pause simulation
    if( strcmp(mode,'Pause') )        
        i = 0;
        pol_params = params_temp;
        break; 
    end  
    if i==2, avg_cost = 0; end
    num_steps = num_steps + 1;

    terminal = false; outCor = false;
    danger_factor = max(-K_danger*(velocities)./d2obs);
    inDanger = danger_factor>=lampda;
    if inDanger
        [min_dis, I] = min(pdist2(center, centers));
        delta = atan2(center(2)-centers(I,2), center(1)-centers(I,1)) - headings(I);
        risk_dis = min_dis*sin(abs(delta));
        if risk_dis <= maxRad+radius, inRisk = 1; else, inRisk = 0; end
    else
        inRisk = 0;
    end
%     if inRisk, set(h_car(2),'EdgeColor','r');
%     else, set(h_car(2),'EdgeColor','k'); end
    
    obsv = [spatial; temporal];
    
    % Feed the sensor values into the Neural Network
    Q = FeedForward(pol_params, obsv, onStreamSizes, @ReLU, f);  

    % Select an action with the exploration function
    action = chooseAction(inDanger, Q, epsilon, actions);
    for p=1:4, ActionMem(6-p) = ActionMem(5-p); end
    ActionMem(1) = Q(action);
    force = actionForce(action, Fmax, angle);
    moveRobot(force, Vmax, Wmax);
    
    handleCrashDynamics(dynSpace);
    obs_mat = obs2Mat(h_circ, h_poly, nDynObs, maxRad);
    d_past = dis2Obs(obs_mat, center, angle, sensor_range+radius, ...
                            n_sensors) - radius;
    if center(1) > 52, moveObstacles(speeds, headings); end
    crash = checkCrash(h_car, h_poly, h_circ);
    obs_mat = obs2Mat(h_circ, h_poly, nDynObs, maxRad);
    d2obs = dis2Obs(obs_mat, center, angle, sensor_range+radius, ...
                            n_sensors) - radius;
    velocities = d2obs-d_past;
    temporal = velocities/sensor_range;
    [~, I] = min(pdist2(center, path)); pathId = max(I, pathId);
    backline = createBackline(path, backSpace, margin, pathId);
    D2cor = dis2Obs([cor_mat; backline], center, angle, sensor_range+radius, ...
        n_sensors) - radius;
    d2cor = [D2cor(0.75*n_sensors+1:end); D2cor(1:0.25*n_sensors)];
    spatial = [d2obs; d2cor; ActionMem]/sensor_range;
    nextObsv = [spatial; temporal];     
    if min(D2cor) < 1, outCor = true; end
    if I == length(path), terminal = true; end
    if crash || outCor || terminal, nextObsv = []; end
    reward = nnGetReward(crash, outCor, inDanger, inRisk, terminal, action);
    if num_steps > trainAfter, avg_reward = avg_reward + reward; end

    stp = imod(num_steps, memory_size);
    experience{stp}{1} = obsv;          % St
    experience{stp}{2} = nextObsv;      % St+1
    experience{stp}{3} = action;        % At
    experience{stp}{4} = reward;        % Rt
    memory(stp) = experience(stp);
    
    if num_steps > trainAfter
        idx1 = randperm(min(num_steps, memory_size));
%         idx2 = randperm(min(cnt, 500));
        miniBatch = memory(idx1(1:miniBatch_size));
%         miniBatch = memory(num_steps);
        p_grad = {};
        cost = 0;
        for k=1:miniBatch_size
            obsv = miniBatch{k}{1}; nextObsv = miniBatch{k}{2};
            action = miniBatch{k}{3}; reward = miniBatch{k}{4};
            Q_est = qEstimate(tar_params, pol_params, ...
                nextObsv, onStreamSizes, @ReLU, f, reward, gamma);
            [C, grad] = BackPropagation(pol_params, obsv, onStreamSizes, ...
                actions, action, Q_est);
            for j = 1:length(grad)
                for m=1:length(grad{j})
                    if (~isempty(p_grad))
                        grad{j}{m} = grad{j}{m} + p_grad{j}{m};
                    end
                end
            end
            p_grad = grad;
            cost = cost + C/miniBatch_size;
        end
        avg_cost = avg_cost + cost;
        % Update the weight matrices using ADAM optimizer
        [pol_params, V, S] = netUpdate(pol_params, V, S, num_steps-trainAfter+1, ...
            grad, alpha, miniBatch_size);
        
        if num_steps <= DecayUntil
            epsilon = epsilon - (eps_init-eps_min)/(DecayUntil-trainAfter);
        end
        
        if imod(num_steps, tgt_upd) == 1, tar_params = pol_params; end
    end
%      if ~isempty(plt), for b=1:nDynObs, delete(plt{b}); end; end
%     for b=1:nDynObs, opath{b}(imod(i,12),:) = centers(b,:);  end
%      subplot(h_plot(1)); hold on; %plot(rpath(:,1), rpath(:,2), 'LineWidth', 1.5, 'Color', 'b');   
%     for b=1:nDynObs, plt{b} = plot(opath{b}(:,1), opath{b}(:,2), '.', 'Color', [1 0.8 0]); end
    if crash || outCor || num_steps == maxsteps, terminal = true; end
    if crash, n_crash = n_crash + 1; end
    if outCor, n_out = n_out+1; end
    info_s2 = sprintf('%s%11.2f%20s%11d%15s%11d', 'step', i, ...
        '#outCor', n_out, '#crashs', n_crash);
    info_s = sprintf('%s\n%s', info_s1, info_s2);
    set(h_text, 'String', info_s);
    if draw, drawnow; end    
    if(terminal), avg_cost = avg_cost/i; break; end
end
