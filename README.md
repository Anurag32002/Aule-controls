# Docking Simulation with Dynamic Target Updates in Simulink

## Overview
This project simulates a docking scenario where the chaser spacecraft dynamically adjusts its trajectory to align with changing target positions and orientations. The target values (`x_target`, `y_target`, `theta_target`) are updated dynamically during the simulation using **From Workspace blocks** in Simulink.

---

## Prerequisites
- **Simulink Model**: Ensure your Simulink model (`DockingSimulationModel`) is set up with:
  - Integrators for dynamics.
  - LQR Controller for control input calculation.
  - From Workspace blocks for dynamically updated targets.
- **MATLAB Workspace Variables**: Use MATLAB to compute and update the target matrices.

---

## MATLAB Script for Dynamic Simulation
The following MATLAB script runs the simulation in steps, dynamically updates target values, and pauses to observe the results in the **Scope** and **XY Graph**:

```matlab
% Name of the Simulink model
modelName = 'DockingSimulationModel';

% Load the system (only if not already loaded)
if ~bdIsLoaded(modelName)
    load_system(modelName);
end

% Set simulation parameters
simTime = 10;       % Duration of each simulation step (in seconds)
totalTime = 100;    % Total time to run (in seconds)
stepTime = 10;      % Time interval between updates (in seconds)
pauseTime = 5;      % Pause duration between updates (in seconds)

% Initialize time and target data
timeVector = (0:stepTime:totalTime)';  % Time vector for target updates
x_target_data = [timeVector, zeros(length(timeVector), 1)];  % Initialize x_target matrix
y_target_data = [timeVector, zeros(length(timeVector), 1)];  % Initialize y_target matrix
theta_target_data = [timeVector, zeros(length(timeVector), 1)];  % Initialize theta_target matrix

% Update target values dynamically
for i = 1:length(timeVector)
    % Generate random target values
    x_target = rand * 10 - 5;       % Random x (-5 to 5)
    y_target = rand * 10 - 5;       % Random y (-5 to 5)
    theta_target = rand * 2 * pi - pi;  % Random theta (-pi to pi)

    % Assign targets to the data matrices
    x_target_data(i, 2) = x_target;  % Update x_target value
    y_target_data(i, 2) = y_target;  % Update y_target value
    theta_target_data(i, 2) = theta_target;  % Update theta_target value

    % Assign updated matrices to the workspace
    assignin('base', 'x_target_data', x_target_data);
    assignin('base', 'y_target_data', y_target_data);
    assignin('base', 'theta_target_data', theta_target_data);

    % Run the simulation for the specified time
    sim(modelName, 'StopTime', num2str(simTime));

    % Display the updated targets
    fprintf('Time = %.1f seconds: x_target = %.2f, y_target = %.2f, theta_target = %.2f\n', ...
            timeVector(i), x_target, y_target, theta_target);
## Simulation Workflow

### Run the MATLAB Script:
- Execute the script to dynamically update the target matrices and run the Simulink model in chunks.

### Observe Results:
- Use the **Scope** to monitor orientation (\(\theta\)) and energy consumption.
- Use the **XY Graph** to observe the trajectory of the chaser.

### Pause Between Runs:
- The script pauses for a specified duration (`pauseTime`) after each simulation step to allow time for analysis.

---

## Expected Outputs

### XY Graph:
- Displays the trajectory of the chaser spacecraft moving toward the updated targets.

### Theta Scope:
- Shows the orientation (\(\theta\)) of the chaser converging to the target orientation.

### Energy Scope:
- Displays cumulative energy consumption over time.

---

## Customization

### Change Target Update Frequency:
- Modify `stepTime` to adjust how frequently targets are updated.

### Adjust Pause Duration:
- Change `pauseTime` to give yourself more or less time to inspect the results between simulation steps.

### Set Specific Targets:
- Replace the random target generation with specific values if needed.

    % Pause to observe results
    pause(pauseTime);
end

% Keep the system open for further interaction
disp('Simulation complete. Model remains open for further interaction.');
