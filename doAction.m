function Ftg = doAction(action, tot_rot, Fmax)

% Function for moving the vehicle in the simulation
switch(action)
    % Move forward
    case 1
        Ftg = [Fmax, tot_rot];    % tangent to path
        
        % Turn right Low
    case 2
        Ftg = [Fmax, tot_rot-pi/6];    % tangent to path
%         AFat = 0.33*Fmax;
        
        % Turn left Low
    case 3
        Ftg = [Fmax, tot_rot+pi/6];    % tangent to path
%         AFat = 0.33*Fmax;
        
        % Turn Right High
    case 4
        Ftg = [Fmax, tot_rot-pi/3];    % tangent to path
%         AFat = 0.7*Fmax;
        
        % Turn left High
    case 5
        Ftg = [Fmax, tot_rot+pi/3];    % tangent to path
%         AFat = 0.7*Fmax;
        
        % Low speed
    case 6
        Ftg = [0.1*Fmax, tot_rot];    % tangent to path

end

end