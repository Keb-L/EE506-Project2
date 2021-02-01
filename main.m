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

% Raised Cosine Pulse
function y = rcpulse(a,t)

    tau = 1; % Symbol time
    t = t+0.0000001; % Insert offset to prevent NANs
    tpi = pi/tau; atpi = a*tpi; at = 4*a^2/tau^2;
    y = sin(tpi*t).*cos(atpi*t)./(tpi*t.*(1-at*t.^2));
    
end
%% Generate pulse train
% Uniformly sample (without replacement) from symbol timestamps
ds = datasample(tsym(1:end-10), Ksig, 'Replace', false); % get symbol timestamps randomly
h = zeros(1, Lt+1); h(ds+1) = 1; % Create impulse train

sig = filter(puls, 1, h); % Create pulse train

snr = 10^(SNRdB/10); snrA = sqrt(snr); % Compute SNR


%% Transmitter + Channel Noise (AWGN)
% Generate input and input+noise plots
% Normalize transmitted output
function snoise = transmitter(SNRdB, Ksig, Lt, s)
    
     snr = 10^(SNRdB/10);
%     sigma2n = 1; % Unit variance for noise
%     sigmaN = sqrt(sigma2N); % Standard Deviation of the noise
    
    snoise = s * snr + randn(Lt,1); % add noise to input signal
    t = [1:Lt]'; % time index
    
    subplot(2,1,1) 
    plot(t,s), title('Transmitted Signal W/O Noise')
    
    sublot(2,1,2)
    plot(t,snoise), title('Noisy(AWGN) Signal')
    

end

%% Receiver
% Generate input+noise plot and Matched filter + thresholding
mfout = receiver(sig, snoise, tsim, snrA, puls);

