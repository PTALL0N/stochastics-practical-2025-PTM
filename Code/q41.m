clear all; close all; clc;

load psd_c_ac_300other.mat

%% EXTRACTION OF THE VARIANCES FOR THE COMPLETE AIRCRAFT MODEL 

%% ======== COMPUTATION OF THE VARIANCE FROM THE ANALYTICAL PSD ===========

var_a = zeros(1,5);
fprintf('COMPUTATION OF THE VARIANCE FROM THE ANALYTICAL PSD FULL MODEL \n')
for j = 1:5
    % Use the trapezoidal rule for integration
    var_a(j) = trapz(w, Sxx(:,j)); 

    % Display the variance
    fprintf('Variance for state %d: %.5e\n', j, var_a(j) / pi);
end

var_a_s = zeros(1,3);
fprintf('COMPUTATION OF THE VARIANCE FROM THE ANALYTICAL PSD SIMPLIFIED MODEL\n')
for j = 1:3
    % Use the trapezoidal rule for integration
    var_a_s(j) = trapz(w, Sxx_s(:,j)); 

    % Display the variance
    fprintf('Variance for state %d: %.5e\n', j, var_a_s(j) / pi);
end
fprintf('---------------------------------------------------------------------\n')
%% ======= COMPUTATION OF THE VARIANCE FROM THE EXPERIMENTAL PSD ==========

var_est = zeros(1,5);
fprintf('COMPUTATION OF THE VARIANCE FROM THE EXPERIMENTAL PSD FULL MODEL \n')
for j = 1:5
    % Use the trapezoidal rule for integration
    var_est(j) = trapz(omega, PSD_est(1:round(N/2)-1,j)); 

    % Display the variance
    fprintf('Variance for state %d: %.5e\n', j, var_est(j) / pi);
end
var_est_s = zeros(1,3);
fprintf('COMPUTATION OF THE VARIANCE FROM THE EXPERIMENTAL PSD SIMP MODEL \n')
for j = 1:3
    % Use the trapezoidal rule for integration
    var_est_s(j) = trapz(omega, PSD_est_s(1:round(N/2)-1,j)); 

    % Display the variance
    fprintf('Variance for state %d: %.5e\n', j, var_est_s(j) / pi);
end
fprintf('---------------------------------------------------------------------\n')

%% ========= COMPUTATION OF THE VARIANCE FROM THE FILTERED PSD ============

fprintf('COMPUTATION OF THE VARIANCE FROM THE FILTERED PSD FULL MODEL \n')
var_sf = zeros(1,3);
for j = 1:5
    % Use the trapezoidal rule for integration
    var_sf(j) = trapz(omega, PSD_SF(1:round(N/2)-1,j)); 

    % Display the variance
    fprintf('Variance for state %d: %.5e\n', j, var_sf(j) / pi);
end

fprintf('COMPUTATION OF THE VARIANCE FROM THE FILTERED PSD SIMP MODEL\n')
var_sf_s = zeros(1,3);
for j = 1:3
    % Use the trapezoidal rule for integration
    var_sf_s(j) = trapz(omega, PSD_SF_s(1:round(N/2)-1,j)); 

    % Display the variance
    fprintf('Variance for state %d: %.5e\n', j, var_sf_s(j) / pi);
end
fprintf('---------------------------------------------------------------------\n')

%% ============ COMPUTATION OF THE VARIANCE FROM TIME TRACES ==============

fprintf('COMPUTATION OF THE VARIANCE FROM THE TIME TRACES FULL MODEL\n')
var_M = zeros(1,5);
for j=1:5
    var_M(j) = var(y_f(:,j));
    fprintf('Variance for state %d: %.5e\n', j, var_M(j));
end

fprintf('COMPUTATION OF THE VARIANCE FROM THE TIME TRACES SIMP MODEL\n')
var_M_s = zeros(1,3);
for j=1:3
    var_M_s(j) = var(y_s(:,j));
    fprintf('Variance for state %d: %.5e\n', j, var_M_s(j));
end

fprintf('---------------------------------------------------------------------\n')
