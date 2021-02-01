% Generate a root raised cosine pulse
% Digital Transmission Engineering 2nd Edition
% Program 2.2-2
function y = rtrcpuls(a, Tsym, t)
% a ~ excess bandwidth factor
% tau ~ symbol time

% tau = 1; %Set symbol time
t = t + 1e-6; %Insert offset to prevent NANs
tpi = pi/Tsym; amtpi = tpi*(1-a); aptpi = tpi*(1 + a);
ac = 4*a/Tsym; at = 16*a^2/Tsym^2;
y = (sin(amtpi*t) + (ac*t).*cos(aptpi*t))./(tpi*t.*(1-at*t.^2));
y = y/sqrt(Tsym); %Unit energy
end 