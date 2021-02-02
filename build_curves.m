function curves = build_curves(edge_map, size, Nm, rmin, metric, stp, doPlot)

comp = bwconncomp(edge_map); N = comp.NumObjects;
map_wd = size(1); map_ht = size(2);
curves = cell(1,N);
if doPlot
    figure, hold on;
    for i=1:N
        p = comp.PixelIdxList{i};
        pts = (1/metric)*[ceil(p/Nm) Nm - mod(p, Nm)] - 0.5*[map_wd map_ht];
        pts = curvsort(pts,0);
%         pts = [-pts(:,1)+1.8, -pts(:,2)+8.4];
        filt_pts = obs_filt(pts,rmin,metric,stp);
        plot(filt_pts(:,1), filt_pts(:,2), 'b.');
        curves{i} = filt_pts;
    end
    hold off; axis equal;
else
    for i=1:N
        p = comp.PixelIdxList{i};
        pts = (1/metric)*[ceil(p/Nm) Nm - mod(p, Nm)] - 0.5*[map_wd map_ht];
        pts = curvsort(pts,0);
%         pts = [-pts(:,1)+1.8, -pts(:,2)+8.4];
        filt_pts = obs_filt(pts,rmin,metric,stp);
        curves{i} = filt_pts;
    end
end