% Generate a sinc pulse with period T
function y = sincpuls(Tsym, t)
% Tsym: symbol period
% t: time vector

y = sinc(t/Tsym);
end