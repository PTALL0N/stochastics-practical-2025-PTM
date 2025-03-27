%% CODE FOR THE EXTRACTION OF THE SIMPLIFIED MODEL
clear; clc; close all 

load("acdata.mat")


% Extract the eigenvalues of the uncontrolled system
poles = eig(A);
poles_s = eig(As);


% Display de poles
fig = figure("Position", [100, 100, 600, 450]);
plot(real(poles), imag(poles), 'rx', 'MarkerSize', 10, 'LineWidth', 1);
hold on
plot(real(poles_s), imag(poles_s), 'bx', 'MarkerSize', 10, 'LineWidth', 1);
yline(0, '--k');
xline(0, '--k');
hold off
xlim([-15 10])
ylim([-8 8])
grid minor;
legend('Full model', 'Simplified model', 'Location', 'best',Interpreter='latex',FontSize=11);
xlabel('Real Part',Interpreter='latex',FontSize=12);
ylabel('Imaginary Part',Interpreter='latex',FontSize=12); 
axis equal;
% Export the figure to a specific folder in PDF format with a tight layout
outputFolder = './Q1plots';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end
set(fig, 'PaperPositionMode', 'auto'); % Ensure tight layout
% Save the figure as a tight PDF
exportgraphics(fig, './Q1plots/poles_plot.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');

%
% %%
% % Plot the system temporal response
% C = eye(4,10);
% D = zeros(4,5);
% sys = ss(A,B,C,D);
% [y_lat_r,tOut] = impulse(sys);
% [y_lat_a,tOut_a] = step(sys);
% [y_eig,tOut_eig] = initial(sys,V(:,1));
% 
% 
% %% Dutch roll response to a impulse in rudder
% figure("Position", [100, 100, 800, 400]);
% plot(tOut,y_lat_r(:,2,1))
% grid minor
% xlabel('Time [s]', 'Interpreter', 'latex',FontSize=12)
% ylabel('$\phi$ [deg]', 'Interpreter', 'latex', FontSize=12)
% ylim([-100 100])
% 
% figure("Position", [100, 100, 800, 400]);
% plot(tOut,y_lat_r(:,1,1))
% grid minor
% xlabel('Time [s]', 'Interpreter', 'latex', FontSize=12)
% ylabel('$\beta$ [deg]', 'Interpreter', 'latex', FontSize=12)
% ylim([-100 100])
% figure("Position", [100, 100, 800, 400]);
% 
% plot(tOut,y_lat_r(:,3,1))
% grid minor
% xlabel('Time [s]', 'Interpreter', 'latex', FontSize=12)
% ylabel('$\frac{pb}{2V}$ [rad]', 'Interpreter', 'latex', FontSize=12)
% ylim([-100 100])
% figure("Position", [100, 100, 800, 400]);
% 
% plot(tOut,y_lat_r(:,4,1))
% grid minor
% xlabel('Time [s]', 'Interpreter', 'latex', FontSize=12)
% ylabel('$\frac{rb}{2V}$ [rad]', 'Interpreter', 'latex', FontSize=12)
% ylim([-100 100])
% 
% %% Aperiodic roll
% figure
% plot(tOut_eig,y_eig(:,1))
% grid minor
% xlabel('Time [s]', 'Interpreter', 'latex', FontSize=12)
% ylabel('$p$ [deg/s]', 'Interpreter', 'latex', FontSize=12)
% % ylim([-3 3])
% 
% 
% %%




% Neither the spiral mode, nor the dutch roll are stable. Thus, a
% controller needs to be designed to comply with stability specifications.
% In this solution, the MIL-F-8785C have been used as standard, considering
% a category B (cruise conditions) and a Level 1 of handling qualities.

% The values of the constants as defined 
Kphi = 0.6;
Kp = 0.4; 
K    = [0 Kphi Kp*2*V/b 0  0 0];
Ac   = A+B(:,1)*K;

% Extract the eigenvalues of the controlled system
poles_c = eig(Ac);

omega_n_c = abs(poles_c);
zeta_c = -real(poles_c)./omega_n_c; 
mult = omega_n_c.*zeta_c;
t_5 = log(2)./mult;

% Create table for display
pole_table = table(poles, poles_c, omega_n_c, zeta_c, mult, t_5, ...
     'VariableNames', {'Uncontrolled Poles', 'Controlled Poles', 'Natural Frequency', 'Damping Ratio','NaturalFrequencyDampingRatio', 't_05'});

% Display table in command window
disp(pole_table);

% Plot the poles
fig = figure("Position", [100, 100, 600, 450]);
plot(real(poles_c), imag(poles_c), 'ro', 'MarkerSize', 10, 'LineWidth', 1);
hold on 
plot(real(poles), imag(poles), 'rx', 'MarkerSize', 10, 'LineWidth', 1);
yline(0, '--k');
xline(0, '--k');
xlim([-25 5])
ylim([-8 8])
grid minor;
xlabel('Real Part',Interpreter='latex',FontSize=12);
ylabel('Imaginary Part',Interpreter='latex',FontSize=12);
legend('Controlled poles', 'Uncontrolled poles', 'Location', 'northwest');
axis equal;
set(fig, 'PaperPositionMode', 'auto'); % Ensure tight layout
% Save the figure as a tight PDF
exportgraphics(fig, './Q1plots/poles_control.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');


% Plot the poles
fig = figure("Position", [100, 100, 600, 450]);
plot(real(poles_c), imag(poles_c), 'ro', 'MarkerSize', 10, 'LineWidth', 1);
hold on 
plot(real(poles_s), imag(poles_s), 'bo', 'MarkerSize', 10, 'LineWidth', 1);
yline(0, '--k');
xline(0, '--k');
xlim([-25 5])
ylim([-8 8])
grid minor;
xlabel('Real Part',Interpreter='latex',FontSize=12);
ylabel('Imaginary Part',Interpreter='latex',FontSize=12);
legend('Controlled full model', 'Controlled simplified model', 'Location', 'northwest');
axis equal;
set(fig, 'PaperPositionMode', 'auto'); % Ensure tight layout
% Save the figure as a tight PDF
exportgraphics(fig, './Q1plots/poles_control_both.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');


save('acdata.mat', 'Ac', 'As', 'B','Bs','V','b');


