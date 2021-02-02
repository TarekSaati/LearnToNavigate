function diff = angDiff(ang1,ang2)

% angles must be in range [-pi, pi] like atan2 function
% diff < 0 when ang1 is smaller than ang2 && difference < pi/2

diff = ang1-ang2;
if cos(ang1) < 0 && cos(ang2) < 0 && sin(ang1) < 0 && sin(ang2) > 0
    a1 = pi-ang2;
    a2 = pi+ang1;
    diff = a1+a2;
elseif cos(ang1) < 0 && cos(ang2) < 0 && sin(ang1) > 0 && sin(ang2) < 0
    a1 = pi-ang1;
    a2 = pi+ang2;
    diff = -(a1+a2);
end

end

