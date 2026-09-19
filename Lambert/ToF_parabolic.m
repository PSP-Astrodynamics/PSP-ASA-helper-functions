function [ToF_parabolic] = ToF_parabolic(s, c, mu)
%TOF_PARABOLIC Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    s
    c
    mu = 1 % Default is nondim
end

ToF_parabolic = zeros([2, 1]);

% P1 (minus) - always smaller ToF
ToF_parabolic(1) = 1/3 * sqrt(2 / mu) * (s^(3/2) - (s-c)^(3/2));
% P2 (plus) - always bigger ToF
ToF_parabolic(2) = 1/3 * sqrt(2 / mu) * (s^(3/2) + (s-c)^(3/2));

end