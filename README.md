# ELA408 — Behavioural Robotics

## Overview

This repository contains the work completed for **ELA408 Behavioural Robotics**, including three laboratory assignments and a final robotics project.

The main focus of the repository is the **implementation and evaluation of sampling-based path-planning algorithms** for autonomous robot navigation. The project compares **Probabilistic Roadmap (PRM)** and **Rapidly-exploring Random Tree (RRT)** algorithms in both static and dynamic maze environments.

The work is implemented primarily in **MATLAB**, with supporting MATLAB Live Scripts, maps, simulation results, and visualizations.

---

# Project — PRM and RRT Path Planning

## Project Overview

The project investigates how different sampling-based path-planning algorithms perform when navigating a robot through obstacle-filled environments.

Two algorithms were implemented:

* **Probabilistic Roadmap (PRM)**
* **Rapidly-exploring Random Tree (RRT)**

The algorithms were evaluated using two custom maze environments:

* **Maze 1** — a maze consisting primarily of connected passageways and obstacles.
* **Maze 2** — a more open environment containing scattered obstacle regions.

Each maze was tested in two configurations:

1. **Static environment** — the map remains unchanged during navigation.
2. **Dynamic environment** — new obstacles appear while the robot is moving, requiring the planner to react and replan.

The algorithms were compared using:

* Path length
* Planning time
* Total execution time

Both planners successfully reached the goal in all tested scenarios.

---

## Project Objectives

The main objectives of the project were to:

* Implement PRM and RRT from scratch in MATLAB.
* Generate collision-free paths through maze environments.
* Account for the physical size of the robot using obstacle inflation.
* Investigate path planning in both static and changing environments.
* Implement replanning when a previously generated path becomes blocked.
* Compare the performance of PRM and RRT using quantitative measurements.
* Evaluate the trade-off between planning speed and path quality.

---

## Environment Representation

The two environments are represented as **80 × 80 binary occupancy grids**.

```text
1 = obstacle
0 = free space
```

Each maze contains a predefined start and goal position.

Before planning, the obstacles are **inflated by one cell** to provide a safety clearance around the robot.

This allows the robot to be represented as a point during path planning while still maintaining a safety distance from obstacles.

---

# Probabilistic Roadmap (PRM)

PRM is implemented as a two-stage sampling-based planner.

### 1. Roadmap Construction

The algorithm randomly samples valid points throughout the free space.

The implementation uses:

* **250 valid nodes**
* Connection radius of **22 units**
* Collision checking for every potential connection

Nodes located inside inflated obstacles are discarded.

Valid neighbouring nodes are connected when the straight-line path between them is collision-free.

The resulting roadmap is represented as a weighted graph.

### 2. Path Search

Once the roadmap has been constructed, **Dijkstra's algorithm** is used to find the shortest path through the graph from the start to the goal.

This allows PRM to reuse its roadmap when solving additional path queries.

---

# Rapidly-exploring Random Tree (RRT)

RRT grows a tree incrementally from the robot's starting position.

At each iteration:

1. A random point is selected from the environment.
2. The nearest existing tree node is found.
3. The tree is extended toward the random point.
4. Collision checking is performed.
5. The new node is added if the path is collision-free.

The implementation uses:

* Step size of **2 units**
* Goal threshold of **2 units**
* Maximum of **10,000 iterations**

Once the tree reaches the goal, parent pointers are followed backwards to reconstruct the final path.

Unlike PRM, RRT does not perform a separate roadmap-construction stage.

---

# Dynamic Path Planning

An important part of the project is evaluating how the algorithms handle **changing environments**.

Two obstacle-spawning events are introduced during robot navigation.

The first obstacle appears at approximately **20% of the path**, without directly blocking the current route.

A second obstacle appears at approximately **55% of the path**, directly blocking the robot's planned route.

This forces the planner to detect that its current path is no longer valid and generate a new route.

### RRT Replanning

When RRT detects that its current path has become blocked:

* The existing path is discarded.
* The existing tree is discarded.
* A new RRT is generated from the robot's current position.
* The planner searches for a new path to the goal.

### PRM Replanning

PRM uses a different strategy.

Instead of rebuilding the entire roadmap, blocked edges are removed from the existing graph.

The remaining roadmap is then searched again using Dijkstra's algorithm.

This allows PRM to retain the majority of its previously generated roadmap while adapting to newly introduced obstacles.

---

# Performance Evaluation

Each planner was executed **five times per maze and environment configuration** to account for the stochastic nature of the algorithms.

The following metrics were recorded.

### Path Length

The total distance travelled along the final path.

### Planning Time

The time required to generate a valid path from the starting position to the goal.

### Total Execution Time

The complete time required for the simulation, including planning and robot movement.

---

## Results

### Static Environments

| Planner | Maze | Path Length | Planning Time | Total Time |
| ------- | ---: | ----------: | ------------: | ---------: |
| PRM     |    1 |      155.23 |       0.030 s |     1.55 s |
| RRT     |    1 |      194.76 |       0.018 s |    11.65 s |
| PRM     |    2 |       95.32 |       0.030 s |     1.24 s |
| RRT     |    2 |      149.77 |       0.012 s |     8.68 s |

PRM consistently produced shorter paths than RRT.

However, RRT had the shorter initial planning time because it does not need to construct an entire roadmap before searching for a solution.

---

### Dynamic Environments

| Planner | Maze | Path Length | Planning Time | Total Time |
| ------- | ---: | ----------: | ------------: | ---------: |
| PRM     |    1 |      168.87 |       0.031 s |     2.00 s |
| RRT     |    1 |      222.46 |       0.020 s |    13.06 s |
| PRM     |    2 |      113.66 |       0.037 s |     1.61 s |
| RRT     |    2 |      166.82 |       0.014 s |     9.89 s |

PRM again produced shorter paths and lower total execution times.

RRT remained faster during the initial planning stage.

---

## Results Summary

The experiments showed a consistent difference between the two approaches:

**PRM**

* Shorter paths
* Lower total execution time
* Higher initial planning cost
* Effective replanning through edge removal
* Benefits from reusing the existing roadmap

**RRT**

* Faster initial planning
* Longer and less direct paths
* Requires rebuilding the tree when the environment changes
* Useful when a solution is needed quickly without an upfront roadmap

Overall, **PRM performed better in terms of path quality and total execution time**, while **RRT was faster at generating an initial solution**.

The PRM results were particularly beneficial in the dynamic environments because blocked edges could be removed without rebuilding the entire roadmap.

---

# Project Structure

```text
Project/
│
├── Algorithms/
│   ├── RRT.m
│   └── build_roadmap.m
│
├── Helper functions/
│   ├── backtrack_path.m
│   ├── inflate_map.m
│   ├── is_collision.m
│   ├── plot_roadmap.m
│   ├── plot_tree.m
│   └── update_roadmap_edges.m
│
├── Maps/
│   ├── generate_map.m
│   └── maps_data.mat
│
├── Results/
│   ├── Maze 1.png
│   ├── Maze 2.png
│   ├── PRM 1 (Dynamic).png
│   ├── PRM 1 (Static).png
│   ├── PRM 2 (Dynamic).png
│   ├── PRM 2 (Static).png
│   ├── RRT 1 (Dynamic).png
│   ├── RRT 1 (Static).png
│   ├── RRT 2 (Dynamic).png
│   ├── RRT 2 (Static).png
│   └── PRM statistics
│
└── Project_Report.pdf
```

---

# Laboratory Work

The repository also contains the three laboratory assignments completed as part of ELA408.

## Lab 1 — Behavioural Robotics

Lab 1 focuses on basic robot behaviour and navigation.

The implementation includes:

* A unicycle robot model
* Sensor-based navigation
* Goal-directed behaviour
* Maze generation
* Robot trajectory simulation

Important files include:

```text
Lab 1/
├── CreateMaze.m
├── go2goalWithSensor.m
├── UnicycleWithSensor.slx
└── Results/
```

The lab also contains the provided laboratory material and resulting trajectory plots.

---

## Lab 2 — Localisation and SLAM

Lab 2 focuses on **robot localisation** using probabilistic state-estimation techniques.

The repository contains implementations of:

* **Extended Kalman Filter (EKF)**
* **Particle Filter**

The algorithms are evaluated using recorded:

* Odometry data
* Sensor measurements
* Landmark data
* Robot trajectory data

Important files include:

```text
Lab 2/
├── EKF.mlx
├── Particle_Filter.mlx
├── Localisation/
│   ├── lab2_dataset_landmarks.csv
│   ├── lab2_dataset_odometry.csv
│   ├── lab2_dataset_sensors.csv
│   └── lab2_dataset_traj.csv
└── Results/
    ├── EKF_ref.png
    ├── EKF_traj.png
    ├── PF_ref.png
    └── PF_traj.png
```

---

## Lab 3 — Path Planning

Lab 3 introduces classical graph-based path-planning algorithms.

The repository contains implementations of:

* **A***
* **Dijkstra's algorithm**

The algorithms are evaluated in known and unknown environments.

Supporting functions handle:

* Neighbour generation
* Heuristic calculations
* Path backtracking
* Maze generation

Important files include:

```text
Lab 3/
├── Algorithms/
│   ├── A_Star.m
│   ├── DijkstrA.m
│   └── run_unknown.m
│
├── Helper functions/
│   ├── Heuristic.m
│   ├── backtrack.m
│   └── getNeighbors.m
│
├── Maps/
│   ├── CreateMaze_1.m
│   └── Maze.mat
│
├── main_known.mlx
├── main_unknown.mlx
└── Results/
```

Lab 3 provides a foundation for the final project, where the path-planning problem is extended from classical grid-based methods to **sampling-based PRM and RRT approaches**.

---

# Relationship Between the Labs and Project

The repository follows a progression from fundamental robotic behaviours toward more advanced autonomous navigation:

```text
Lab 1
Robot Behaviour & Navigation
        │
        ▼
Lab 2
Localisation & State Estimation
        │
        ▼
Lab 3
A* & Dijkstra Path Planning
        │
        ▼
Final Project
PRM & RRT Sampling-Based Planning
```

The final project builds upon the concepts introduced throughout the laboratory work while investigating a different class of path-planning algorithms.

---

# Requirements

The project and laboratory implementations require **MATLAB**.

Some files use:

* MATLAB scripts (`.m`)
* MATLAB Live Scripts (`.mlx`)
* Simulink models (`.slx`)
* MATLAB data files (`.mat`)
* CSV datasets

To run the project:

1. Open MATLAB.
2. Navigate to the `Project` directory.
3. Add the project directories and helper-function directories to the MATLAB path.
4. Run the relevant MATLAB scripts or functions.
5. Inspect the generated paths and performance results.

The supplied `maps_data.mat` file contains the project map data.

---

# Future Work

Several extensions could improve the implemented planners.

### RRT

Possible improvements include:

* **RRT*** for path optimization
* Goal-biased sampling
* Improved sampling strategies
* More efficient collision checking

RRT* could improve the path quality by rewiring the tree toward lower-cost solutions.

### PRM

Possible improvements include:

* **PRM***
* Adaptive connection radius
* Improved node sampling
* More efficient roadmap construction

PRM could also be evaluated over a larger number of environments and trials.

### General Improvements

Further evaluation could include:

* Larger and more complex environments
* Higher-dimensional configuration spaces
* Different robot sizes
* More dynamic obstacles
* More extensive statistical evaluation
* Physical robot implementation

---

# Conclusion

This repository documents the development of robotic navigation methods throughout the ELA408 Behavioural Robotics course.

The main project compares **PRM and RRT** in static and dynamic maze environments. Both algorithms successfully navigated all tested environments, but they demonstrated different strengths.

**PRM produced shorter paths and lower total execution times**, particularly when replanning was required. Its ability to reuse an existing roadmap and remove only blocked edges made it effective in dynamic environments.

**RRT produced faster initial plans**, but generated longer paths and required the tree to be rebuilt when the environment changed.

The laboratory work provides the progression toward this project, covering robot behaviour, localisation, and classical path planning before the final investigation of sampling-based planning.

Overall, the project demonstrates the trade-offs involved in selecting a path-planning algorithm for autonomous robotic navigation.
