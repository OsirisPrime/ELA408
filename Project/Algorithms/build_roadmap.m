function [nodes, adjMatrix] = build_roadmap(startPos, goalPos, map, mapSize, numSamples, radius)
    % Initialize Node matrix: Index 1 is permanently Start, Index 2 is permanently Goal
    nodes = [startPos; goalPos];
    
    % Sample valid points in uniform random distribution
    while size(nodes, 1) < (numSamples + 2)
        rx = rand() * (mapSize - 1) + 1;
        ry = rand() * (mapSize - 1) + 1;
        
        if map(max(1, min(mapSize, round(ry))), max(1, min(mapSize, round(rx)))) == 0
            nodes = [nodes; rx, ry];
        end
    end
    
    numNodes = size(nodes, 1);
    adjMatrix = inf(numNodes, numNodes);
    
    % Compute distances and check paths for local planner validation
    for i = 1:numNodes
        for j = i+1:numNodes
            dist = norm(nodes(i,:) - nodes(j,:));
            if dist <= radius % if nodes close enough -> edge
                if ~is_collision(nodes(i,:), nodes(j,:), map) % if nodes connected without obstacle
                    adjMatrix(i,j) = dist;
                    adjMatrix(j,i) = dist;
                end
            end
        end
    end
end