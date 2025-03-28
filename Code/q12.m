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
xlim([-5 5])
ylim([-8 8])
grid minor;
legend('Full model', 'Simplified model', 'Location', 'northwest',Interpreter='latex',FontSize=11);
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

% The values of the constants as defined 
Kphi = 0.1;
Kp = 0.1; 
K    = [0 Kphi Kp*2*V/b 0  0 0];
Ac   = A+B(:,1)*K;

% Extract the eigenvalues of both the controlled system (Ac) and another system (As)
poles_c = eig(Ac); % Controlled system poles
poles_s = eig(As); % System As poles

% Compute natural frequency and damping ratio for both systems
omega_n_c = abs(poles_c);
zeta_c = -real(poles_c) ./ omega_n_c;
mult_c = omega_n_c .* zeta_c;
t_5_c = log(2) ./ mult_c;

omega_n_s = abs(poles_s);
zeta_s = -real(poles_s) ./ omega_n_s;
mult_s = omega_n_s .* zeta_s;

% Create table for controlled system (Ac)
pole_table_c = table(poles_c, omega_n_c, zeta_c, mult_c, ...
     'VariableNames', {'Controlled Poles', 'Natural Frequency', 'Damping Ratio', ...
                       'NaturalFreqDampingRatio'});

% Create table for system As
pole_table_s = table(poles_s, omega_n_s, zeta_s, mult_s, ...
     'VariableNames', {'System As Poles', 'Natural Frequency', 'Damping Ratio', ...
                       'NaturalFreqDampingRatio'});

% Display the tables
disp('Controlled System (Ac) Poles and Parameters:');
disp(pole_table_c);

disp('System (As) Poles and Parameters:');
disp(pole_table_s);


% Plot the poles
fig = figure("Position", [100, 100, 600, 450]);
plot(real(poles_c), imag(poles_c), 'ro', 'MarkerSize', 10, 'LineWidth', 1);
hold on 
plot(real(poles), imag(poles), 'rx', 'MarkerSize', 10, 'LineWidth', 1);
yline(0, '--k');
xline(0, '--k');
xlim([-5 5])
ylim([-8 8])
grid minor;
xlabel('Real Part',Interpreter='latex',FontSize=12);
ylabel('Imaginary Part',Interpreter='latex',FontSize=12);
legend('Controlled poles', 'Uncontrolled poles', 'Location', 'northwest',Interpreter='latex',FontSize=11);
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
xlim([-5 5])
ylim([-8 8])
grid minor;
xlabel('Real Part',Interpreter='latex',FontSize=12);
ylabel('Imaginary Part',Interpreter='latex',FontSize=12);
legend('Controlled full model', 'Controlled simplified model', 'Location', 'northwest',Interpreter='latex',FontSize=11);
axis equal;
set(fig, 'PaperPositionMode', 'auto'); % Ensure tight layout
% Save the figure as a tight PDF
exportgraphics(fig, './Q1plots/poles_control_both.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');


save('acdata.mat', 'Ac', 'As', 'B','Bs','V','b');


