clear all; close all; clc;

%% Parameters
Tsamp = 1; % Sampling period
Tsym = 2; % Symbol period
SNRdB = 18; % Signal to Noise Ratio (dB)
Lt = 1000; % Total time for simulation
Ksig = 50; % Number of signal instances

%% Generate input signals (Raised Cosine or Sinc)
% Uniformly sampled within Lt
% Generate sampled plot (INI)

% Time
tsim = 0:Tsamp:Lt;  % Sampled simulation timestamps
tsym = tsim(1:Tsym:end);    % Symbol timestamps

offset = 0;

puls = sincpuls(Tsym, (-5*Tsym:5*Tsym)-offset);
% puls = rtrcpuls(0.3, Tsym, (-5*Tsym:5*Tsym)-offset);
% puls = rcpulse(0.3, Tsym, (-5*Tsym:5*Tsym)-offset);

figure();
plot((-5*Tsym:5*Tsym), puls);
grid;
xlim([-5*Tsym, 5*Tsym]);
xlabel('Time'); ylabel('Amplitude'); title(sprintf('Sinc Pulse\nTsym=%d', Tsym));


%% Generate pulse train
% Uniformly sample (without replacement) from symbol timestamps
ds = datasample(tsym(1:end-10), Ksig, 'Replace', false); % get symbol timestamps randomly
h = zeros(1, Lt+1); h(ds+1) = 1; % Create impulse train

sig = filter(puls, 1, h); % Create pulse train

snr = 10^(SNRdB/10); snrA = sqrt(snr); % Compute SNR

%% Transmitter + Channel Noise (AWGN)
% Generate input and input+noise plots
% Normalize transmitted output
snoise = transmitter(snrA,Ksig,Lt,sig, tsim);

%% Receiver
% Generate input+noise plot and Matched filter + thresholding
mfout = receiver(sig, snoise, tsim, snrA, puls);


%% ISI
% figure();
% plot(tsim, sig);
% grid on;
% xlabel('Simulation Time'); ylabel('Amplitude'); title(sprintf('Pulse Train w/ Offset=-%.02f', offset));
% 
% figure()
% hist(sig(find(sig > 0.7)) - 1);
% ylabel('Counts');
% xlabel('Delta Amplitude');
% title(sprintf('ISI w/ Offset=-%.02f', offset));