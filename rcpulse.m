% Raised Cosine Pulse
function y = rcpulse(a,t)

    tau = 1; % Symbol time
    t = t+0.0000001; % Insert offset to prevent NANs
    tpi = pi/tau; atpi = a*tpi; at = 4*a^2/tau^2;
    y = sin(tpi*t).*cos(atpi*t)./(tpi*t.*(1-at*t.^2));
    
end