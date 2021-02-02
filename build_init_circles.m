function [circles, cntrs] = build_init_circles(p0, rmin, stp)

theta0 = p0(3);
cr = [p0(1) + rmin*sin(theta0) p0(2) - rmin*cos(theta0)];
cl = [p0(1) - rmin*sin(theta0) p0(2) + rmin*cos(theta0)];
cntrs = [cr; cl];
% circles
lswp = linspace(theta0,2*pi+theta0-(2*pi/(floor(4*pi*rmin/stp)-1)),4*pi*rmin/stp)';
rswp = linspace(2*pi+theta0,theta0+(2*pi/(floor(4*pi*rmin/stp)-1)),4*pi*rmin/stp)';
rcircle = [-rmin*sin(rswp)+cr(1), rmin*cos(rswp)+cr(2)];
lcircle = [rmin*sin(lswp)+cl(1), -rmin*cos(lswp)+cl(2)];
circles = {rcircle, lcircle};

end

