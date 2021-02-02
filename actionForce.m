function force = actionForce(action, Fmax, tot_rot)

switch(action)
    % Move forward
    case 1
        force = [Fmax tot_rot];
        
        % Turn right Low
    case 2
        force = [Fmax tot_rot-pi/6];
        
        % Turn left Low
    case 3
        force = [Fmax tot_rot+pi/6];
        
        % Turn Right High
    case 4
        force = [Fmax tot_rot-pi/3];
        
        % Turn left High
    case 5
        force = [Fmax tot_rot+pi/3];
        
        % Low speed
    case 6
        force = [0.05*Fmax tot_rot];
end
end