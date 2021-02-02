function range = angRange(T1, T2)

    diff = max(T1,T2)-min(T1,T2);
    if diff < pi
        range = [min(T1, T2), max(T1, T2)];
    else
       range = [max(T1, T2), pi; -pi, min(T1, T2)]; 
    end
    
end

