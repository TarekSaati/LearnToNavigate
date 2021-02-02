function out = curvsort(curv,idx)

if idx == 0    
    dist = pdist2(curv,curv);
    N = size(curv,1);
    out = zeros(N,2);
    result = NaN(1,N);
    result(1) = 1; % first point is the first row in data matrix
    
    for i=2:N
        dist(:,result(i-1)) = Inf;
        [~, closest_idx] = min(dist(result(i-1),:));
        result(i) = closest_idx;
    end
    
    for i=1:N
        out(i,:) = curv(result(i),:);
    end
else
    switch idx
        case 1
            out = curv;
        case length(curv)
            out = [curv(idx); curv(1:end-1,:)];
        otherwise
            out = [curv(idx:end,:); curv(1:idx-1,:)];
    end
end
% curve dimentions: n*2 (n points)
%     out = zeros(length(curv),2);
%     out(1,:) = curv(1,:);
%     
%     for i=2:length(curv)
%         if dis(curv(i,:),out(1,:), 'p') < 1.5
%             out(2,:) = curv(i,:);
%         end
%     end
%     for i=3:length(curv)
%         dist = [];
%         index = [];
%         for j=2:length(curv)
%             if dis(curv(j,:),out(i-1,:), 'p') < 1.5 && dis(curv(j,:),out(i-1,:), 'p') ~= 0 &&...
%                     dis(curv(j,:),out(i-2,:), 'p') ~= 0
%                dist = [dist; dis(curv(j,:), out(i-1,:), 'p')];
%                index = [index; j];
%             end
%         end
%         [~, m] = min(dist);
%         out(i,:) = curv(index(m),:);
%     end
end

