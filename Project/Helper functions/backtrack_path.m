function path = backtrack_path(tree)
    path = [];
    currIdx = size(tree, 1);    % The last node = goal

    % Go through parents of the node to the start
    % Start node has currIdx == 0
    while currIdx ~= 0
        path = [tree(currIdx, 1:2); path];  % Place the node at the front
        currIdx = tree(currIdx, 3);         % Go to the parent
    end
end