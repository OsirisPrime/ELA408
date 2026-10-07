function collision = is_collision(p1, p2, map)
    collision = false;
    [mapHeight, mapWidth] = size(map);

    % How many points to check in between the nodes to check for obstacles
    steps = max(4, ceil(norm(p2 - p1) * 2));

    % Create points in between the nodes
    xVec = linspace(p1(1), p2(1), steps);
    yVec = linspace(p1(2), p2(2), steps);

    for i = 1:steps
        % Round to nearest grid cell
        cx = round(xVec(i)); 
        cy = round(yVec(i));

        % Check for obstacle or boundary
        if cx < 1 || cx > mapWidth || cy < 1 || cy > mapHeight || map(cy, cx) == 1
            collision = true;
            return;
        end
    end
end