function [x, y] = circle(Center, radius, n_points)
    
	%Function is used to make circles using polar coordinates

    theta = linspace(0,2*pi, n_points);
    rho = ones(1, n_points)*radius;
    [x, y] = pol2cart(theta, rho);
    x = x + Center(1);
    y = y + Center(2);
    
    
end