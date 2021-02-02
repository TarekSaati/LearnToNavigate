function out = obs_filt(pts,rmin,metric,stp)

n = length(pts);
resol = floor(rmin*metric);
curv = pts(1:resol:n,:);
n = length(curv);
l = zeros(1,n+4);
for i=1:n+4
    l(i+1) = l(i)+dis(curv(rot(i,n),:),curv(rot(i+1,n),:),'p');
end
X = spline(l,[curv(:,1);curv(1,1);curv(2,1);curv(3,1);curv(4,1);curv(5,1)]); 
Y = spline(l,[curv(:,2);curv(1,2);curv(2,2);curv(3,2);curv(4,2);curv(5,2)]);
span = l(5):0.5*stp:l(end);
curv = [ppval(X,span)' ppval(Y,span)'];
out = curv;
n = length(curv);
rad = inf(n,1);
for j=1:2               % clockwise & c.clockwise filtering
    n = length(curv);
    for i=1:n      
        rad(i) = rot3p(curv(rot(i-1,n),:),curv(i,:),curv(rot(i+1,n),:));
        while rad(i) < rmin
            curv(i,:) = 0.1*curv(i,:) + 0.45*(curv(rot(i-1,n),:) + curv(rot(i+1,n),:));
            rad(i) = rot3p(curv(rot(i-1,n),:),curv(i,:),curv(rot(i+1,n),:));
        end       
    end
    curv = flipud(curv);
    out = curv;
end