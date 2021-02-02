function [W, V, S] = netUpdate( W, V, S, stp, grad, alpha, norm)   
   % Adam Optimizer Update Function 
    B1 = 0.9;
    B2 = 0.999;
    e = 1e-8;
       
    % Weight matrices of the Neural Network
    for i=1:length(W)
    for j=1:length(W{i})
        % Update weight matrices with Adaptive Momentum optimizer
        ngrad = grad{i}{j}/norm;
        V{i}{j} = B1*V{i}{j} + (1-B1)*ngrad;
        Vnorm = V{i}{j}/(1-B1^stp);
        S{i}{j} = B2*S{i}{j} + (1-B2)*(ngrad.^2);
        Snorm = S{i}{j}/(1-B2^stp);
        W{i}{j} = W{i}{j} - alpha*(Vnorm./(sqrt(Snorm)+e));
%                     ngrad = grad{j}/norm;
%                     W{j} = W{j} - alpha*ngrad;
    end
    end
    
end
