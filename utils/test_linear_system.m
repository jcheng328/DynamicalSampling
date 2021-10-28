%{

    This script tests various algorithm for system retrieval.

    input: observ           observations
           test_settings    test settings
           verbose          silent if true
%}

function [speclst, instance_settings] = test_linear_system(observ, instance_settings, verbose)
    arguments
       observ double
       instance_settings struct
       verbose logical=true
    end
    speclst = Namespace();
    speclst('Ground_Truth') = instance_settings.spec;
    viewpoints = instance_settings.viewpoints;
    dim = size(observ, 1);
    N = size(observ, 2);
    % construct initial hankel matrix
    H = construct_hankel(observ, viewpoints, floor(N/2));
    
    % determine numerical rank r
    r = get_rank(H, 'spectrum_gap', size(observ,1));
    r = min(r, size(observ,1));
    plot_hankel(H, dim, r, instance_settings);
    
    instance_settings.numerical_rank = r;
    % test each method
    method_lst = instance_settings.method_lst;
    for method=method_lst
        if ~verbose
            disp("method:   "+char(method)+newline);
        end
        spec = recover(observ, viewpoints, r, char(method));
        spec = sort_complex(spec);
        if ~verbose
            disp(spec);
        end
        % record results
        speclst(char(method)) = spec;
    end
end