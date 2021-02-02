function colHeads = col_headings(Pi, Pj, Hj, Vi, Vj, Ri, Rj)

Rs = Ri + Rj;
colHeads = [];
Pf = Pj + [100*cos(Hj), 100*sin(Hj)];
N = 1e3; ti = zeros(1,N); tj = zeros(1,N); dif = zeros(1,N); Px = zeros(N,2);
for i=1:N
    L = i/N;
    Px(i,:) = L*Pf+(1-L)*Pj;
    ti(i) = dis(Px(i,:),Pi,'p')/Vi;
    tj(i) = dis(Px(i,:),Pj,'p')/Vj;
    dif(i) = abs(ti(i) - tj(i));
end
for i=2:N-1
    if dif(i) < dif(i-1) && dif(i) < dif(i+1)
       Px1 = Px(i,:) + 1.2*[Rs*cos(Hj), Rs*sin(Hj)];
       Px2 = Px(i,:) - 1.2*[Rs*cos(Hj), Rs*sin(Hj)];
       T1 = atan2(Px1(2)-Pi(2), Px1(1)-Pi(1));
       T2 = atan2(Px2(2)-Pi(2), Px2(1)-Pi(1)); 
       colHeads = [colHeads; angRange(T1, T2)];
    end
end
end
