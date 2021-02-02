function [obs, N] = find_obstacles(map, size, Nm, metric, doPlot)

map_wd = size(1); map_ht = size(2);
comp = bwconncomp(map); N = comp.NumObjects;
obs = cell(1,N);
if doPlot
    figure, hold on; axis equal;
    for i = 1:N
        p = comp.PixelIdxList{i};
        pts = (1/metric)*[ceil(p/Nm) Nm - mod(p, Nm)] - 0.5*[map_wd map_ht];
%         pts = [-pts(:,1)+1.8, -pts(:,2)+8.4];
        obs{i} = pts;
        plot(pts(:,1),pts(:,2),'k.');
    end
    hold off;
else
    for i = 1:comp.NumObjects
        p = comp.PixelIdxList{i};
        pts = (1/metric)*[ceil(p/Nm) Nm - mod(p, Nm)] - 0.5*[map_wd map_ht];
%         pts = [-pts(:,1)+1.8, -pts(:,2)+8.4];
        obs{i} = pts;
    end
end

