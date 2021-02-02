function out = Fc(pt,cntr,rmin,Gc)

hk = cntr - pt;
habs = dis(cntr, pt, 'p');
if habs < rmin
    out = Gc*(1 - rmin/habs)*hk;
else
    out = [0 0];   
end

end