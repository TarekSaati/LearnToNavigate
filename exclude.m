function ex_mat = exclude(mat,index)

ex_mat = {};
j = 0;
for i=1:length(mat)
    if index ~= i
        j = j+1;
        ex_mat(j) = mat(i);
    end
end
