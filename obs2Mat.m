function obs_mat = obs2Mat(h_circ, h_poly, nDynObs, DynObsRad)

if ~isempty(h_circ)
    P = get(h_circ(1),'Vertices');
    obs_mat = P(:,1:2);
    sp = (2*pi/length(P))*DynObsRad;
    for i=2:nDynObs
        P = get(h_circ(i),'Vertices');
        obs_mat = [obs_mat; P(:,1:2)];
    end
else
    sp = 0.1;
    obs_mat = [];
end
for i=1:length(h_poly)
    P = get(h_poly(i),'Vertices');
    for j=1:length(P)
        if P(j,1) == P(rot(j+1, length(P)),1)
            L = linspace(P(j,2), P(rot(j+1, length(P)),2), ...
                floor(abs(P(j,2)-P(rot(j+1, length(P)),2))/sp))';
            obs_mat = [obs_mat; [ones(length(L),1)*P(j,1) L]];
        elseif P(j,2) == P(rot(j+1, length(P)),2)
            L = linspace(P(j,1), P(rot(j+1, length(P)),1), ...
                floor(abs(P(j,1)-P(rot(j+1, length(P)),1))/sp))';
            obs_mat = [obs_mat; [L ones(length(L),1)*P(j,2)]];
        end
    end
end

end

