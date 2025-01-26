
% Prompt the user to enter the step value
dt = input('Enter the desired step value (e.g., 0.1): ');

% Ensure the step value is reasonable
if dt <= 0 || dt > 1
    error('Invalid step value. Please enter a value between 0.01 and 1.');
end

% Parameters
m = 1;                  % Mass of the Chaser (kg)
I = 0.1;                % Moment of inertia (kg·m^2)
F_max = 0.5;            % Max thruster force (N)
T = 100;                % Total simulation time (s)
time = 0:dt:T;          % Time vector

% Initial Conditions
x0 = rand * 10 - 5; % Random initial x position (-5 to 5)
y0 = rand * 10 - 5; % Random initial y position (-5 to 5)
theta0 = rand * 2 * pi - pi; % Random initial orientation (-pi to pi)
state = [x0; y0; theta0]; % [x; y; orientation]

% Target State
target_state = [0; 0; 0]; % Docking target at the origin

% LQR Control Parameters (Reduced Weights)
A = [0, 1, 0; 0, 0, 0; 0, 0, 0]; % Linearized dynamics matrix
B = [0, 0; 1/m, 0; 0, 1/I];      % Input matrix

% Reduced weights
Q = diag([10, 5, 10]);        % Reduced state cost matrix
R = diag([0.1, 0.1]);         % Reduced input cost matrix
K = lqr(A, B, Q, R);          % Compute LQR gain

% Trajectory and States
n_steps = length(time);
states = zeros(n_steps, 3);     % To store [x, y, orientation]
states(1, :) = state';
thruster_profile = zeros(n_steps, 2); % To store thruster forces [Fx, Fy]
energy_consumption = zeros(n_steps, 1); % To store energy consumption

% Simulation Loop with Aggressive LQR Control
for i = 2:n_steps
    % Compute state error
    error = target_state - states(i-1, :)';

    % Check if the chaser is within a threshold of the target
    if norm(error(1:2)) < 0.5 % Success if within target circle of radius 0.5
        fprintf('Target successfully reached at step %d\n', i);
        states = states(1:i, :); % Truncate states
        thruster_profile = thruster_profile(1:i, :); % Truncate thruster profile
        energy_consumption = energy_consumption(1:i); % Truncate energy consumption
        time = time(1:i); % Truncate time
        break;
    end

    % Compute control input using LQR
    u = -K * error;
    u = max(min(u, F_max), -F_max); % Saturate control inputs
    thruster_profile(i, :) = u(1:2)'; % Store Fx and Fy

    % Update state using aligned forces
    angle_to_target = atan2(target_state(2) - states(i-1, 2), target_state(1) - states(i-1, 1));
    aligned_u = [
        cos(angle_to_target) * u(1) - sin(angle_to_target) * u(2);
        sin(angle_to_target) * u(1) + cos(angle_to_target) * u(2)
    ];

    % Ensure the chaser always moves toward the target
    if dot([target_state(1) - states(i-1, 1), target_state(2) - states(i-1, 2)], aligned_u(1:2)) < 0
        aligned_u = -aligned_u; % Reverse direction if moving away
    end
    dx = [aligned_u(1) / m; aligned_u(2) / m; u(2) / I];
    states(i, :) = states(i-1, :) + dx' * dt;

    % Compute energy consumption
    energy_consumption(i) = energy_consumption(i-1) + (u(1)^2 + u(2)^2) * dt;
end

% Plot and Animation
figure;

% Subplots for visualization
subplot(2, 2, [1 2]);
plot(states(:, 1), states(:, 2), 'b-', 'LineWidth', 1.5);
hold on;
plot(target_state(1), target_state(2), 'rp', 'MarkerSize', 14, 'MarkerFaceColor', 'r');
title('Chaser Trajectory');
xlabel('X Position (m)');
ylabel('Y Position (m)');
grid on;

subplot(2, 2, 3);
plot(time, energy_consumption, '-k', 'LineWidth', 1.5);
title('Energy Consumption');
xlabel('Time (s)');
ylabel('Energy (J)');
grid on;

subplot(2, 2, 4);
plot(time, states(:, 3), '--m', 'LineWidth', 1.5);
title('Orientation vs Time');
xlabel('Time (s)');
ylabel('Orientation (\theta in rad)');
grid on;

% Animation
figure('Position', [200, 200, 800, 600]);
xlim([-6, 6]);
ylim([-6, 6]);
hold on;
grid on;
title('Chaser Docking Animation');
xlabel('X Position (m)');
ylabel('Y Position (m)');

% Animation loop with slower speed
for i = 1:size(states, 1)
    % Plot trajectory
    plot(states(1:i, 1), states(1:i, 2), 'b-', 'LineWidth', 2);
    
    % Plot current chaser position as a circle
    scatter(states(i, 1), states(i, 2), 100, 'cyan', 'filled');
    
    % Plot the target
    scatter(target_state(1), target_state(2), 200, 'red', 'filled');
    
    % Pause to slow down the animation
    pause(0.2); % Increased pause duration for slower animation
    
    % Clear only the current chaser position to update in the next frame
    if i < size(states, 1)
        scatter(states(i, 1), states(i, 2), 100, 'white', 'filled');
    end
end
