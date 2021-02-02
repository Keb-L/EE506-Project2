function mfout = receiver(sig, snoise, tsim, snrA, puls)
% sig    : signal w/o noise from transmitter
% snoise : signal + noise from transmitter
% tsim   : simulation time vector
% snrA   : signal-to-noise amplitude
% puls   : pulse samples

    hmf = puls(end:-1:1);           % Matched filter coefficients (reversed signal)
    mfout = filter(hmf,1,snoise);   % Apply correlation
    
    thresh = 0.8*snrA; % threshold at 80% of the max correlated value
    MFidx = find(mfout >= thresh); % Matched Filter response indices
    
    % Plot the matched filter response + markers
    figure(); 
    plot(tsim, snoise, 'b'); hold on;
    plot(tsim, mfout, 'r'); 
    plot(MFidx - 1, mfout(MFidx), 'gx', 'MarkerSize', 12,'linewidth',2);
    legend({'Rcv Sig', 'MF Rsp', 'MF peaks'}, 'Location', 'southeast');
    grid on;
    xlabel('Simulation Time'); ylabel('Amplitude'); title('Rcv Matched Filter Output');
    
    % Plot the matched filter peaks overlay with input (clean)
    figure()
    plot(tsim, sig, 'b'); hold on;
    plot(MFidx - 1, zeros(1, length(MFidx)), 'gx', 'MarkerSize', 12, 'linewidth',2);
    grid on;
    xlabel('Simulation Time'); ylabel('Amplitude'); title('Rcv Matched Filter Peaks');
    legend({'Signal', 'Detected'});
    

end