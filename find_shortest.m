function [scd_path, idx] = find_shortest(cd_paths)

len = zeros(1,length(cd_paths));
for i=1:length(cd_paths)
    p = cd_paths{i}{1};
%     len(i) = cd_paths{i}{2};
    for j=1:cd_paths{i}{2}-1
       len(i) = len(i) + dis(p(j,:), p(j+1,:), 'p'); 
    end
end
[~, idx] = min(len);
scd_path = cd_paths{idx};
tmp = {[0 0]}; k = 0;
for i=1:length(scd_path{1})-1
   if ~isequal(scd_path{1}(i,:),scd_path{1}(i+1,:))
       k = k+1;
       tmp{1}(k,:) = scd_path{1}(i,:);
   end
end
scd_path{1} = tmp{1};
scd_path{2} = length(tmp{1});
scd_path{3} = cd_paths{idx}{3};

end

