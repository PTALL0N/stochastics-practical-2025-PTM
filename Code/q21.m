clc; close all; clear all; 

% Get system dynamic model
load acdata.mat;

% Definition of the time vector
dt = 0.05; T  = 60; t = [0:dt:T]; N = length(t);
nn = zeros(1,N);

% Lateral turbulence input
v_g = randn(1,N)/sqrt(dt);

% Input vector
u3 = [nn' nn' v_g'];

% V_g plot (optinal)
figure(Position=[200 200 1000 300])
plot(t,v_g), xlabel('Time [s]',Interpreter='latex',FontSize=12), ylabel('$w_2$ [rad]',Interpreter='latex',FontSize=12);

%% ==================== SIMULATION OF THE MODELS ==========================

% Define the output matrices for the full model
C = [eye(4),zeros(4,2)];
% Lateral acceleration equation
g = zeros(1,size(Ac,2));
g(4) = 2*V^2/b;
C11 = g + V*Ac(1,:);
% Addition of the last row of C
C = [C;C11];

% Definition of the matrix D
D = zeros(4, 3); 
% Addition of the row related to the lateral acceleration
D11 = V*B(1,:);
D = [D;D11];

% Response to v_g
y = lsim(Ac,B,C,D,u3,t);

% Define the output matrices for the simplified model
Cs = [eye(2),zeros(2,2)];
% Lateral acceleration equation
g = zeros(1,size(As,1));
g(2) = 2*V^2/b;
C11 = g + V*As(1,:);
% Addition of the last row of C
Cs = [Cs;C11];

% Definition of the matrix D
Ds = zeros(2, 3); 
% Addition of the row related to the lateral acceleration
D11 = V*Bs(1,:);
Ds = [Ds;D11];

% Response to v_g
y_s = lsim(As,Bs,Cs,Ds,u3,t);


%% ==================== COMPLETE AIRCRAFT RESULTS =========================
% Define axis limits
beta_axis = [0 60 -0.1  0.1];
phi_axis  = [0 60 -0.05  0.05];
pb_axis   = [0 60 -5e-3  5e-3];
rb_axis   = [0 60 -1e-2  1e-2];

% Create figure
fig = figure;

% Adjust figure size (increased vertical space for better clarity)
set(gcf, 'Position', [0, 0, 800, 1000]); % Adjust figure size

% First subplot: beta
subplot(5,1,1); 
h1 = plot(t, y(:,1),'r','LineWidth', 1.2); 
hold on
h2 = plot(t, y_s(:,1),'b', 'LineWidth', 1.2);
axis(beta_axis);
ylabel('$\beta$ [rad]', 'Interpreter', 'latex', 'FontSize', 12);
grid on; grid minor;
set(gca, 'XTickLabel', []); % Remove x-axis labels

% Second subplot: phi
subplot(5,1,2); 
plot(t, y(:,2),'r', 'LineWidth', 1.2); 
hold on
plot(t, zeros(1,length(t)),'b', 'LineWidth', 1.2);
axis(phi_axis);
ylabel('$\phi$ [rad]', 'Interpreter', 'latex', 'FontSize', 14);
grid on; grid minor;
set(gca, 'XTickLabel', []); % Remove x-axis labels

% Third subplot: pb/2V
subplot(5,1,3); 
plot(t, y(:,3),'r' ,'LineWidth', 1.2); 
hold on
plot(t, zeros(1,length(t)),'b', 'LineWidth', 1.2);
axis(pb_axis);
ylabel('$\frac{p b}{2V}$ [rad]', 'Interpreter', 'latex', 'FontSize', 14);
grid on; grid minor;
set(gca, 'XTickLabel', []); 

% Fourth subplot: rb/2V
subplot(5,1,4); 
plot(t, y(:,4),'r','LineWidth', 1.2); 
hold on
plot(t, y_s(:,2),'b', 'LineWidth', 1.2);
axis(rb_axis);
ylabel('$\frac{r b}{2V}$ [rad]', 'Interpreter', 'latex', 'FontSize', 14);
grid on; grid minor;
set(gca, 'XTickLabel', []); 

% Fifth subplot: ay 
subplot(5,1,5); 
plot(t, y(:,5),'r','LineWidth', 1.2); 
hold on
plot(t, y_s(:,3),'b', 'LineWidth', 1.2);
xlabel('Time [s]', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$a_y$ [m/s$^2$]', 'Interpreter', 'latex', 'FontSize', 14);
grid on; grid minor;

% Save the figure as a tight PDF
set(fig, 'PaperPositionMode', 'auto');
exportgraphics(fig, './Q2plots/timedomainresp.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');

save("acdata.mat","Ac","B","C","D","As","Bs","Cs","Ds")