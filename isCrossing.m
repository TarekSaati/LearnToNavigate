function cross = isCrossing(line, curve, z)

x1 = line(1,:); x2 = line(2,:);
N = length(curve); cross = false;
for i=1:3:N
    I = inter_pt(x1, x2, curve(i,:),curve(rot(i+z,N),:));
    if abs(dis(I, curve(i,:), 'p') + dis(I, curve(rot(i+z,N),:), 'p') ...
            - dis(curve(i,:), curve(rot(i+z,N),:), 'p')) < 1e-5 ...
            && dis(x1, curve(i,:), 'p') < dis(x1, x2, 'p') ...
            && dis(x2, curve(i,:), 'p') < dis(x1, x2, 'p')
        cross = true;
    end
end

end

