function latex_code = latex_head(test_settings)
% TODO:
%     latex_msg_head1 = sprintf("%-30s","\multirow{2}{*}{$\Omega$}") + "&" + sprintf("%-30s","\multirow{2}{*}{$M$}") + "&" + sprintf("%-30s","\multirow{2}{*}{$\hat r$}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Prony LS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Prony TLS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Matrix Pencil LS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Matrix Pencil TLS}") + "\\ \cline{4-11}"+newline;
%     latex_msg_subh1 = sprintf("%-30s","") + "&" + sprintf("%-30s","") + "&" + sprintf("%-30s","") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "\\ \hline"+newline;
%     latex_msg_head2 = sprintf("%-30s","\multirow{2}{*}{$\Omega$}") + "&" + sprintf("%-30s","\multirow{2}{*}{$M$}") + "&" + sprintf("%-30s","\multirow{2}{*}{$\hat r$}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Matrix Pencil SVD LS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Matrix Pencil SVD TLS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{ESPRIT LS}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{ESPRIT TLS}") + "\\ \cline{4-11}"+newline;
%     latex_msg_subh2 = sprintf("%-30s","") + "&" + sprintf("%-30s","") + "&" + sprintf("%-30s","") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "\\ \hline"+newline;
%     latex_code = {latex_msg_head1+latex_msg_subh1, latex_msg_head2+latex_msg_subh2};

    latex_msg_head1 = sprintf("%-30s","\multirow{2}{*}{$\Omega$}") + "&" + sprintf("%-30s","\multirow{2}{*}{$M$}") + "&" + sprintf("%-30s","\multirow{2}{*}{$\hat r$}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Prony}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Matrix Pencil}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{Matrix Pencil SVD}") + "&" + sprintf("%-61s","\multicolumn{2}{l|}{ESPRIT}") + "\\ \cline{4-11}"+newline;
    latex_msg_subh1 = sprintf("%-30s","") + "&" + sprintf("%-30s","") + "&" + sprintf("%-30s","") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "&" + sprintf("%-30s","RMSE") + "&" + sprintf("%-30s","INE") + "\\ \hline"+newline;
    latex_code = {latex_msg_head1+latex_msg_subh1};

end