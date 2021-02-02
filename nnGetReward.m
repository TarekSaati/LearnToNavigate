function [reward] = nnGetReward(crash, outCor, inDanger, inRisk, terminal, action)

% Reward function of the Neural Network

if terminal
    reward = 100;
elseif crash || outCor
    reward = -100;
elseif ~inDanger
    good_actions = 1;
    turning_actions = [2 3];
    bad_actions = [4 5 6];
    G = ismember(action, good_actions);
    T = ismember(action, turning_actions);
    B = ismember(action, bad_actions);
    reward = 1*G - 1*T - 2*B;
elseif ~inRisk
    good_actions = [1 4 6];
    turning_actions = [2 3];
    bad_actions = [5];
    G = ismember(action, good_actions);
    T = ismember(action, turning_actions);
    B = ismember(action, bad_actions);    
    reward = 1*G - 1*T - 2*B;
else
    good_actions = [1 2 3];
    bad_actions = [4 5 6];
    G = ismember(action, good_actions);
    B = ismember(action, bad_actions);    
    reward = 1*G - 1*B;
end 