# Docking Simulation with Dynamic Target Updates in Simulink

## Overview
This project simulates a docking scenario where a chaser spacecraft dynamically adjusts its trajectory to align with changing target positions and orientations. The target values (`x_target`, `y_target`, `theta_target`) are updated dynamically during the simulation using **From Workspace** blocks in Simulink.

---

## Prerequisites

### Simulink Model Setup
- **Integrators**: For modeling spacecraft dynamics.
- **LQR Controller**: For control input calculations.
- **From Workspace Blocks**: To dynamically update target values.

### MATLAB Workspace Variables
Define and update target matrices using MATLAB for dynamic simulation.

---

## Simulink Model Configuration
1. **Replace Constant Blocks**:  
   Use **From Workspace** blocks instead of Constant blocks for `x_target`, `y_target`, and `theta_target`.

2. **Configure From Workspace Blocks**:  
   - Set the **Variable Name** to:
     - `x_target_data` for the `x_target` block.
     - `y_target_data` for the `y_target` block.
     - `theta_target_data` for the `theta_target` block.
   - Set the **Sample Time** to `-1` (inherited).

3. **Verify Connections**:  
   Connect the outputs of the **From Workspace** blocks to the positive inputs of the respective **Error** blocks.

---

## Dynamic Target Matrix Format
The target matrices (`x_target_data`, `y_target_data`, `theta_target_data`) must follow this format:
- The **first column** contains time values.
- The **second column** contains the corresponding target values.

### Example
```matlab
timeVector = (0:10:100)'; % Time values
x_target_data = [timeVector, rand(length(timeVector), 1) * 10 - 5]; % Random x_target values
y_target_data = [timeVector, rand(length(timeVector), 1) * 10 - 5]; % Random y_target values
theta_target_data = [timeVector, rand(length(timeVector), 1) * 2 * pi - pi]; % Random theta_target values
## Simulation Workflow

### Run the MATLAB Script
- Execute the script to dynamically update target matrices and simulate in steps.

### Observe Results
- Use the **Scope** to monitor:
  - Orientation (`θ`)
  - Energy consumption.
- Use the **XY Graph** to observe the chaser's trajectory.

### Pause Between Runs
- The script pauses for a specified duration (`pauseTime`) to allow for inspection.

---

## Expected Outputs

### XY Graph
- Displays the trajectory of the chaser spacecraft moving toward dynamically updated targets.

### Theta Scope
- Shows the chaser's orientation (`θ`) converging to the target orientation.

### Energy Scope
- Displays cumulative energy consumption over time.

---

## Customization

### Change Target Update Frequency
- Modify `stepTime` to adjust how frequently targets are updated.

### Adjust Pause Duration
- Change `pauseTime` to allow more or less time for result inspection.

### Set Specific Targets
- Replace random target generation with specific values if needed.

