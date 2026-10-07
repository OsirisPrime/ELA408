function hTree = plot_tree(tree)
    if isempty(tree) 
        hTree = []; 
        return; 
    end

    % Create needed arrays
    numNodes = size(tree, 1);
    xData = zeros(3 * (numNodes - 1), 1);
    yData = zeros(3 * (numNodes - 1), 1);
    idx = 1;

    for i = 2:numNodes
        pIdx = tree(i, 3);      % Get the row index of this node's parent
        xData(idx:idx+2) = [tree(i, 1); tree(pIdx, 1); NaN];
        yData(idx:idx+2) = [tree(i, 2); tree(pIdx, 2); NaN];
        idx = idx + 3;
    end
    hTree = plot(xData, yData, 'Color', [0.4, 0.7, 0.9, 0.75], 'LineWidth', 0.6, 'DisplayName', 'RRT Tree');
end