classdef LambertType
    enumeration
       E1A
       E1B
       E2A
       E2B
       E1min
       E2min
       P1
       P2
       H1
       H2
    end
    methods
        function [ctype] = conic_type(obj)
            if obj == LambertType.E1A || obj == LambertType.E1B || obj == LambertType.E2A || obj == LambertType.E2B || obj == LambertType.E1min || obj == LambertType.E2min
                ctype = "Ellipse";
            elseif obj == LambertType.P1 || obj == LambertType.P2
                ctype = "Parabola";
            elseif  obj == LambertType.H1 || obj == LambertType.H2
                ctype = "Hyperbola";
            end
        end
    end
    methods(Static)
        function [lambert_type] = determine_lambert_type(TA, ToF, ToF_min, ToF_par, options)
            arguments
                TA
                ToF
                ToF_min
                ToF_par
                options.ToF_equality_tol = 1e-5
            end

            if TA <= pi % Type 1
                if abs(ToF - ToF_par(1)) < options.ToF_equality_tol
                    lambert_type = LambertType.P1;
                elseif abs(ToF - ToF_min) < options.ToF_equality_tol
                    lambert_type = LambertType.E1min;
                elseif ToF < ToF_par(1)
                    lambert_type = LambertType.H1;
                elseif ToF < ToF_min
                    lambert_type = LambertType.E1A;
                elseif ToF > ToF_min
                    lambert_type = LambertType.E1B;
                end
            elseif TA >= pi % Type 2
                if abs(ToF - ToF_par(2)) < options.ToF_equality_tol
                    lambert_type = LambertType.P2;
                elseif abs(ToF - ToF_min) < options.ToF_equality_tol
                    lambert_type = LambertType.E2min;
                elseif ToF < ToF_par(2)
                    lambert_type = LambertType.H2;
                elseif ToF < ToF_min
                    lambert_type = LambertType.E2A;
                elseif ToF > ToF_min
                    lambert_type = LambertType.E2B;
                end
            end
        end
    end
end