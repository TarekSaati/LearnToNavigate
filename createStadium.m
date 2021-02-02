function createStadium(map, dynSpace, nDynObs, maxRad)
                                                    
    global h_poly h_circ arena
    %% ----- Initialize the obstacles and the arena
    %Properties of the arena
    arena_w = dynSpace(1,2) - dynSpace(1,1);
    arena_h = dynSpace(2,2) - dynSpace(2,1);
    map_w = map(1,2) - map(1,1);
    map_h = map(2,2) - map(2,1);
    rectangle = [0, -map_h/2; map_w, -map_h/2; ...
        map_w, map_h/2; 0, map_h/2];
    wall = patch(rectangle(:,1),rectangle(:,2),'w');
    rectangle = [dynSpace(1,1), dynSpace(2,1); dynSpace(1,2), dynSpace(2,1); ...
        dynSpace(1,2), dynSpace(2,2); dynSpace(1,1), dynSpace(2,2)];
    arena = patch(rectangle(:,1),rectangle(:,2),'w');

    % Properties of the obstacles
    n_points = 100;                         
    %Offset of the origo (0,0)
    centers = zeros(nDynObs, 2);
    radius = zeros(nDynObs, 1);
    for i=1:nDynObs
        centers(i,:) = [0.5*arena_w+5*(-1)^i+dynSpace(1,1), ...
                        -arena_h/2*0.9 + (i/nDynObs)*arena_h*0.9];
        radius(i) = maxRad;
    end
    h_circ = [];
    % Create the circle obstacles
    for i = 1:nDynObs
        [X, Y] = circle(centers(i,:), radius(i), n_points);
        h_circ(i) = patch(X, Y, 'y');
    end
        
    offs_p = [14, -11; 21, 2; 14, 14; 35, -25; 50, -15];
    pols = {};
    pols{1} = [0 0; 5 0; 5 5; 0 5];
    pols{2} = [0 0; 5 0; 5 5; 0 5];
    pols{3} = [0 0; 5 0; 5 5; 0 5];
    pols{4} = [0 0; 17 0; 17 3; 2 3; 2 33; 0 33];
    pols{5} = [0 0; 2 0; 2 40; 0 40; 0 30; -15 30; -15 29; 0 29];
    for i=1:length(pols)
        for j=1:length(pols{i}(:,1))
            pols{i}(j,:) = pols{i}(j,:) + offs_p(i,:);
        end
    end
    
    box1 = patch(pols{1}(:,1), pols{1}(:,2), 'r');
    box2 = patch(pols{2}(:,1), pols{2}(:,2), 'r');
    box3 = patch(pols{3}(:,1), pols{3}(:,2), 'r');
    bar1 = patch(pols{4}(:,1), pols{4}(:,2), 'r');
    bar2 = patch(pols{5}(:,1), pols{5}(:,2), 'r');
    h_poly = [wall, box1, box2, box3, bar1, bar2];
end
