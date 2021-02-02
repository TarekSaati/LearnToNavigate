function [C, grad] = BackPropagation(pol_params, obsv, streamSizes, actions, a, Q_est)

f = @(x) x;
df = @(x) 1;
n_actions = length(actions);
I = eye(n_actions);
[Q, L, Z] = FeedForward(pol_params, obsv, streamSizes, @ReLU, f);
C = 0.5*(Q(a) - Q_est)^2;
dQ = (Q(a) - Q_est).*I(:,a);
nStreams = length(streamSizes); Nc = zeros(1, nStreams); Nh = cell(1, nStreams);
grad = cell(1, nStreams); last_node = 0;
for i=1:nStreams
    j = nStreams - i + 1;
    Nc(j) = streamSizes{j}(end);
    if length(streamSizes{j}) < 3, Nh{j} = [];
    else, Nh{j} = streamSizes{j}(2:end-1); end
    if j == nStreams 
%         if nStreams == 1 && Q_est == 100, L{1}{1}=[1; zeros(128,1); L{1}{1}(130:end)];
%         elseif nStreams == 1 && Q_est == -100, L{1}{1}=[L{1}{1}(1:end-2); zeros(2,1)]; end
        [grad{j}, dL] = nnBackPropagation(pol_params{j}, L{j}, Z{j}, dQ, ...
                                Nh{j}, @dReLU, df);
    elseif j < nStreams && nStreams > 1
        [grad{j}, ~] = nnBackPropagation(pol_params{j}, L{j}, Z{j}, ...
                    dL(end-Nc(j)-last_node+1:end-last_node), Nh{j}, @dReLU, @dReLU);
        last_node = last_node + Nc(j);  
    end
end

end

