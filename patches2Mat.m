function mat = patches2Mat(patches, sp)

L = linspace(-25, -10, 15/sp)';
mat = [32*ones(length(L),1), L];
L = linspace(10, 25, 15/sp)';
mat = [mat; [67*ones(length(L),1), L]];
L = linspace(70, 100, 30/sp)';
mat = [mat; [L, -10*ones(length(L),1)]];
L = linspace(0, 30, 30/sp)';
mat = [mat; [L, 10*ones(length(L),1)]];
for i=1:length(patches)
    P = get(patches(i),'Vertices');
    for j=1:length(P)
        if P(j,1) == P(rot(j+1, length(P)),1)
            L = linspace(P(j,2), P(rot(j+1, length(P)),2), ...
                floor(abs(P(j,2)-P(rot(j+1, length(P)),2))/sp))';
            mat = [mat; [ones(length(L),1)*P(j,1) L]];
        elseif P(j,2) == P(rot(j+1, length(P)),2)
            L = linspace(P(j,1), P(rot(j+1, length(P)),1), ...
                floor(abs(P(j,1)-P(rot(j+1, length(P)),1))/sp))';
            mat = [mat; [L ones(length(L),1)*P(j,2)]];
        end
    end
end

end

