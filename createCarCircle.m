function createCarCircle(radius, range, color, center, angle)
    global h_car
    cx0 = center(1); cy0 = center(2);
    [X,Y] = circle([cx0, cy0], radius, 10);                        
    car = patch(X,Y, color);                                   
    set(car,'FaceLighting','flat','EdgeLighting','flat');
    n_sensors = 200;
    theta0 = angle;
    % Sensor properties
    n_points = 2;              % Number of points of the sensors
    x = cx0*ones( n_sensors , n_points ) ; y = cy0*ones(n_sensors , n_points); 
    %x-coords for 10 range sensors lines 
    for i=1:n_sensors
        theta = (2*pi*(i-1))/n_sensors + theta0;
        x(i,:) = linspace(radius*cos(theta)+cx0, (radius+range)*cos(theta)+cx0 , n_points);
        if theta ~= pi/2 && theta ~= 3*pi/2    
            y(i,:) = cy0*ones(1,n_points)+tan(theta)*(x(i,:)-cx0*ones(1,n_points));
        else
            y(i,:) = linspace(cy0+sin(theta)*radius, cy0+sin(theta)*(radius+range), n_points);
        end
    end
    % Create sensors
%     L_h = zeros(1,n_sensors);
%     for i=1:n_sensors
%         if i == n_sensors
%             L_h(i) = patch(x(i,:)', y(i,:)', 'k', 'EdgeColor','w');
%         else
%             L_h(i) = patch(x(i,:)', y(i,:)', 'k', 'EdgeColor','w', ...
%                 'LineStyle', ':', 'LineWidth', 0.1);
%         end
%        set(L_h(i),'FaceLighting','flat','EdgeLighting','flat');
%     end
L_h = patch(x(1,:)', y(1,:)', 'k', 'EdgeColor','g');
    
    h_car = [car ,L_h];    
end