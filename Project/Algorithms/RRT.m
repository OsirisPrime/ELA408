%% ================= STANDARD RRT PLANNER =================
function [path, tree] = RRT(start, goal, map)
    % Configuration settings
    % ===================================================
    maxIter = 10000;            % Max iteration to build the tree
    stepSize = 2.0;             % Branch length
    goalDistThr = 2.0;          % Goal threshold
    % ===================================================
    
    [mapSize, ~] = size(map);           % Map size
    tree = [start(1), start(2), 0];     % Root at start position
    path = [];
    
    for i = 1:maxIter
        % Generate a random point in the map
        qRand = [rand() * (mapSize-2) + 1, rand() * (mapSize-2) + 1];
        
        % Find the nearest point in the tree
        dists = sqrt((tree(:,1) - qRand(1)).^2 + (tree(:,2) - qRand(2)).^2);
        [~, minIdx] = min(dists);
        qNear = tree(minIdx, 1:2);
        
        % Create a new branch in the direction of the point
        dir = qRand - qNear;
        dirDist = norm(dir);
        if dirDist == 0, continue; end
        dir = dir / dirDist;    
        qNew = qNear + dir * min(stepSize, dirDist);
        
        % Check for collision
        if ~is_collision(qNear, qNew, map)
            % Add the node to the tree
            tree = [tree; qNew(1), qNew(2), minIdx];

            % Check if the goal is reached
            if norm(qNew - goal) < goalDistThr
                tree = [tree; goal(1), goal(2), size(tree,1)];
                path = backtrack_path(tree);
                return;
            end
        end
    end
end