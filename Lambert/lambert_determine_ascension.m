function [thetastar, ascension] = lambert_determine_ascension(r, e, p, TA)
%LAMBERT_DETERMINE_ASCENSION Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    r (2, 1)
    e (2, 1)
    p (2, 1)
    TA
end

thetastar_principal = acos(1 ./ e .* (p ./ r - 1));
thetastar_array = wrapTo2Pi([thetastar_principal(1),  thetastar_principal(2);
                             thetastar_principal(1), -thetastar_principal(2);
                            -thetastar_principal(1),  thetastar_principal(2);
                            -thetastar_principal(1), -thetastar_principal(2)]);

% Find delta thetastar which is the same as TA
thetastar = thetastar_array(abs(wrapTo2Pi(thetastar_array(:, 2) - thetastar_array(:, 1)) - TA) < 1e-5, :)';
 
ascension = sign(wrapToPi(thetastar));

end