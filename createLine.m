function line = createLine(p1, p2, spacing)

L = linspace(0,1,dis(p1, p2, 'p')/spacing)'; L = L(2:end);
line = [p1(1) + (p2(1)-p1(1))*L, p1(2) + (p2(2)-p1(2))*L];

end

