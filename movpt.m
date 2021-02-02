function out = movpt(pt,d,th)
% rotate coordinates towards the destination then move to it
M = [1   0    d*cos(th) - d*sin(th);
     0   1    d*sin(th) + d*cos(th);
     0   0           1];
out = M*[pt';1];
out = [out(1) out(2)];
end

