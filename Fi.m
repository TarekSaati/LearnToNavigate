function out = Fi(k,path,stp,Gi)

pre = path(k-1,:);
pnt = path(k,:);
lk = [pre(1)-pnt(1), pre(2)-pnt(2)];
bk = 1 - stp/sqrt(lk(1)^2 + lk(2)^2);
if k ~= length(path)
    post = path(k+1,:);
    lk1 = [pnt(1)-post(1), pnt(2)-post(2)];
    bk1 = 1 - stp/sqrt(lk1(1)^2 + lk1(2)^2);
    
    out = Gi*(bk*lk - bk1*lk1);
else 
    out = Gi*bk*lk;
end

end

