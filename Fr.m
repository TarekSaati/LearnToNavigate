function out = Fr(k, path, objs, mar, Gr)

pt = path(k,:);
rep_dis = mar;
min_dis = inf*ones(1,length(objs));
ind = ones(1,length(objs));
for i=1:length(objs)
    dis_mat = pdist2(pt,objs{i}); 
    [min_dis(i), ind(i)] = min(dis_mat);
end
[rabs, nObj] = min(min_dis);
rk = objs{nObj}(ind(nObj),:) - pt;

if rabs >= rep_dis
    out = [0 0];
else
    out = Gr*(1 - (rep_dis/rabs))*rk; 
end

end