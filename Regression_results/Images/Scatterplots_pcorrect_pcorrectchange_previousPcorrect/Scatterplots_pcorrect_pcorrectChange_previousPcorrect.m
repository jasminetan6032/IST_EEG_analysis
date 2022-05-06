%get r/p between pcorrect, previous pcorrect and change in pcorrect
part = 2;
trialmatrix_filename = [filedir 'Part' num2str(part) filename];
load(trialmatrix_filename);

% for row = 1:length(trialmatrix_clean)
%     if ~(row == 1)
%         if ~(trialmatrix_clean(row).flipNumber == 1)
%             trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - trialmatrix_clean(row-1).majPCorrect;
%         elseif trialmatrix_clean(row).flipNumber == 1
%             trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - 0.5;
%         end
%     elseif row ==1
%         trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - 0.5;
%     end
% end

pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
pcorrect_change = cell2mat({trialmatrix_clean.PCorrectChange})';
pcorrect_previous = vertcat(0.5, pcorrect(1:length(pcorrect)-1));
pcorrect_change_abs = abs(cell2mat({trialmatrix_clean.PCorrectChange})');

tbl = table(pcorrect,pcorrect_change, pcorrect_previous,'VariableNames',{'pCorrect', 'change in pCorrect','previous pCorrect'});
varnames = tbl.Properties.VariableNames;
figure;
R = corrplot(tbl,VarNames=varnames,TestR="on");
th = findall(gca, 'type', 'text', 'String', '{\bf Correlation Matrix}'); 
th.String = sprintf('Participant2: pcorrect, change in pcorrect and pcorrect in previous trial \n Correlation matrix');
saveas(gca,'C:\Github\IST_EEG_analysis\Regression_results\Images\Scatterplots_pcorrect_pcorrectchange_previousPcorrect\scatterplots_pcorrect.jpg');

tbl_abs = table(pcorrect,pcorrect_change_abs, pcorrect_previous,'VariableNames',{'pCorrect', 'absolute change in pCorrect','previous pCorrect'});
varnames = tbl_abs.Properties.VariableNames;
figure;title('Participant2: pcorrect,pcorrect in previous trial and absolute change in pcorrect')
R_abs = corrplot(tbl_abs,VarNames=varnames,TestR="on");
th = findall(gca, 'type', 'text', 'String', '{\bf Correlation Matrix}'); 
th.String = sprintf('Participant2: pcorrect, absolute change in pcorrect and pcorrect in previous trial \n Correlation matrix');

saveas(gca,'C:\Github\IST_EEG_analysis\Regression_results\Images\Scatterplots_pcorrect_pcorrectchange_previousPcorrect\scatterplots_pcorrect_abs.jpg');

tbl_all = table(pcorrect,pcorrect_change,pcorrect_change_abs, pcorrect_previous,'VariableNames',{'pCorrect', 'change in pCorrect','absolute change in pCorrect','previous pCorrect'});

vif = diag(inv(corrcoef(table2array(tbl_all))));