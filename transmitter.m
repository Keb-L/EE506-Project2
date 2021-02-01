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