% A* Algorithm
function [path, stats] = A_Star(Maze)
    map = Maze.map;
    start = Maze.start;
    goal = Maze.goal;
    N = size(map, 1);

    % gCost(x,y) stores distance from start
    gCost = inf(N, N);          % Actual distance from start to current node
    fCost = inf(N, N);          % Estimated total distance (gCost + heuristic)
    closed = false(N, N);       % Track visited nodes
    parent = zeros(N, N, 2);    % To store the path
    
    % Initialize start node
    gCost(start(1), start(2)) = 0;
    fCost(start(1), start(2)) = Heuristic(start, goal);
    
    % Simple priority queue [row, col, fCost]
    openList = [start(1), start(2), fCost(start(1), start(2))];
    pushes = 1; pops = 0;

    while ~isempty(openList)
        % Pop node with lowest fCost
        [~, idx] = min(openList(:,3));
        currentNode = openList(idx, 1:2);
        openList(idx, :) = [];
        pops = pops + 1;

        % Check if we reached the goal
        if isequal(currentNode, goal) 
            break; 
        end
        
        % Check if we already visited the node
        if closed(currentNode(1), currentNode(2)) 
            continue; 
        end

        closed(currentNode(1), currentNode(2)) = true;
        
        % Get the neighbors of the node
        neighbors = getNeighbors(currentNode, map);
        for i = 1:size(neighbors, 1)
            nb = neighbors(i, 1:2);
            cost = neighbors(i, 3);
            
            % If a shorter path to neighbor is found
            newGCost = gCost(currentNode(1), currentNode(2)) + cost;
            if newGCost < gCost(nb(1), nb(2))
                gCost(nb(1), nb(2)) = newGCost;
                fCost(nb(1), nb(2)) = newGCost + Heuristic(nb, goal);
                parent(nb(1), nb(2), :) = currentNode;

                % Add to search list
                openList = [openList; nb(1), nb(2), fCost(nb(1), nb(2))];
                pushes = pushes + 1;
            end
        end
    end

    % Reconstruct the path from goal to start
    path = backtrack(parent, start, goal);
    stats.pushes = pushes;
    stats.pops = pops;
    stats.cost = gCost(goal(1), goal(2));
end