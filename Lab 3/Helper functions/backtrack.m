% Backtrack
function path = backtrack(parent, start, goal)
    path = goal;
    currentNode = goal;
    while ~isequal(currentNode, start)
        p = squeeze(parent(currentNode(1), currentNode(2), :))';
        path = [p; path];
        currentNode = p;
    end
end