function handleCrashDynamics(obs_mat)

global h_circ headings speeds centers radii reflected

Nobs = length(h_circ);
for j=1:Nobs
    min_d = speeds(j)+radii(j);
    allDist = pdist2(centers(j,:), obs_mat);
    [d, ind] = min(allDist);
    THg = atan2(obs_mat(ind,2)-centers(j, 2), obs_mat(ind,1)-centers(j, 1));
    delta = 0;
    if ~isnan(reflected(j))
        ang = reflected(j);
        delta = angDiff(ang, THg);
    end
    if  d <= min_d && (abs(delta) > pi/4 || isnan(reflected(j)))      
        f = 1.9;
        T1 = (THg - pi/f)*(THg - pi/f >= -pi) + (THg + (2*f-1)*pi/f)*(THg - pi/f < -pi);
        T2 = (THg + pi/f)*(THg + pi/f <= pi) + (THg - (2*f-1)*pi/f)*(THg + pi/f > pi);
        validHeads = angRange(T1, T2);
        colHeads = [];
        for k=1:Nobs
            if k~=j
                colHeads = [colHeads; col_headings(centers(j,:), centers(k,:), ...
                    headings(k), speeds(j), speeds(k), radii(j), radii(k))];
            end
        end
        Hd = angSample(validHeads);
        cnt = 0;
        if ~isempty(colHeads)  
            while belongTo(Hd, colHeads)
                Hd = angSample(validHeads);
                cnt = cnt+1;
                if cnt == 100
                    ang = headings(j);
                    delta = angDiff(ang, THg);
                    if delta ~= 0
                        headings(j) = headings(j) +sign(delta)* 2*(pi/2 - abs(delta));
                    else
                        headings(j) = headings(j) - sign(headings(j))*pi;
                    end
                    break;
                end
            end
        end
        if cnt < 100
            headings(j) = Hd; 
        end
        reflected(j) = THg;
    end   
end


