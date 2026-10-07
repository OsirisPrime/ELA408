function hEdges = plot_roadmap(nodes, adjMatrix) % gathers coordinates for all valid edges into x and y arrays
    numNodes = size(nodes, 1);
    xCoords = [];
    yCoords = [];
    
    for i = 1:numNodes
        for j = i+1:numNodes
            if adjMatrix(i,j) ~= inf
                % Append NaN to act as a "lift pen" command. Allows MATLAB to 
                % do hundreds of disconnected lines using a single, high-performance plot call.
                xCoords = [xCoords, nodes(i,1), nodes(j,1), NaN];
                yCoords = [yCoords, nodes(i,2), nodes(j,2), NaN];
            end
        end
    end
    hEdges = plot(xCoords, yCoords, 'Color', [0.7 0.7 0.7 0.4], 'LineWidth', 0.5, 'DisplayName', 'Roadmap Edges');
    % HandleVisibility is 'off' so individual sample points don't overflow the plot legend box
    plot(nodes(3:end,1), nodes(3:end,2), 'k.', 'MarkerSize', 4, 'HandleVisibility', 'off');
end