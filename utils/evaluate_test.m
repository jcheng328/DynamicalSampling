%{

    This script evaluate the system identification of various algorithm,
    it will display the result and output the latex source code.

    input: observ           observations
           test_settings    test settings
           verbose          silent if true
%}

function [latex_code] = evaluate_test(speclst, instance_settings, verbose)
    arguments
        speclst 
        instance_settings struct
        verbose logical = false
    end
    %% get settings
    viewpoints = instance_settings.viewpoints;
    M = instance_settings.temporal_size;
    r = instance_settings.numerical_rank;
    lst = speclst;
    
    
    %% advanced sorting table 
%     disp("*** Recovered Spectrum !! ***")
    N = max(cellfun('size', lst.values, 1)); % max number of spectrum, it will decide the number of rows in the table.
    gt = lst('Ground_Truth');
    gt2d = [real(gt), imag(gt)];
    [a, a2gt, gt2a] = uniquetol(gt2d, 1e-5,'ByRows',true, 'Datascale',1); % get unique elements within certain tolerance.
    [ac, av] = groupcounts(gt2a); % get how many times does each element occurs in the spectrum list
    rec(av,1) = ac;
    for key = lst.keys()
        if char(key) ~= "Ground_Truth"
            spec = lst(char(key));
            spec2d = [real(spec), imag(spec)];
            ib = knnsearch(a, spec2d);
            [bc, bv] = groupcounts(ib);
            rec(bv,size(rec,2)+1) = bc; % record # of times each spectrum is recovered.
        end
    end
    ts = max(rec, [], 2); % compute the maximum of times each spectrum is recovered among all the methods.

    tres = table;
    err = containers.Map;infe = containers.Map;
    col = nan(sum(ts),1);
    for k = 1:size(av,1)
        p = k;
        col(sum(ts(1:p-1))+1:sum(ts(1:p-1))+ts(p)) = size(av,1)-k+1;
    end
    tres.(char('Index_of_Eigenvalue')) = flipud(col);

    col = nan(sum(ts),1);
    for k = 1:size(av,1)
        p = k;
        col(sum(ts(1:p))-sum(gt2a==p)+1:sum(ts(1:p))) = gt(gt2a==p);
    end
    tres.(char("Ground_Truth")) = flipud(col);

    rmse_msg = sprintf("%10s",'RMSE');
    infe_msg = sprintf("%10s",'InfE');
    head_msg = sprintf("%10s",'Name');
    latex_msg_line1 = "";
    latex_msg_line2 = "";
    for key = lst.keys()
        spec = lst(char(key));
        spec2d = [real(spec), imag(spec)];
        ib = knnsearch(a, spec2d);
        [bc, bv] = groupcounts(ib);
        col = nan(sum(ts),1);
        for k = 1:size(av,1)
            p = k;
            col(sum(ts(1:p))-sum(ib==p)+1:sum(ts(1:p))) = spec(ib==p);
        end
        tres.(char(key)) = flipud(col);

        igt = knnsearch(gt2d, spec2d);
        tse_error = norm(gt(igt)-spec);
        mse_error = tse_error/sqrt(size(gt,1));
        err(char(key)) = mse_error;
        infe(char(key)) = max(abs(gt(igt)-spec));
    end
    % Reorder the table variables
    tres = movevars(tres, 'ESPRIT_TLS', 'After', 10);
    tres = movevars(tres, 'Matrix_Pencil_SVD_TLS', 'After', 10);
    tres = movevars(tres, 'Matrix_Pencil_TLS', 'After', 10);
    tres = movevars(tres, 'Prony_LS', 'After',2);
    tres = movevars(tres, 'ESPRIT_LS', 'After', 3);
    tres = movevars(tres, 'Ground_Truth', 'After', 1);
    for k = 1: size(tres,2)
        name = tres.Properties.VariableNames(k);
        if char(name) ~= "Ground_Truth" & char(name) ~= "Index_of_Eigenvalue"
            rmse_msg = rmse_msg + sprintf("%25s", num2str(err(char(name))));
            head_msg = head_msg + sprintf("%25s", string(name));
            infe_msg = infe_msg + sprintf("%25s", num2str(infe(char(name))));

        end
    end

    % TODO : Add the following version to the code
%     latex_msg_line1 = sprintf("%-30s","$\{"+strjoin(string(viewpoints),",")+"\}$") + "&" + sprintf("%-30d",M) + "&" + sprintf("%-30d",r) + print_line("Prony_LS",err,infe) + print_line("Prony_TLS",err,infe) + print_line("Matrix_Pencil_LS",err,infe) + print_line("Matrix_Pencil_TLS",err,infe) + "\\ \cline{4-11}"+newline;
%     
%     latex_msg_line2 = sprintf("%-30s","$\{"+strjoin(string(viewpoints),",")+"\}$") + "&" + sprintf("%-30d",M) + "&" + sprintf("%-30d",r) + print_line("Matrix_Pencil_SVD_LS",err,infe) + print_line("Matrix_Pencil_SVD_TLS",err,infe) + print_line("ESPRIT_LS",err,infe) + print_line("ESPRIT_TLS",err,infe) + "\\ \cline{4-11}"+newline;
    
%     latex_code = {latex_msg_line1, latex_msg_line2};

    latex_msg_line1 = sprintf("%-30s","$\{"+strjoin(string(viewpoints),",")+"\}$") + "&" + sprintf("%-30d",M) + "&" + sprintf("%-30d",r) + print_line("Prony_LS",err,infe) + print_line("Matrix_Pencil_LS",err,infe) + print_line("Matrix_Pencil_SVD_LS",err,infe) + print_line("ESPRIT_LS",err,infe) + "\\ \cline{4-11}"+newline;
    
    latex_code = {latex_msg_line1};


%     disp(tres)
%     disp("*** Error ***")
%     disp(head_msg)
%     disp(rmse_msg)
%     disp(infe_msg)
    % 根据methods数量生成cell array
    
end

function s = print_line(name, err, infe)
% pretty-print error
    s = "&" + sprintf("%-30s", pp(err(char(name)),1)) + "&" + sprintf("%-30s", pp(infe(char(name)),1));
end
function s=pp(x,n)
% pretty-print a value in scientific notation
% usage: s=pp(x,n)
% where: x a floating-point value
%        n is the number of decimal places desired
%        s is the string representation of x with n decimal places, and
%          exponent k
exponent=floor(log10(abs(x))); %to accomodate for negative values
mantissa=x/(10^exponent);
if exponent ~= 0
    s=sprintf('$%*.*f \\cdot 10^{%d}$',n+3,n,mantissa,exponent);
else 
    s=sprintf('$%*.*f$',n+3,n,mantissa);
end
% returns something like '$1.42 \times 10^{-1}$'
end
