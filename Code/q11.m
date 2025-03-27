clear, clc, close all;

% AIRCRAFT- AND FLIGHT CONDITION 'CRUISE'.
V   = 181.9; % ok
S   = 24.2; % ok
b   = 13.36; % ok
mub = 32; % ok
KX2 = 0.013; % ok
KZ2 = 0.037; % ok
KXZ = 0.002; % ok
% Calculations for cruise conditions
W = 53361; % ok
rho = 0.4587; % ok
q = 0.5*rho*V; % ok
CL  = W/(q*S); % ok

% TURBULENCE PARAMETERS APPROXIMATED POWER SPECTRAL DENSITIES
Lg        = 150; % ok
B         = b/(2*Lg); % ok
sigma     = 2; % ok
sigmaug_V = sigma/V;
sigmavg   = sigma;
sigmabg   = sigmavg/V;
sigmaag   = sigma/V;

% Values depend on B and are in tables of the lecture notes
Iug0 = 0.0249*sigmaug_V^2; % ok
Iag0 = 0.0182*sigmaag^2; % ok
tau1 = 0.0991;     tau2 = 0.5545;     tau3 = 0.4159; % ok
tau4 = 0.0600;     tau5 = 0.3294;     tau6 = 0.2243; % ok

% AIRCRAFT ASYMMETRIC AERODYNAMIC DERIVATIVES 
CYb  =-1.4900;     Clb  =-0.1240;     Cnb  = 0.1865; % ok
CYp  =-0.1450;     Clp  =-0.4344;     Cnp  = 0.0135; % ok
CYr  = 0.4300;     Clr  = 0.1550;     Cnr  =-0.1930; % ok
CYda = 0.0000;     Clda =-0.2108;     Cnda = 0.0031; % ok
CYdr = 0.3037;     Cldr = 0.0469;     Cndr =-0.1261; % ok
 
                   % No info on the slides to extract this values
                   Clpw = 0.8*Clp;    Cnpw = 0.9*Cnp;
                   Clrw = 0.7*Clr;    Cnrw = 0.2*Cnr;

% Simplification included in lecturenotes p.343
CYfb = 0;
Clfb = 0;
Cnfb = 0;

%CYfbg = CYfb+0.5*CYr;
%Clfbg = Clfb+0.5*Clr;
%Cnfbg = Cnfb+0.5*Cnr;

%% ============== EXTRACTION OF THE FULL ASYMMETRIC MODEL ==============

yb   = (V/b)*CYb/(2*mub);
yphi = (V/b)*CL/(2*mub);
yp   = (V/b)*CYp/(2*mub);
yr   = (V/b)*(CYr-4*mub)/(2*mub);
ybg  = yb;
ydr  = (V/b)*CYdr/(2*mub);
den  = b*4*mub*(KX2*KZ2-KXZ^2)/V;
lb   = (Clb*KZ2+Cnb*KXZ)/den;
lp   = (Clp*KZ2+Cnp*KXZ)/den;
lr   = (Clr*KZ2+Cnr*KXZ)/den;
lda  = (Clda*KZ2+Cnda*KXZ)/den;
ldr  = (Cldr*KZ2+Cndr*KXZ)/den;
lug  = (-Clrw*KZ2-Cnrw*KXZ)/den;
lbg  = lb;
lag  = (Clpw*KZ2+Cnpw*KXZ)/den;
nb   = (Clb*KXZ+Cnb*KX2)/den;
np   = (Clp*KXZ+Cnp*KX2)/den;
nr   = (Clr*KXZ+Cnr*KX2)/den;
nda  = (Clda*KXZ+Cnda*KX2)/den;
ndr  = (Cldr*KXZ+Cndr*KX2)/den;
nug  = (-Clrw*KXZ-Cnrw*KX2)/den;
nbg  = nb;
nag  = (Clpw*KXZ+Cnpw*KX2)/den;
aug1 =-(V/Lg)^2*(1/(tau1*tau2));
aug2 =-(tau1+tau2)*(V/Lg)/(tau1*tau2);
aag1 =-(V/Lg)^2*(1/(tau4*tau5));
aag2 =-(tau4+tau5)*(V/Lg)/(tau4*tau5);
abg1 =-(V/Lg)^2;
abg2 =-2*(V/Lg);
bug1 = tau3*sqrt(Iug0*V/Lg)/(tau1*tau2);
bug2 = (1-tau3*(tau1+tau2)/(tau1*tau2))*sqrt(Iug0*(V/Lg)^3)/(tau1*tau2);
bag1 = tau6*sqrt(Iag0*V/Lg)/(tau4*tau5);
bag2 = (1-tau6*(tau4+tau5)/(tau4*tau5))*sqrt(Iag0*(V/Lg)^3)/(tau4*tau5);
bbg1 = sigmabg*sqrt(3*V/Lg);
bbg2 = (1-2*sqrt(3))*sigmabg*sqrt((V/Lg)^3);

A = [yb  yphi yp    yr   ybg  0;
     0   0    2*V/b 0    0    0;
     lb  0    lp    lr   lbg  0;
     nb  0    np    nr   nbg  0;
     0   0    0     0    0    1;
     0   0    0     0    abg1 abg2];

B = [0      ydr  0;
     0      0    0;
     lda    ldr  0;
     nda    ndr  0;
     0      0    bbg1;
     0      0    bbg2];

%% =========== EXTRACTION OF THE SIMPLIFIED ASYMMETRIC MODEL ===========
den_s = 4*mub*KZ2*b;

As = [0              -2*V/b          0               0;
     Cnb*V/den_s    Cnr*V/den_s     Cnb*V/den_s     0;
     0              0               0               1;
     0              0               abg1            abg2];

Bs = [0                 0                 0;
      Cnda*V/den_s      Cndr*V/den_s      0;
      0                 0                 bbg1;
      0                 0                 bbg2];


save('acdata.mat', 'A', 'B','As','Bs','V','b');


