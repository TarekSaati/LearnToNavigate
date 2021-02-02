function [graph, AB_pts] = build_restricted_graph(graph_curves, curves, targets, obs, G, rmin, stp, tol, doPlot)

circles = graph_curves(1:2);
graph_obs = graph_curves(3:end);
AB_pts = cell(1,length(graph_curves));
tmp = [];
graph = cell(1,length(targets));
n_tar = length(targets);        
for n=1:n_tar+1
    cObj = graph_curves{n};
    cnt = 0; 
    for j=1:n_tar           % restricted curves including goal point
        if n > 2 && j > 1 && n == j+1, continue, else   % pass same obstacle
        ang_mat = []; x_mat = [];
        for i=1:length(cObj)
            pre = cObj(rot(i-1,length(cObj)),:);
            post = cObj(rot(i+1,length(cObj)),:);
            dir = atan2(post(2)-pre(2),post(1)-pre(1)) + eps;
            dir = dir - (sign(dir)-1)*pi;
%             cvx = [0 0 0];
            if j ~= 1
                X = [cObj(i,:); graph_obs{j-1}];
                cvx = convhull(X);
                x = [X(cvx(2),:); X(cvx(end-1),:)];
            else
                x = G;
            end
            ang = zeros(1,length(x(:,1)));
            for m=1:length(x(:,1))
                ang(m) = atan2(x(m,2)-graph_curves{n}(i,2), x(m,1)-graph_curves{n}(i,1)) + eps;
                ang(m) = ang(m) - (sign(ang(m))-1)*pi;
                cancel = false;
                if ((n<3) && (abs(ang(m)-dir)<tol  || 2*pi-abs(ang(m) - dir)<tol)) ...
                        || ((n>=3) && (abs(ang(m)-dir)<tol  || 2*pi-abs(ang(m) - dir)<tol ...
                        || abs(abs(dir - ang(m))-pi)<tol))
                    for l=1:length(ang_mat)
                        if ~isempty(ang_mat) && abs(ang(m) - ang_mat(l)) < tol ...
                                && isequal(x(m,:),x_mat(l,:))
                            cancel = true;
                        end
                    end
                    
                    n_obs = length(curves);
                    for k=1:n_obs               % Detection for intersection with obstacles
                        obj = curves{k};
                        No = length(curves{k});
                        z = floor(rmin/stp)+3;
                        if n>2 && targets(max(1,n-1)) == k
                            if i>z && i<No-z
                                obj = [curves{k}(i+z:end,:); ...
                                    curves{k}(1:i-z,:)];
                            elseif i<z
                                obj = curves{k}(i+z:No-z+i,:);
                            elseif i>No-z
                                obj = curves{k}(rot(i+z,No):i-z,:);
                            end
                        end
                        if isCrossing([x(m,:); cObj(i,:)], obj, z)
                            cancel = true;
                        end
                    end

                    if ~cancel
                        ang_mat = [ang_mat ang(m)];
                        x_mat = [x_mat; x(m,:)];
                        if ~isempty(AB_pts{n})
                            [dist, idx] = min(pdist2(cObj(i,:), AB_pts{n}{1}));
                        else
                           dist = inf; 
                        end
                        if (n>2 && dist > 2*stp) || n<=2
                            cnt = cnt + 1;
                            AB_pts{n}{1}(cnt,:) = cObj(i,:);
                            AB_pts{n}{2}(cnt) = i;
                            graph{n}{cnt}(1:2,1:4) = [[cObj(i,:) -1 -1]; ...
                                [x(m,:) j (m-1)*(cvx(end-1)-1)+(2-m)*(cvx(2)-1)]];
                        else
                            graph{n}{idx}(end+1,1:4) = [x(m,:) j ...
                                (m-1)*(cvx(end-1)-1)+(2-m)*(cvx(2)-1)];
                        end
                    s = linspace(0,1,50*dis(graph{n}{cnt}(1,:),graph{n}{cnt}(2,:),'p'));
                        col1 = graph{n}{cnt}(2,1)+s*(graph{n}{cnt}(1,1) - graph{n}{cnt}(2,1));
                        col2 = graph{n}{cnt}(2,2) + s*(graph{n}{cnt}(1,2) - graph{n}{cnt}(2,2));
                        tmp = [tmp; col1', col2'];
                    end
                end
            end
        end
        end
    end
end

if doPlot
    figure,
    hold on;
    plot(circles{1}(:,1), circles{1}(:,2),'r-.'); 
    plot(circles{2}(:,1), circles{2}(:,2),'b-.');
    for i=1:length(obs)
       plot(obs{i}(:,1), obs{i}(:,2), 'k.')
    end
    plot(tmp(:,1), tmp(:,2), 'g.');
    axis equal;
    hold off;
end
end

