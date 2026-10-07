% Neighbor Function
function neighbors = getNeighbors(pos, map)
    neighbors = [];
    [N, ~] = size(map);
    % Check around the current node (horizontal, vertical, diagonal)
    for dx = -1:1
        for dy = -1:1
            if dx == 0 && dy == 0                           % Current node pos
                continue; 
            end

            nx = pos(1) + dx;
            ny = pos(2) + dy;
            
            % Check bounds and obstacles
            if nx >= 1 && nx <= N && ny >= 1 && ny <= N     % If its still whitin the map
                if map(nx, ny) ~= inf                       % If its not a obstacle
                    dist = sqrt(dx^2 + dy^2);               % Calculate dist (dist)
                    neighbors = [neighbors; nx, ny, dist];  % Save the neighbor
                end
            end
        end
    end
end