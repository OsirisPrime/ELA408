clear; clc;

mapSize = 80;

% Build Maze 0
map0 = zeros(mapSize, mapSize);
map0(15:70, 25:30) = 1;     % [y, x]
map0(1:60, 55:60) = 1;  
map0(35:40, 10:25) = 1;  
map0(45:50, 30:45) = 1; 
map0(25:30, 38:55) = 1;
map0(20:25, 65:75) = 1; 
startPos0 = [10, 20];       % [x, y]
goalPos0 = [70, 10];    
mazeName0 = 'Maze 1: Corridors';

% Build Maze 1
map1 = zeros(mapSize, mapSize);
map1(20:30, 10:30) = 1;     % [y, x]
map1(40:55, 20:30) = 1;
map1(8:12, 30:50) = 1;
map1(40:70, 48:52) = 1;
map1(25:32, 40:55) = 1;
map1(15:25, 65:75) = 1;
map1(60:80, 60:65) = 1;
map1(40:50, 60:75) = 1;
startPos1 = [10, 10];       % [x, y]
goalPos1 = [70, 65];    
mazeName1 = 'Maze 2: Islands';

% Save all variables to a .mat file
save('maps_data.mat', 'mapSize', ...
     'map0', 'startPos0', 'goalPos0', 'mazeName0', ...
     'map1', 'startPos1', 'goalPos1', 'mazeName1');