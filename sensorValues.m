function [sensor_value, crash] = sensorValues(sensor_vertices, obstacle, shape, dist_crash)

    %Function to find the distance between agent and obstacles via sensors

    crash = false;

    P = obstacle;                   %obstacles
    Qx = sensor_vertices(:,1);      %x-the points of the sensor
    Qy = sensor_vertices(:,2);      %y-the points of the sensor
    sensor_value = norm([Qx(end) - Qx(1), Qy(end) - Qy(1)]);    %value of the sensor

    Qx_min = min(Qx);               
    Qx_max = max(Qx);

    Qy_min = min(Qy);
    Qy_max = max(Qy);

    n_points = 7000;
    x = linspace(Qx_min, Qx_max, n_points)';    %Creates an x-vector with 7000 points
    y = linspace(Qy_min, Qy_max, n_points)';    %Creates an x-vector with 7000 points
    n_x = length(x);        
    dist_between = 0.2;     %length between sensor and obstacles

    %Calculate the equation for the sensor (Straight line)
    b = Qy(end)- Qy(1);
    c = Qx(end)- Qx(1);

    if( c ~= 0 )
        a = b/c;                        %slope
        y = a.*(x - Qx(1)) + Qy(1);     
    else
        n_points = length(y);
        x = Qx(1).*ones(n_points,1);
    end

    %Circle obstacle
    if( strcmp(shape,'circle') )
        
        a = (min(P(:,1)) + max(P(:,1)))/2;
        b = (min(P(:,2)) + max(P(:,2)))/2;

        centre = [a, b];
        radius = norm([P(1,1) - centre(1), P(1,2) - centre(2)] );

        %Calculate the circle functions of the obstacle P
        f1 =  sqrt( radius.^2 - (x - a).^2 ) + b;
        f2 = -sqrt( radius.^2 - (x - a).^2 ) + b;
        
        %Checks the difference between the sensor function y and the function of the obstacle f
        g1 = abs(y - f1);
        g2 = abs(y - f2);
        
        %If the difference is less than dist_between, then the sensor is reflected
        I1 = find( g1 < dist_between);
        I2 = find( g2 < dist_between);
        I = [I1; I2];
          
        if( ~isempty(I) )
            
            %Calculate the sensor value
            sensor_value = min(dist([x(I), y(I)], [Qx(1); Qy(1)]));
            
            %Crash if sensor value gives less than dist_crash
            if(sensor_value < dist_crash)

                crash = true;
            end

        end

    %Check by def. Polygon edges
    elseif( strcmp(shape,'polygon') )

        n_punkter = size(P,1);
        
        %Find the features f(x) = a*(x-x0) + f(x0) for the edges of the obstacle
        for i = 1:n_punkter-1
  
            f = ones(n_x,1);
            g = ones(n_x,1);
            b = P(i+1, 2) - P(i, 2);
            c = P(i+1, 1) - P(i, 1);

            if( c ~= 0 )

                a = b/c;

                x_limit1 = min([P(i,1), P(i+1,1)]);     %x-min limit
                x_limit2 = max([P(i,1), P(i+1,1)]);     %x-max limit

                %limit the x values to lie between x-min and x-max
                I = (x_limit1 < x) & (x < x_limit2);    

                f(I) = a.*(x(I) - P(i,1)) + P(i,2);     %function f(x)
                g(I) = abs(y(I) - f(I));                %the difference between y and f(x)

            else

                y_limit1 = min([P(i,2), P(i+1,2)]);     %y-min limit
                y_limit2 = max([P(i,2), P(i+1,2)]);     %y-max limit
            
                %limit the y values to lie between y-min and y-max
                I = (y_limit1 < y) & (y < y_limit2);
                
                %the difference between the agent's x points and the x points of the obstacle
                g(I) = abs( x(I) - P(i,1) );            

            end
            
            %Checking if g has any values during dist_between
            I = find( g < dist_between);
            
            if( ~isempty(I) )
                
                temp = min(dist([x(I), y(I)], [Qx(1); Qy(1)]));
                
                if(sensor_value > temp)
                    
                    sensor_value = temp;        %find the minimum sensor value between the agent and the edges of the obstacle               
                end

                if(sensor_value < dist_crash)

                    crash = true;
                end
            end

        end
        
        %Same method as for loop over, but now for the last edge of the obstacle 
        f = ones(n_x,1);
        g = ones(n_x,1);
        b = P(n_punkter, 2) - P(1, 2);
        c = P(n_punkter, 1) - P(1, 1);

        if(c ~= 0)

            a = b/c;

            x_limit1 = min([P(1,1), P(n_punkter,1)]);
            x_limit2 = max([P(1,1), P(n_punkter,1)]);

            I = (x_limit1 < x) & (x < x_limit2) ;

            f(I) = a*( x(I) - P(1,1)) + P(1,2);
            g(I) = abs(y(I) - f(I));


        else

            y_limit1 = min([P(1,2), P(n_punkter,2)]);
            y_limit2 = max([P(1,2), P(n_punkter,2)]);

            I = (y_limit1 < y) & (y < y_limit2) ;
            g(I) = abs( x(I) - P(1,1) );
        end

        I = find( g < dist_between);

        if( ~isempty(I) )

            temp = min(dist([x(I), y(I)], [Qx(1); Qy(1)]));
            
            if( sensor_value > temp)
                
                sensor_value = temp;
            end
            
            if(sensor_value < dist_crash)

                crash = true;
            end
        end
    end
    
end