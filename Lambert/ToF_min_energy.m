function [ToF_m, e_m, p_m, alpha_m, beta_m] = ToF_min_energy(r_1, r_2, s, c, TA, a_m, mu)
%TOF_MIN_ENERGY Summary of this function goes here
%   Detailed explanation goes here
arguments
    r_1
    r_2
    s
    c
    TA
    a_m = s / 2
    mu = 1
end

alpha_m = 2 * asin(sqrt(s / (2 * a_m))); % [rad]
beta_m = sign(pi - TA) * 2 * asin(sqrt((s - c) / (2 * a_m)));
p_m = 4 * a_m * (s - r_1) * (s - r_2) / c ^ 2 * sin((alpha_m + beta_m) / 2) ^ 2;
e_m = sqrt(1 - p_m / a_m);
ToF_m = sqrt(a_m ^ 3 / mu) * ((alpha_m - beta_m) - (sin(alpha_m) - sin(beta_m)));

end