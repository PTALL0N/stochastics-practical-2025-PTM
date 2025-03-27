clear all; close all; clc;

load psd_c_ac.mat

%% EXTRACTION OF THE VARIANCES FOR THE COMPLETE AIRCRAFT MODEL 

%% ======== COMPUTATION OF THE VARIANCE FROM THE ANALYTICAL PSD ===========

var_a = zeros(1,5);
fprintf('COMPUTATION OF THE VARIANCE FROM THE ANALYTICAL PSD \n')
for j=1:5
  for i=1:length(w)-1
    var_a(j)    = var_a(j)+(w(i+1)-w(i))*Sxx(i,j);
  end
  
  fprintf('Variance for state %d: %.5e\n', j, var_a(j)/pi);
end

%% ======= COMPUTATION OF THE VARIANCE FROM THE EXPERIMENTAL PSD ==========

var_est = zeros(1,5);
fprintf('COMPUTATION OF THE VARIANCE FROM THE EXPERIMENTAL PSD \n')
for j=1:5
  for i=1:length(w)-1
    var_est(j)    = var_est(j)+(w(i+1)-w(i))*PSD_est(i,j);
  end
  
  fprintf('Variance for state %d: %.5e\n', j, var_est(j)/pi);
end

%% ========= COMPUTATION OF THE VARIANCE FROM THE FILTERED PSD ============

fprintf('COMPUTATION OF THE VARIANCE FROM THE FILTERED PSD \n')
var_sf = zeros(1,5);
for j=1:5
  for i=1:length(w)-1
    var_sf(j)    = var_sf(j)+(w(i+1)-w(i))*PSD_SF(i,j);
  end
  fprintf('Variance for state %d: %.5e\n', j, var_sf(j)/pi);
end

%% ============ COMPUTATION OF THE VARIANCE FROM TIME TRACES ==============

fprintf('COMPUTATION OF THE VARIANCE FROM THE TIME TRACES \n')
var_M = zeros(1,5);
for j=1:5
    var_M(j) = var(y(:,j));
    fprintf('Variance for state %d: %.5e\n', j, var_M(j));
end