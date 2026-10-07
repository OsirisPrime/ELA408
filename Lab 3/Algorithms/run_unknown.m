function [finalPath, totalCost, seenMap, stats] = run_unknown(Maze, algorithm)
    % Extract environment details
    realMap = Maze.map; 
    [rows, cols] = size(realMap);
    
    % Initialize agent knowledge and statistics
    seenMap = zeros(rows, cols); % Start with a blank map
    currentPos = Maze.start;
    goal = Maze.goal;
    finalPath = currentPos;
    totalCost = 0;
    sensorRange = 1.5;
    
    totalPushes = 0;
    totalPops = 0;

    % Loop until the robot reaches the goal
    while ~isequal(currentPos, goal)
        [col, row] = meshgrid(1:cols, 1:rows);
        distToAgent = sqrt((row - currentPos(1)).^2 + (col - currentPos(2)).^2);
        
        % Reveal obstacles within sensor
        newlySeen = (distToAgent <= sensorRange) & (realMap == inf);
        seenMap(newlySeen) = inf;
        
        % Create a temporary maze based on current knowledge
        tempMaze.map = seenMap;
        tempMaze.start = currentPos;
        tempMaze.goal = goal;

        % Call algorithm and collect stats
        [plannedPath, stepStats] = feval(algorithm, tempMaze);
        
        % Accumulate stats
        totalPushes = totalPushes + stepStats.pushes;
        totalPops = totalPops + stepStats.pops;

        if isempty(plannedPath) || size(plannedPath, 1) < 2
            warning('Target unreachable with current knowledge.');
            break;
        end

        % Move one step along the new optimal path
        nextStep = plannedPath(2, :);
        totalCost = totalCost + sqrt(sum((nextStep - currentPos).^2));
        currentPos = nextStep;
        finalPath = [finalPath; currentPos];
    end
    
    % Final stats structure
    stats.pushes = totalPushes;
    stats.pops = totalPops;
end