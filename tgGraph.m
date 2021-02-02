function [pts1,pts2] = tgGraph(obs1,obs2,map_wd)
scale = 64;
obj_sp = dis(obs1(10,:),obs1(11,:),'p');
obj_stp = max(1,floor(map_wd/(obj_sp*scale)));
obs1 = obs1(1:obj_stp:end,:);
N1 = length(obs1(:,1));
N2 = length(obs2(:,1));
wght =  60/map_wd;
if N2 ~= 1
    obs2 = obs2(1:obj_stp:end,:);   N2 = length(obs2(:,1));
    c1 = cog(obs1); c2 = cog(obs2); cog_dist = dis(c1, c2, 'p');   
    l1 = zeros(1,N1+4);
    for i=1:N1+4
        l1(i+1) = l1(i)+dis(obs1(rot(i,N1),:),obs1(rot(i+1,N1),:),'p');
    end
    l2 = zeros(1,N2+4);
    for i=1:N2+4
        l2(i+1) = l2(i)+dis(obs2(rot(i,N2),:),obs2(rot(i+1,N2),:),'p');
    end
    lstp = 0.1*obj_stp*obj_sp;
    X1 = spline(l1,[obs1(:,1);obs1(1,1);obs1(2,1);obs1(3,1);obs1(4,1);obs1(5,1)]);
    Y1 = spline(l1,[obs1(:,2);obs1(1,2);obs1(2,2);obs1(3,2);obs1(4,2);obs1(5,2)]);
    span1 = l1(5):lstp:l1(end)+lstp;
    Ns1 = length(span1);
    
    dx1 = zeros(1,Ns1);
    dy1 = zeros(1,Ns1);
    for i=1:Ns1
        dx1(i) = (ppval(X1,span1(rot(i+1,Ns1)))-ppval(X1,span1(rot(i-1,Ns1))))/(span1(rot(i+1,Ns1))-span1(rot(i-1,Ns1)));
        dy1(i) = (ppval(Y1,span1(rot(i+1,Ns1)))-ppval(Y1,span1(rot(i-1,Ns1))))/(span1(rot(i+1,Ns1))-span1(rot(i-1,Ns1)));
    end
    X2 = spline(l2,[obs2(:,1);obs2(1,1);obs2(2,1);obs2(3,1);obs2(4,1);obs2(5,1)]);
    Y2 = spline(l2,[obs2(:,2);obs2(1,2);obs2(2,2);obs2(3,2);obs2(4,2);obs2(5,2)]);
    span2 = l2(5):lstp:l2(end)+lstp;
    Ns2 = length(span2);
    dx2 = zeros(1,Ns2);
    dy2 = zeros(1,Ns2);
    
    for i=1:Ns2
        dx2(i) = (ppval(X2,span2(rot(i+1,Ns2)))-ppval(X2,span2(rot(i-1,Ns2))))/(span2(rot(i+1,Ns2))-span2(rot(i-1,Ns2)));
        dy2(i) = (ppval(Y2,span2(rot(i+1,Ns2)))-ppval(Y2,span2(rot(i-1,Ns2))))/(span2(rot(i+1,Ns2))-span2(rot(i-1,Ns2)));
    end
    
    m1 = zeros(1,Ns1); m2 = zeros(1,Ns2);
    p1 = zeros(1,Ns1); p2 = zeros(1,Ns2);
    for i=1:Ns1
        m1(i) = dy1(i)/(dx1(i)+eps); p1(i) = ppval(Y1,span1(i)) - m1(i)*ppval(X1,span1(i));
    end
    for i=1:Ns2
        m2(i) = dy2(i)/(dx2(i)+eps); p2(i) =  ppval(Y2,span2(i)) - m2(i)*ppval(X2,span2(i));
    end
    idx1 = [];
    idx2 = [];
    for i=1:Ns1
        for j=1:Ns2
            J = min((atan(m1(i)) - atan(m2(j)))^2 + ((p1(i) - p2(j))*wght)^2,1);
            if J < 0.006*(wght*cog_dist)^1.2 && isempty(idx1)
                xi = ppval(X1,l1(5)+i*lstp); yi = ppval(Y1,l1(5)+i*lstp);
                xj = ppval(X2,l2(5)+j*lstp); yj = ppval(Y2,l2(5)+j*lstp);
                mij = (yj-yi)/(xj-xi);
                if abs(atan(mij)-atan(m2(j))) < 0.3
                    idx1 = [idx1;i];
                    idx2 = [idx2;j];
                end
            end
            if ~isempty(idx1) && J < 0.006*(wght*cog_dist)^1.2
                [M,id] = min(pdist2(atan(m1(idx1)'),atan(m1(i))));
                xs = ppval(X1,l1(5)+idx1*lstp); ys = ppval(Y1,l1(5)+idx1*lstp);
                xi = ppval(X1,l1(5)+i*lstp); yi = ppval(Y1,l1(5)+i*lstp);
                xj = ppval(X2,l2(5)+j*lstp); yj = ppval(Y2,l2(5)+j*lstp);
                min_dist = min(pdist2([xs ys],[xi yi]));
                mij = (yj-yi)/(xj-xi);
                if  M > 0.2 && abs(atan(mij)-atan(m2(j))) < 0.3
                    idx1 = [idx1;i];
                    idx2 = [idx2;j];
                elseif  M < 0.2 && min_dist*wght > 5 && abs(atan(mij)-atan(m2(j))) < 0.3
                    idx1 = [idx1;i];
                    idx2 = [idx2;j];
                end
            end
        end
    end
    pts1 = [ppval(X1,l1(5)+idx1*lstp) ppval(Y1,l1(5)+idx1*lstp)];
    pts2 = [ppval(X2,l2(5)+idx2*lstp) ppval(Y2,l2(5)+idx2*lstp)];
else
    
end
end
