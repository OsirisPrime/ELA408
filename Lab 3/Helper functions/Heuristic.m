% Heuristic Function
function h = Heuristic(pos, goal)
    h = sqrt((pos(1) - goal(1))^2 + (pos(2) - goal(2))^2);  % Euclidean distance
end