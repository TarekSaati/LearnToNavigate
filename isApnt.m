function index = isApnt(pnt,nObj,A_pts,stp)

index = -1;
N = length(A_pts{nObj}{2});
for i=1:N
    if dis(A_pts{nObj}{1}(i,:), pnt, 'p') < 2*stp
        index = i;
    end
end

end

