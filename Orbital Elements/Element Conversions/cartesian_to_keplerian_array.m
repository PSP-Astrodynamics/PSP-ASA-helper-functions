function [x_keplerian, nu] = cartesian_to_keplerian_array(x_cartesian_array, mu, Khat, Ihat)
arguments
    x_cartesian_array
    mu
    Khat = [0; 0; 1] % z direction
    Ihat = [1; 0; 0] % x direction
end
%CARTESIAN_TO_KEPLERIAN_ARRAY Summary of this function goes here
%   Detailed explanation goes here
    x_keplerian = zeros(6, size(x_cartesian_array, 2));
    nu = zeros([size(x_cartesian_array, 2), 1]);

    for ind = 1:size(x_cartesian_array, 2)
        x_cartesian = x_cartesian_array(:, ind);

        [x_keplerian(:, ind), nu(ind)] = cartesian_to_keplerian(x_cartesian, mu, Khat, Ihat);
    end
end