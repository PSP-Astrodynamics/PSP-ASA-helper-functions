function [alpha, beta, alpha_0, beta_0] = select_alpha_beta(s, c, a, lambert_type)
%SELECT_ALPHA_BETA Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    s
    c
    a
    lambert_type (1, 1) LambertType 
end

if lambert_type.conic_type == "Ellipse"
    % Compute principle values
    alpha_0 = 2 * asin(sqrt(s / (2 * a)));
    beta_0 = 2 * asin(sqrt((s - c) / (2 * a)));
    
    % Select alpha, beta
    if lambert_type == LambertType.E1A || lambert_type == LambertType.E1min || lambert_type == LambertType.E2min
        alpha = alpha_0; 
        beta = beta_0;
    elseif lambert_type == LambertType.E1B
        alpha = 2 * pi - alpha_0;
        beta = beta_0;
    elseif lambert_type == LambertType.E2A
        alpha = alpha_0;
        beta = -beta_0;
    elseif lambert_type == LambertType.E2B
        alpha = 2 * pi - alpha_0;
        beta = -beta_0;
    end
elseif lambert_type.conic_type == "Parabola"
    alpha = 0;
    beta = 0;
elseif lambert_type.conic_type == "Hyperbola"
    % Compute principle values
    alpha_0 = 2 * asinh(sqrt(s / (2 * abs(a))));
    beta_0 = 2 * asinh(sqrt((s - c) / (2 * abs(a))));
    
    % Select alpha, beta
    if lambert_type == LambertType.H1
        alpha = alpha_0;
        beta = beta_0;
    elseif lambert_type == LambertType.H2
        alpha = alpha_0;
        beta = -beta_0;
    end
end
end