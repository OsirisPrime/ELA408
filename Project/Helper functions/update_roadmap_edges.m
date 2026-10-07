function adjMatrix = update_roadmap_edges(nodes, adjMatrix, map)
    % Prunes/removes any edge paths intersected by dynamic changes
    % by updating distance to infinite if obstacle detected
    numNodes = size(nodes, 1); 
    for i = 1:numNodes
        for j = i+1:numNodes
            if adjMatrix(i,j) ~= inf
                if is_collision(nodes(i,:), nodes(j,:), map)
                    adjMatrix(i,j) = inf;
                    adjMatrix(j,i) = inf;
                end
            end
        end
    end
end