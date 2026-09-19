function [c, s, a_m] = calculate_space_triangle(r1, r2, TA)
%CALCULATE_SPACE_TRIANGLE Summary of this function goes here
%   Detailed explanation goes here
arguments
    r1
    r2
    TA % [rad]
end

c = sqrt(r1 ^ 2 + r2 ^ 2 - 2 * r1 * r2 * cos(TA));
s = (r1 + r2 + c) / 2;
a_m = s / 2;

end