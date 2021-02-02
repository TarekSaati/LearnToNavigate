function dynObsInit(maxVel, nDynObs)

global h_circ headings speeds centers radii reflected 

headings = zeros(1, nDynObs);    % initial heading for dynamic obstacles
speeds = zeros(1, nDynObs);
centers = zeros(nDynObs, 2);
for k=1:nDynObs
    headings(k) = rand()*2*pi;
    speeds(k) = 0.25 + rand()*(maxVel-0.25);
    P = get(h_circ(k), 'Vertices');
    centers(k,:) = [(min(P(:,1))+max(P(:,1)))/2, (min(P(:,2))+max(P(:,2)))/2];
    radii(k) = sqrt((centers(k,1)-P(1,1))^2+(centers(k,2)-P(1,2))^2);
    reflected(k) = nan;
end
for i=2:nDynObs
    %     fprintf('%6s%3d\n','obs:',i);
    colHeads = [];
    for k=1:i-1
        colHeads = [colHeads; col_headings(centers(i,:), centers(k,:), headings(k), ...
            speeds(i), speeds(k), radii(i), radii(k))];
    end
    Hd = 2*pi*rand()-pi; cnt=0;
    if ~isempty(colHeads)
        while belongTo(Hd, colHeads) && cnt < 100
            cnt = cnt+1;
            Hd = 2*pi*rand()-pi;
        end
    end
    headings(i) = Hd;
end

end

