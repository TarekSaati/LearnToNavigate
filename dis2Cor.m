function distances = dis2Cor(cor_mat, rot_center, tot_rot, range, n_sensors)

No = length(cor_mat);
angle = zeros(1, No);
allDist = pdist2(cor_mat, rot_center);
tot_rot = tot_rot+2*pi*(tot_rot<0);

for i=1:No
    angle(i) = atan2(cor_mat(i,2)-rot_center(2), cor_mat(i,1)-rot_center(1));
    angle(i) = angle(i)+2*pi*(angle(i)<0);
end
dis_mat = inf*ones(n_sensors,1);
ind = 1;
for i=1:n_sensors
    for j=1:No
        if angle(j) >= 2*pi*(i-1)/n_sensors && angle(j) < 2*pi*i/n_sensors ...
                && allDist(j) < dis_mat(i)
            dis_mat(i) = allDist(j);
        end
    end
    if tot_rot >= 2*pi*(i-1)/n_sensors && tot_rot < 2*pi*i/n_sensors
        ind = i;
    end
    dis_mat(i) = min(range, dis_mat(i));
end
if ind > 1
    dis_mat = [dis_mat(ind:end); dis_mat(1:ind-1)];
end
distances = [dis_mat(3*n_sensors/4+1:end); dis_mat(1:n_sensors/4)];
end

