clear all; close all; clc;

%% Parameters
Tsamp = 0; % Sampling period
Tsym = 0; % Symbol period
SNR = 0; % Signal to Noise Ratio (dB)
Lt = 0; % Total time for simulation
Ksig = 0; % Number of signal instances

%% Generate input signals (Raised Cosine or Sinc)
% Uniformly sampled within Lt
% Generate sampled plot (INI)


function y = rcpulse(a,t)

    tau = 1; % Symbol time
    t = t+0.0000001; % Insert offset to prevent NANs
    tpi = pi/tau; atpi = a*tpi; at = 4*a^2/tau^2;
    y = sin(tpi*t).*cos(atpi*t)./(tpi*t.*(1-at*t.^2));
    
end
%% Generate pulse train


%% Transmitter + Channel Noise (AWGN)
% Generate input and input+noise plots
% Normalize transmitted output


%% Receiver
% Generate input+noise plot and Matched filter + thresholding


