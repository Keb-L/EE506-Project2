clear all; close all; clc;

%% Parameters
dt = 0.01; % delta time
Tsym  = 5; % Symbol period
Tbaud = 5; % Symbol every N

SNRdB = 18; % Signal to Noise Ratio (dB)
Lt = 3000; % Total time for simulation
Ksig = floor(Lt / Tbaud); % Number of signal instances

%% Generate input signals (Raised Cosine or Sinc)
% Uniformly sampled within Lt
% Generate sampled plot (INI)

% Time
tsim = 0:dt:Lt;  % Sampled simulation timestamps

puls = rectangularPulse(-Tsym/2, Tsym/2, (-5*Tsym:dt:5*Tsym));
% puls = sincpuls(Tsym, (-5*Tsym:dt:5*Tsym));
% puls = rtrcpuls(0.2, Tsym, (-5*Tsym:dt:5*Tsym));
% puls = rcpulse(0.2, Tsym,  (-5*Tsym:dt:5*Tsym));

% Normalize puls
puls = puls / rms(puls); 

fprintf('Signal power: %.02f\n', rms(puls).^2);

figure;
plot((-5*Tsym:dt:5*Tsym), puls, ...
     (-4*Tsym:dt:6*Tsym), puls, ...
     (-6*Tsym:dt:4*Tsym), puls);

%% Generate pulse train
% Uniformly sample (without replacement) from symbol timestamps
ds_bits = datasample([-1 1], Ksig);

eps = 0; % round(0.2*Tsym)/dt;
h = zeros(1, length(tsim)); h(linspace(1+eps, 1+eps+(Ksig-1)*Tbaud/dt, Ksig)) = ds_bits; % Create impulse train
sig = filter(puls, 1, h); % Create pulse train

snr = 10^(SNRdB/10); snrA = sqrt(snr); % Compute SNR

%% Transmitter + Channel Noise (AWGN)
% Generate input and input+noise plots
% Normalize transmitted output
snoise = sig * snrA + randn(1, length(tsim),1); 

figure;
plot(tsim, snoise);

%% Receiver
% Generate input+noise plot and Matched filter + thresholding
hmf = puls(end:-1:1);           % Matched filter coefficients (reversed signal)
mfout = filter(hmf,1,snoise);   % Apply correlation

mfpeak = max(snrA*xcorr(puls, puls)); % Normalization factor

mfnorm = mfout ./ mfpeak; % Normalize

figure;
plot(tsim, mfout);

% Sampler
% mfsamp = mfout(1:1/dt:end)./mfpeak;

%% Eye Diagram and Symbols
% Take window at each symbol location (starting at 10*Tsym)
% win = (10-0.5)*Tsym/dt:(10+0.5)*Tsym/dt;
eps = round(0*Tsym)/dt;

winL = 0.5;
win = 1+(10-winL)*Tsym/dt:(10+winL)*Tsym/dt;

% Get data bits
mfbit = zeros(1, Ksig-0.1*Ksig);

figure; hold on;
for i = 0:Ksig-1-0.1*Ksig % Drop the last one
    mfsym = mfnorm(win - eps); % MATLAB 1-indexing 
%     mfsym = mfnorm(win + 1); % MATLAB 1-indexing 
    plot(mfsym);
    
    mfbit(i+1) = mfsym(winL*Tsym/dt+1);
    
    % Increment window
    win = win + Tbaud/dt;
end
xlabel('Time (s)');
ylabel('Norm Amplitude');
ylim([-1.5, 1.5]);
plot([winL*Tsym/dt+1 winL*Tsym/dt+1], ylim(), 'k--');


figure; hold on;
plot( zeros(1, sum(mfbit < 0)), mfbit(mfbit < 0), 'ro');
plot( zeros(1, sum(mfbit > 0)), mfbit(mfbit >= 0), 'b+');
ylabel('Symbol');
ylim([-1.5, 1.5]);
