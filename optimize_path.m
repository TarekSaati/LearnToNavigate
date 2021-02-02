function optimal_path = optimize_path(path, thresh, Max_iter, curves, rmin, stp)

init_pt = path{3}+1;
len = path{2};
goal = path{1}(end,:);
V = zeros(len-init_pt+1, 2);
F = zeros(len-init_pt+1, 2);
Gi = 0.7;
Gr = 1.2;
Gp = 1.5;
Gn = 0.7;
Fmar = 1.2*rmin;
iter = 0;
change = inf;
while change > thresh && iter <= Max_iter
    for k=init_pt:len-1
        fi = Fi(k, path{1}, stp, Gi);
        fr = Fr(k, path{1}, curves, Fmar, Gr);
        F(k-init_pt+1,:) = fi + fr;
    end
    F(end,:) = Fp(path{1}(len,:), goal, Gp) + Fi(len, path{1}, stp, Gi);
    V = Gn*V + F;
    path{1}(init_pt:end,:) = path{1}(init_pt:end,:) + V;
    
    change = sum(sqrt(V(:,1).^2+V(:,2).^2));
    cnt = 0;
     if change < 3*thresh
        for i=init_pt:len-1
            r = rot3p(path{1}(i-1,:), path{1}(i,:), path{1}(i+1,:));
            d = min(pdist2(path{1}(i,:), path{1}(i+1:end,:)));
            if ~isnan(path{1}(i,1)) && d > 0.5*stp && r >= rmin
                cnt = cnt+1;
                new_path(cnt,:) = path{1}(i,:);
                new_F(cnt,:) = F(i-init_pt+1,:);
                new_V(cnt,:) = V(i-init_pt+1,:);
            end
        end
        new_path(cnt+1,:) = path{1}(len,:);
        new_F(cnt+1,:) = 0;
        new_V(cnt+1,:) = V(end,:);
        path{1} = [path{1}(1:init_pt-1,:); new_path];
        V = new_V;
        F = new_F;
        len = length(path{1});
     end
    iter = iter + 1;
%     disp(['iter: ',num2str(iter), '  sum(|v|): ', num2str(change)]);

end
optimal_path = path{1};
end

