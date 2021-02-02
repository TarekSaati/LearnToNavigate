function belong = belongTo(Hd, colHeads)

belong = false;
for i=1:length(colHeads(:,1))
    if Hd >= colHeads(i,1) && Hd <= colHeads(i,2)
        belong = true;
    end
end

end

