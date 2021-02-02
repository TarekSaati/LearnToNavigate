function [p, right, left] = createCorridor(pathPoints, goal, margin, spacing)

pt = pathPoints(end,:); l = linspace(0,1,dis(pt,goal,'p'))'; l=l(2:end);
l2g = [pt(1) + l*(goal(1)-pt(1)), pt(2) + l*(goal(2)-pt(2))];
p = [pathPoints; l2g];
n = length(p);
l = zeros(1,n);
for i=1:n-1
    l(i+1) = l(i)+dis(p(i,:),p(i+1,:),'p');
end
stp = 0:spacing:l(end);
spVar = [spline(l, p(:,1)), spline(l, p(:,2))];
pathSpline = [ppval(spVar(1), stp)', ppval(spVar(2), stp)'];
n = length(pathSpline);
p = pathSpline;
right = []; left = []; cnt = 0;
for i=1:2:n
    cnt = cnt+1;
    pre = max(1, i-1); post = min(n, i+1);
    ang = atan2(p(post,2)-p(pre,2), p(post,1)-p(pre,1));
    right(cnt,:) = p(i,:) + [margin*cos(ang-pi/2), margin*sin(ang-pi/2)];
    left(cnt,:) = p(i,:) + [margin*cos(ang+pi/2), margin*sin(ang+pi/2)];
end
n = length(right); cnt = 1;
for i=1:n-2
    if cnt >= length(right)-2, break; end
    cnt = cnt+1;
    dist = pdist2(right(cnt,:), flipud(right(cnt+3:end,:)));
    ind = find(dist < 4*spacing);
   if ~isempty(ind)
       ind = ind(1);
       right = [right(1:cnt,:); right(end-ind:end,:)];
   end
end
n = length(left); cnt = 1;
for i=1:n-2
    if cnt >= length(left)-2, break; end
    cnt = cnt+1;
    dist = pdist2(left(cnt,:), flipud(left(cnt+3:end,:)));
    ind = find(dist < 4*spacing);
   if ~isempty(ind)
       ind = ind(1);
       left = [left(1:cnt,:); left(end-ind:end,:)];
   end
end
n1 = length(right); n2 = length(left); cnt = 1; cut = 1;
while cut
    cut = 0;
    for i=2:n1-1
        cnt = cnt+1;
        if cnt >= length(right)-1, break; end
        ang1 = atan2(right(cnt-1,2)-right(cnt,2), right(cnt-1,1)-right(cnt,1));
        ang2 = atan2(right(cnt+1,2)-right(cnt,2), right(cnt+1,1)-right(cnt,1));
        delta = ang1-ang2; delta = delta+2*pi*(delta<=-pi)-2*pi*(delta>pi);
        if abs(delta) < 1.5*pi
            cut = 1;
            right = [right(1:cnt-1,:); right(cnt+1:end,:)];
        end
    end
end
cnt = 1; cut = 1;
while cut
    cut = 0;
    for i=2:n2-1
        cnt = cnt+1;
        if cnt >= length(left)-1, break; end
        ang1 = atan2(left(cnt-1,2)-left(cnt,2), left(cnt-1,1)-left(cnt,1));
        ang2 = atan2(left(cnt+1,2)-left(cnt,2), left(cnt+1,1)-left(cnt,1));
        delta = ang1-ang2; delta = delta+2*pi*(delta<=-pi)-2*pi*(delta>pi);
        if abs(delta) < 1.5*pi
            left = [left(1:cnt-1,:); left(cnt+1:end,:)];
        end
    end
end
n1 = length(right); n2 = length(left);
l1 = zeros(1,n1); l2 = zeros(1,n2);
for i=1:n1-1
    l1(i+1) = l1(i) + dis(right(i,:),right(i+1,:),'p');
end
for i=1:n2-1
    l2(i+1) = l2(i) + dis(left(i,:),left(i+1,:),'p');
end
stp1 = 0:spacing:l1(end); stp2 = 0:spacing:l2(end);
spVar1 = [spline(l1, right(:,1)), spline(l1, right(:,2))];
spVar2 = [spline(l2, left(:,1)), spline(l2, left(:,2))];
right = [ppval(spVar1(1), stp1)', ppval(spVar1(2), stp1)'];
left = [ppval(spVar2(1), stp2)', ppval(spVar2(2), stp2)'];

end

