%% Stochastic Aerospace Systems Practical Main Code
% Course code:  AE4304P
% Author: Pedro Tallón

%% 1 - STABILITY ANALYSIS

% Extraction of the uncontrolled aricraft models
run("q11.m")

% Stability analysis of the aircraft models and extraction of the
% controlled models
run("q12.m")

%% 2 - TIME-DOMAIN SIMULATIONS

% Extraction of the time domain simulations required
run("q21.m")

%% 3 - SPECTRAL ANALYSIS

% Extraction of the PSD solutions
run("q31.m")


%% 4 - VARIANCES

% Extraction of the variances for the complete aircraft model
run("q41.m")