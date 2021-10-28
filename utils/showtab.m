function [] = showtab(lst, viewpoints, M, r, verbose, print_latex)
% This script is a part of the spectrum recovery project, use this script 
% to align the groundtruth and recovered spectrum displayed in a table, 
% and compute the recovery error. 
%
% **********  Signature ************
% Author:       Jiahui Cheng
% Date:         March 21, 2021
% License:      All right reserved.
% ----------------------------------------------------------------------------------
%  Copyright (c) 2021, Jiahui Cheng
%  All rights reserved.
    arguments
        lst
        viewpoints
        M 
        r
        verbose logical 
        print_latex logical = false
    end
    plot_bar_graph = false;


    %%%%% advanced sorting table %%%%%%%
    disp("*** Recovered Spectrum !! ***")
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
            
%             switch char(name)
%                 case {"Prony_LS","Prony_TLS","Matrix_Pencil_LS","Matrix_Pencil_TLS"}
%                     latex_msg_line1 = latex_msg_line1 + "&" + pp(err(char(name)),1) + "&" + pp(infe(char(name)),1);
% %                     latex_msg = latex_msg+sprintf("& %5s & %5s ", "$"+strrep(num2str(err(char(name)),'%.1e'),'e-','\cdot 10^{-')+"}$", "$"+ strrep(num2str(infe(char(name)),'%.1e'), 'e-', '\cdot 10^{-')+"}$");
%                 case {"ESPRIT_LS","ESPRIT_TLS","Matrix_Pencil_SVD_LS","Matrix_Pencil_SVD_TLS"}
%                     latex_msg_line2 = latex_msg_line2 + "&" + pp(err(char(name)),1) + "&" + pp(infe(char(name)),1);
%             end
        end
    end
    latex_msg_head1 = sprintf("%-30s","\multirow{2}{*}{$\Omega$}") + "&" + sprintf("%-30s","\multirow{2}{*}{$M$}") + "&" + sprintf("%-30s","\multirow{2}{*}{$\hat r$}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Prony LS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Prony TLS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Matrix Pencil LS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Matrix Pencil TLS}") + "\\ \cline{4-11}";
    latex_msg_subh1 = sprintf("%-30s","") + "&" + sprintf("%-30s","") + "&" + sprintf("%-30s","") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "\\ \hline";
    latex_msg_line1 = sprintf("%-30s","$\{"+strjoin(string(viewpoints),",")+"\}$") + "&" + sprintf("%-30d",M) + "&" + sprintf("%-30d",r) + print_line("Prony_LS",err,infe) + print_line("Prony_TLS",err,infe) + print_line("Matrix_Pencil_LS",err,infe) + print_line("Matrix_Pencil_TLS",err,infe) + "\\ \cline{4-11}";
    latex_msg_head2 = sprintf("%-30s","\multirow{2}{*}{$\Omega$}") + "&" + sprintf("%-30s","\multirow{2}{*}{$M$}") + "&" + sprintf("%-30s","\multirow{2}{*}{$\hat r$}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Matrix Pencil SVD LS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Matrix Pencil SVD TLS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{ESPRIT LS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{ESPRIT TLS}") + "\\ \cline{4-11}";
    latex_msg_subh2 = sprintf("%-30s","") + "&" + sprintf("%-30s","") + "&" + sprintf("%-30s","") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "\\ \hline";
    latex_msg_line2 = sprintf("%-30s","$\{"+strjoin(string(viewpoints),",")+"\}$") + "&" + sprintf("%-30d",M) + "&" + sprintf("%-30d",r) + print_line("Matrix_Pencil_SVD_LS",err,infe) + print_line("Matrix_Pencil_SVD_TLS",err,infe) + print_line("ESPRIT_LS",err,infe) + print_line("ESPRIT_TLS",err,infe) + "\\ \cline{4-11}";
    disp(tres)
    disp("*** Error ***")
    disp(head_msg)
    disp(rmse_msg)
    disp(infe_msg)
    disp("*** Latex ***")
    disp(latex_msg_head1)
    disp(latex_msg_subh1)
    disp(latex_msg_line1)
    disp(latex_msg_head2)
    disp(latex_msg_subh2)
    disp(latex_msg_line2)

    
    %%%%% Plot Bar Graph %%%%%%%
    if plot_bar_graph
        width = 3;     % Width in inches
        height = 3;    % Height in inches
        alw = 0.75;    % AxesLineWidth
        fsz = 11;      % Fontsize
        lw = 1.5;      % LineWidth
        msz = 8;       % MarkerSize
        figure;
        bar([1:size(tres.('Ground_Truth')(idx),1)],[real(tres.('Ground_Truth')(idx)),real(tres.('Prony_LS')(idx)),real(tres.('Matrix_Pencil_LS')(idx)),real(tres.('ESPRIT_LS')(idx))]);
        legend("Ground Truth","Prony LS","Matrix Pencil LS","ESPRIT LS",'location','best');
        xlabel("Index of Eigenvalue");
        ylabel("Value");
    %     title("Real Part of Ground Truth and Recovered Eigenvalues");
        figure;
        bar([1:size(tres.('Ground_Truth')(idx),1)],[imag(tres.('Ground_Truth')(idx)),imag(tres.('Prony_LS')(idx)),imag(tres.('Matrix_Pencil_LS')(idx)),imag(tres.('ESPRIT_LS')(idx))]);
        legend("Ground Truth","Prony LS","Matrix Pencil LS","ESPRIT LS",'location','southeast');
        xlabel("Index of Eigenvalue");
        ylabel("Value");
    %     title("Imaginary Part of Ground Truth and Recovered Eigenvalues");
    end 

    if print_latex
        Ttmp = removevars(tres,{'ESPRIT_TLS', 'Matrix_Pencil_SVD_LS', 'Matrix_Pencil_SVD_TLS', 'Matrix_Pencil_TLS', 'Prony_TLS'});
        % Now use this table as input in our input struct:
        input.data = Ttmp;

        % Switch transposing/pivoting your table if needed:
        input.transposeTable = 0;

        % Switch to generate a complete LaTex document or just a table:
        input.makeCompleteLatexDocument = 1;
        ls = latexTable(input);
        %%%%%%%%%%% end of sorting %%%%%%%%%%
    end 
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