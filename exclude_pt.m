function ex_mat = exclude_pt(mat,index)

ex_mat = zeros(length(mat),2);
j = 0;
for i=1:length(mat(:,1))
    x = find(index==i, 1);
    if isempty(x)
        j = j+1;
        ex_mat(j,:) = mat(i,:);
    end
end
lastID = find(ex_mat(:,1)==0,1)-1;
ex_mat = ex_mat(1:lastID,:);