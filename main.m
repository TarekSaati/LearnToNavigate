%% Robot - Environment Preferences
vr = 0.15;                              % forward velocity (m/sec)
um = 1;                                 % max. turning velocity (rad/sec)
W = 0.15;
rmin = max(vr/um,W/2);                  % min. turning raduis 
map_wd = 10;                            % preference
map_ht = 10;
size = [map_wd, map_ht];

%% Map Creation
Nm = 256;  metric = Nm/map_wd;               % (pixel/m)
mar = ceil(1.2*rmin*metric);            % safety margin (m)
image = imread('eval_2.bmp');
map = idilate(image, kcircle(mar));
edge_map = edge(map,'log');
p0 = [-3, -2, pi/2]; 
G = [3 3];
% p0 = [10 12.5 pi];                       % initial position [x,y,theta]
% G = [-12.5 -10];                             % target position
stp = 0.5*rmin;                         % curves' sampling

%% 
[obs, n_obs] = find_obstacles(image, size, Nm, metric, 0);
curves = build_curves(edge_map, size, Nm, rmin, metric, stp, 0);
[circles, cntrs] = build_init_circles(p0, rmin, 0.1*stp);

%% TG Graph Generation + Candidate Paths Generation
tic
deg_tol = floor((360/(2*pi*rmin/stp))/2);  
tol = deg_tol*pi/180;
% Targets are: goal + obstacles in the restricted areas
targets = find_target_obs(curves, p0(1:2), G);
graph_curves = [circles{1}, circles{2}, curves(targets(2:end))];
[graph, AB_pts] = build_restricted_graph(graph_curves, curves, targets, obs, G, ...
    rmin, stp, tol, 0); 
toc
% Candidate paths generation algorithm
tic
cd_paths = generate_paths(circles, curves, graph, p0, G, AB_pts, stp, targets);
scd_path = find_shortest(cd_paths);
toc
myPaths = cell(1,47);
tmp = cd_paths;
for i=1:6
    [myPaths{i}, idx] = find_shortest(tmp);
    tmp = exclude(tmp, idx);
end


%% Path optimization using force vector fields algorithm
% for n=1:6
tic
path = scd_path;%myPaths{n};
thresh = 0.1;
Max_iter = 100;
real_edges = edge(image,'log');
real_curves = build_curves(real_edges, size, Nm, 0.5*rmin, metric, 0.5*stp, 0);
optimal_path = optimize_path(path, thresh, Max_iter, real_curves, rmin, stp);
toc
%
figure,
hold on;
optimal_path = [optimal_path; G];
plot(optimal_path(:,1),optimal_path(:,2),'LineWidth', 2);
L = [circles{1};circles{2}];
plot(L(:,1), L(:,2),'k-.');
plot(G(1),G(2),'g*');plot(p0(1),p0(2),'r*');

% plot(scd_path{1}(:,1),scd_path{1}(:,2),'g-');
axis equal;
L = [];
for i=1:length(obs)
    L = [L; obs{i}];
end
plot(L(:,1),L(:,2),'k.');

hold off;
xlabel('X (m)'); ylabel('Y (m)');
% legend('optimized','pre-optimized','obstacles','init. circles');
[Lp, Cp, Sp] = evaluate_path(optimal_path, obs, rmin)
% end
