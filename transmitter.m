function snoise = transmitter(SNR, Ksig, Lt, s,tsim)
    
%     snr = 10^(SNRdB/10);
%     sigma2n = 1; % Unit variance for noise
%     sigmaN = sqrt(sigma2N); % Standard Deviation of the noise
    
    Ls = length(s);
    Tsig = 1+floor((Ls-Lt).*rand(Ksig,1));
    Tsig = sort(Tsig, 'ascend');
    Tsig = unique(Tsig);
    Ksig = length(Tsig);
    %Tmarks = Ls-1+Tsig;
    
    hsig = zeros(Lt+1,1);
    hsig(Tsig,:) = ones(Ksig,1); %These are the delay for each signal (or replica)
 
    sall = filter(s,1,hsig);%the filter delays and superposes ieach copy

    
    
    
    snoise = sall * SNR + randn(Lt+1,1); % add noise to input signal
    %t = [1:Lt]'; % time index
    
    figure
    subplot(2,1,1) 
    plot(tsim,sall), title('Transmitted Signal W/O Noise'), xlabel('Time')
    ylabel('s(t)')
    grid on
    
    subplot(2,1,2)
    plot(tsim,snoise), title('Noisy(AWGN) Signal'), xlabel('Time')
    ylabel('s(t)')
    grid on

end