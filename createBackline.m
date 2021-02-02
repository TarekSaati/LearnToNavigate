function backline = createBackline(path, backSpace, margin, i)

pre = path(max(1, i-1),:); post = path(min(length(path), i+1),:);
ang = atan2(pre(2)-post(2), pre(1)-post(1));
sp = dis(path(1,:), path(2,:), 'p');
backStep = ceil(backSpace/sp);
if backStep >= i
    backPoint = [path(i,1) + backSpace*cos(ang), path(i,2) + backSpace*sin(ang)];
else
    backPoint = path(i-backStep,:);
end
sidePoint1 = [backPoint(1) + margin*cos(ang-pi/2), ...
    backPoint(2) + margin*sin(ang-pi/2)];
sidePoint2 = [backPoint(1) + margin*cos(ang+pi/2), ...
    backPoint(2) + margin*sin(ang+pi/2)];
backline = createLine(sidePoint1, sidePoint2, sp);
end

