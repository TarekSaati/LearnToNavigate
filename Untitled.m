%% GPU
N = 1000;
r = gpuArray.linspace(0,4,N);
x = rand(1,N,'gpuArray');
tic
numIterations = 1000;
for n=1:numIterations
    x = r.*x.*(1-x);
end
toc
plot(r,x,'.');

%% CPU

N = 1000;
r = linspace(0,4,N);
x = rand(1,N);tic
numIterations = 1000;
for n=1:numIterations
    x = r.*x.*(1-x);
end
toc
plot(r,x,'.');

%%
pol_params = gpuArray(pol_params);
o = 25*ones(1,11, 'gpuArray'); t = zeros(1,11, 'gpuArray'); inputs = [o, t];
gputimeit(@()arrayfun(@nnFeedForward,pol_params,input_layers_size,hidden_layers_sizes,output_layer_size,inputs));

%%
gpuDevice(1)
%%
A = 2*ones(1000,1, 'gpuArray'); B = 3*ones(1,1000, 'gpuArray'); %Q = myFun(A,B);
gputimeit(@()arrayfun(@myFun,A, B))
%%
A = 2*ones(1000,1); B = 3*ones(1,1000); %Q = myFun(A,B);
gputimeit(@()myFun(A, B))

%%
f1 = 0.9;
f2=0.9;
start = find(y3 > 0, 1);
init_reward = min(y4(1:start-1));
cost = y3(start:end);
reward = y4(start:end);
N = length(cost);
filt_reward = [init_reward, zeros(1,N-1)];filt_cost = [cost(1), zeros(1,N-1)];
for i=2:N
    filt_cost(i) = f1*filt_cost(i-1) + (1-f1)*cost(i);
    filt_reward(i) = f2*filt_reward(i-1) + (1-f2)*reward(i);
end
figure,
subplot(2,1,1)
plot(filt_cost, 'LineWidth', 2, 'Color', 'b');
hold on;
plot(cost, ':', 'LineWidth', 0.25, 'Color', 'c');
title('Average cost per episode');
xlabel('episodes');
subplot(2,1,2)
plot(filt_reward, 'LineWidth', 2, 'Color', 'r');
hold on;
plot(reward, ':', 'LineWidth', 0.25, 'Color', [1 0.5 0]);
title('Average reward per episode');
xlabel('episodes');

%%
px=0:80;
p=1./(10*sqrt(2*pi))*exp((-(px-40).^2)./(2*10^2));
out = randpdf(p,px,[32,1]);

%%
last_sample = 100;
E_error = 88.6227*(last_sample/100);
P_error = 0.8552;
a = ((last_sample^2)/E_error)*sqrt(pi/8);
samples = 1:last_sample;
out = maxwellBoltzmann_pdf(a,samples); out = out/P_error;
plot(samples, out);
sum(out)
[~,i] = max(out)
%%
L = [10.66, 10.14, 10.21]; C = [33 43 44]; cr = [12 13 37]; or = [16 10 11];
hold on;
plot(C,'LineWidth', 3); plot(cr, 'r-.'); plot(or, 'm--'); hold off;