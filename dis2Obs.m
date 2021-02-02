function distances = dis2Obs(obs_mat, rot_center, tot_rot, range, n_sensors)

No = length(obs_mat);
angle = zeros(1, No);
allDist = pdist2(obs_mat, rot_center);
tot_rot = tot_rot+2*pi*(tot_rot<0);

for i=1:No
    angle(i) = atan2(obs_mat(i,2)-rot_center(2), obs_mat(i,1)-rot_center(1));
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
distances = dis_mat;
if ind > 1
    distances = [dis_mat(ind:end); dis_mat(1:ind-1)];
end
end

