function [a, lambert_solve_info] = lambert_battin_method(r_1, r_2, ToF, TA, lambert_type, options)
%LAMBERT_BATTIN_METHOD Summary of this function goes here
%   Fundamentals of Astrodynamics 7.6.4
arguments
    r_1
    r_2
    ToF
    TA
    lambert_type (1, 1) LambertType
    options.mu = 1
    options.x_tol = 1e-8
    options.max_iter = 1e3
    options.continued_fraction_depth = 20 % don't know good depth (must be >= 4)
end
cos_half_TA = cos(TA / 2);
cos_quarter_TA_sqr = cos(TA / 4) ^ 2;
sin_quarter_TA_sqr = sin(TA / 4) ^ 2;

epsilon = (r_2 - r_1) / r_1;

tan_2w_sqr = (epsilon ^ 2 / 4) / (sqrt(r_2 / r_1) + (r_2 / r_1) * (2 + sqrt(r_2 / r_1)));

% parabolic mean point radius
r_op = sqrt(r_1 * r_2) * (cos_quarter_TA_sqr + tan_2w_sqr);

if TA <= pi
    l = (sin_quarter_TA_sqr + tan_2w_sqr) / (sin_quarter_TA_sqr + tan_2w_sqr + cos_half_TA);
elseif TA > pi
    l = (cos_quarter_TA_sqr + tan_2w_sqr - cos_half_TA) / (cos_quarter_TA_sqr + tan_2w_sqr);
end

m = options.mu * ToF ^ 2 / (8 * r_op ^ 3);

x = zeros([options.max_iter + 1, 1]);
if lambert_type.conic_type == "Ellipse"
    x(1) = l;
else
    x(1) = 0;
end

% Iterate to find x, y
y = zeros([options.max_iter, 1]);
xi_level = zeros([options.continued_fraction_depth, 1]);
front_term = ones([options.continued_fraction_depth, 1]);
for i = 1 : options.max_iter + 1
    eta = x(i) / (sqrt(1 + x(i)) + 1) ^ 2;

    % Create xi continued fraction parts
    xi_level(1) = 8 * (sqrt(1 + x(i)) + 1);
    front_term(1) = 0;
    xi_level(2) = 1;
    front_term(2) = 3;
    xi_level(3) = 9 / 7 * eta;
    front_term(3) = 5 + eta;
    for n = 4 : options.continued_fraction_depth
        c_eta = n ^ 2 / ((2 * n) ^ 2 - 1);
        xi_level(n) = c_eta * eta;
    end
    % Build continued fraction for xi
    xi = 1;
    for n = options.continued_fraction_depth : -1 : 1
        xi = front_term(n) + xi_level(n) / xi;
    end

    h_1 = (l + x(i)) ^ 2 * (1 + xi + 3 * x(i)) / ((1 + 2 * x(i) + l) * (4 * x(i) + xi * (3 + x(i))));
    h_2 = m * (x(i) - l + xi) / ((1 + 2 * x(i) + l) * (4 * x(i) + xi * (3 + x(i))));

    % Continued fraction method to solve y^3 - y^2 - h_1 * y^2 - h^2 = 0
    % B = 27 * h_2 / (4 * (1 + h_1) ^ 3);
    % U = B / (2 * sqrt(1 + B) + 1);
    % 
    % K = 1;
    % for n = 500 : -1 : 0
    %     if mod(n, 2) == 0
    %         c_U = 2 * (3 * n + 2) * (6 * n + 1) / (9 * (4 * n + 1) * (4 * n + 3));
    %     else
    %         c_U = 2 * (3 * n + 1) * (6 * n - 1) / (9 * (4 * n - 1) * (4 * n + 1));
    %     end
    % 
    %     K = 1 + c_U * U / K;
    % end
    % K = 1 / 3 / K;
    % 
    % y = (1 + h_1) / 3 * (2 + sqrt(1 + B) / (1 + 2 * U * K ^ 2));
    % 
    % Check root (continued fraction method slightly off...)
    y_ck = roots([1, -1 - h_1, 0, -h_2]);
    y(i) = max(real(y_ck(imag(y_ck) == 0)));

    x(i + 1) = sqrt(((1 - l) / 2) ^ 2 + m / y(i) ^ 2) - (1 + l) / 2;
    
    % Check stopping condition
    if abs(x(i + 1) - x(i)) < options.x_tol
        break;
    elseif i + 1 == options.max_iter
        error("Battin reached max iterations of %d, x diff is %.3g while x tol is %.3g", options.max_iter, abs(x(i + 1) - x(i)), options.x_tol);
    end
end 
    
% Compute a from x, y
a_iterations = options.mu * ToF ^ 2 ./ (16 * r_op ^ 2 * x(2:(i + 1)) .* y(1 : i) .^ 2);

% Calculate initial a guess (kind of)
a_guess = options.mu * ToF ^ 2 ./ (16 * r_op ^ 2 * x(1) .* y(1) .^ 2);

% Get best a
a = a_iterations(end);

% Package solve info
lambert_solve_info.method = "Battin";
lambert_solve_info.iterations = i;
lambert_solve_info.a_guess = a_guess;
lambert_solve_info.a_iterations = a_iterations;

end