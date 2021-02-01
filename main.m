clear all; close all; clc;

%% Parameters
Tsamp = 1; % Sampling period
Tsym = 2; % Symbol period
SNRdB = 18; % Signal to Noise Ratio (dB)
Lt = 1000; % Total time for simulation
Ksig = 20; % Number of signal instances

%% Generate input signals (Raised Cosine or Sinc)
% Uniformly sampled within Lt
% Generate sampled plot (INI)

% Time
tsim = 0:Tsamp:Lt;  % Sampled simulation timestamps
tsym = tsim(1:Tsym:end);    % Symbol timestamps

% puls = sincpuls(Tsym, -5*Tsym:5*Tsym);
puls = rtrcpuls(0.3, Tsym, -5*Tsym:5*Tsym);
RCpulse = rcpulse(0.3, Tsym, -5*Tsym:5*Tsym);


%% Generate pulse train
% Uniformly sample (without replacement) from symbol timestamps
ds = datasample(tsym(1:end-10), Ksig, 'Replace', false); % get symbol timestamps randomly
h = zeros(1, Lt+1); h(ds+1) = 1; % Create impulse train

sig = filter(puls, 1, h); % Create pulse train

snr = 10^(SNRdB/10); snrA = sqrt(snr); % Compute SNR


%% Transmitter + Channel Noise (AWGN)
% Generate input and input+noise plots
% Normalize transmitted output
snoise = transmitter(snr,Ksig,Lt,puls);
snoise2 = transmitter(snr,Ksig,Lt,RCpulse);

%% Receiver
% Generate input+noise plot and Matched filter + thresholding
mfout = receiver(sig, snoise, tsim, snrA, puls);

