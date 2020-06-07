function [rhoa, theta] = MT1DFW(rho, h, freq)
% [rhoa, theta] = MT1DFW(rho, h, freq)
% This is the 1-Dimension magnetotelluric forward program for a horizontally layered isotropic model.
% By Tche.L form USTC, 2015.12.

% rho: a vector [nLayer, 1], the resistivity of every layer.
% h: a vector [nLayer, 1], the last one element is Inf, the thickness of every layer.
% freq: a vector [nFreq, 1], the prospecting frequency series. 

% rhoa: a vector [nFreq, 1], the apparent resistivity for every frequency point.
% theta: a vector [nFreq, 1], the apparent phase for every frequency point.

mu = 4*pi*1e-7;                                                 % the magnetic permeability in vacuum.

nFreq = length(freq);

rhoa = zeros(nFreq, 1);
theta = zeros(nFreq, 1);

for i = 1:nFreq
    OmgMu = 2*pi*freq(i)*mu;                                    % a intermediate variable, omega*mu.
    k = sqrt(OmgMu./rho.*1i);                                   % the wave number, i.e. the propagation constant of every layer.
    RN0 = CalRN0(1, k, OmgMu, h, rho);                          % a intermediate variable, R_N(0), refer to the formula (3.2) on page 22 of (朱仁学，2003).
    rhoa(i) = rho(1)*abs(RN0)^2;                                % refer to the formula (3.3) on page 22 of (朱仁学，2003).
    theta(i) = - 45 + atan(imag(RN0)/real(RN0))/pi*180;         % refer to the related formulas on page 40 of (朱仁学，2003).
end

% lambda1 = sqrt(10*rho(1)./freq)*1000;                           % the wave length of the 1st layer, refer to the formula (2.23) on page 11 of (朱仁学，2003).
% loglog(lambda1./h(1), rhoa./rho(1));

% save('MT1D.mat', 'freq', 'rhoa', 'theta');

end

function RN0 = CalRN0(ith, k, OmgMu, h, rho)
% RN0 = CalRN0(ith, k, OmgMu, h, rho)
% This is a subroutine that calculates the intermediate variable, R_N(0), for the 1-Dimension magnetotelluric forward program MT1DFW.
% Refer to the formula (3.2) on page 22 of (朱仁学，2003).
% By Tche.L. from USTC, 2015.12.

% ith: it is the ith time to recursively call this function.
% k: a vector [nLayer, 1], the wave number.
% OmgMu: a constant variable, omega*mu.
% h: a vector [nLayer, 1], the last one element is Inf, the thickness of every layer.
% rho: a vector [nLayer, 1], the resistivity of every layer.

nLayer = length(rho);

if(ith == nLayer)
    RN0 = 1;
else
    RN0 = CalRN0(ith + 1, k, OmgMu, h, rho);
    x = k(ith)/k(ith + 1)*RN0;
    if(rho(ith) < rho(ith + 1))
        x = acoth(x) - k(ith)*h(ith)*1i;
        RN0 = coth(x);
    else
        x = atanh(x) - k(ith)*h(ith)*1i;
        RN0 = tanh(x);
    end
end

end
