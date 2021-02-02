function rot_center = moveCarCircle(velocity, angle, w, car)
       
    P = get(car,'Vertices');
    r = ones(size(P));

    r = P(:,1:2) + velocity.*[cos(angle)*r(:,1), sin(angle)*r(:,2)];
    set(car, 'XData', r(:,1), 'YData', r(:,2));
    
    angle = (min(r(:,1)) + max(r(:,1)))/2;
    b = (min(r(:,2)) + max(r(:,2)))/2;
    rot_center = [angle, b];                 % center of the vehicle

    rotate(car, [0,0,1], (w*180)/pi, [rot_center,0]);
end
