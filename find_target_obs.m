function target_obs = find_target_obs(curves, start, goal)

target_obs = 0;           % '0' represents Goal point
for i=1:length(curves)
    cObj = curves{i};
    for j=1:length(cObj)
        pt = cObj(j,:);
        if (dis(pt, goal, 'p') < dis(start, goal, 'p') ...
                && dis(pt, start, 'p') < dis(start, goal, 'p'))
                target_obs = [target_obs, i];
                break;
        end
    end
end

end

