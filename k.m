% System parameters
m = 1;  % Mass of the chaser (kg)
I = 0.1; % Moment of inertia (kg·m^2)

% State and input matrices
A = [0, 1, 0; 
     0, 0, 0; 
     0, 0, 0]; % State matrix
B = [0, 0; 
     1/m, 0; 
     0, 1/I]; % Input matrix

% Cost matrices
Q = diag([10, 5, 10]); % State cost matrix
R = diag([0.1, 0.1]);  % Input cost matrix

% Compute the LQR gain
K = lqr(A, B, Q, R);

% Display the LQR gain
disp('LQR Gain Matrix K:');
disp(K);
