
clc, clear , close all, warning('off');
pathPoints = [20, -20; 21, -15; 21.5 -11; 22, -8;
              21, -4; 19.5, -1.5; 18, 2.2;
              18, 5; 19, 9; 23, 9.5; 33, 10.5;
              37.5, 10.5; 39, 8; 48, -15; 
              50, -18; 52, -18; 55, -16]; 
%% ----- Global Variables
global mode num_steps memory ActionMem V S
global pol_params tar_params actions experience epsilon alpha gamma
global Vmax Wmax h_plot


%% ----- Initialize paramters for simulations

mode = '';
n = 1;  j = 1; x1 = 0; x2 = 0; y1 = 0; y2 = 0; y3 = 0; y4 = 0;             
steps = 0; n_crash = 0; n_out = 0;
% Properties of the vehicle. scale: 1:10 cm
radius = 0.75; sensor_range = 20; Vmax = 1.5; Wmax = 1; 
% Properties of The moving obstacles
nDynObs = 8; maxRad = 1.5; maxVel = 1.5; n_sensors = 200;
% Properties of the corridor
margin = 8; spacing = 0.1;

%% ----- Initialize Q-learning with Neural Network
input = 200;  output = 6;
% Online Neural Network
in1 = input+input/2+5; in2 = input; 
h11 = 128; h12 = 64; h21 = 128; h22 = 64; 
onStreamSizes = {[in1 h11 h12], [in2 h21 h22], [h12+h22 output]};
pol_params = cell(1,3);
V = cell(1,3); S = cell(1,3);
for i=1:length(pol_params)
    for j=1:length(onStreamSizes{i})-1
        pol_params{i}{j} = randInitializeWeights(onStreamSizes{i}(j), ...
                            onStreamSizes{i}(j+1));
        V{i}{j} = 0*pol_params{i}{j};
        S{i}{j} = 0*pol_params{i}{j};
    end
end
tar_params = pol_params;        % Target network cloned form policy network

%% ----- Initaliseringer av parametrer for Neural Network metoden
trainSize = 1000;
trainAfter = inf;%2*trainSize;          % steps to start train the agent
DecayUntil = inf;%10*trainSize;      % final decay step for epsilon
memory_size = 30*trainSize;        % Experience memory replay capacity
miniBatch_size = 16;
memory=cell(1,30*trainSize); ActionMem = [];
experience = cell(1,30*trainSize);
tgt_upd = trainSize;           % number of steps to update target network
max_trials = 200;     % Max Trials
max_steps = 200*trainSize;        % Max steps
alpha  = 1e-4;
gamma   = 0.99;          % Discount factor
epsilon = 0;         % Chance for random action
eps_init = 1;
eps_min = min(0.1, eps_init);              % final decay value for epsilon
actions = actionList();
num_steps = 0;

%% ----- Initaliseringer for GUI

%Plot size
mapXlim = [0, 105]; mapYlim = [-25, 25];
arenaXlim = [52, 90]; arenaYlim = [-25, 25];

% GUI
[h_plot, h_button, NN_panel] = createSimulation(mapXlim, mapYlim, ...
                                max_trials, max_steps, alpha, gamma, epsilon);
subplot(h_plot(1));
% center = [25 10];
createStadium([mapXlim; mapYlim], [arenaXlim; arenaYlim], nDynObs, maxRad);  
createCarCircle(radius, sensor_range, 'b', pathPoints(end,:), 0);
goal = [95 20];
h_goal = patch([goal(1)-0.5,goal(1)+0.5,goal(1)+0.5,goal(1)-0.5], ...
    [goal(2)-0.5, goal(2)-0.5, goal(2)+0.5,goal(2)+0.5], 'r');