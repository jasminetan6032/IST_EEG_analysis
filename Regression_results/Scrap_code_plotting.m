confidence = {trialmatrix_clean.Cjsample}';
with_Cjsample = find(~cellfun(@isempty,confidence));
trialmatrix_select = trialmatrix_clean(with_Cjsample);

    pcorrect = cell2mat({trialmatrix_select.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_select.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_select.previousPCorrect})';
        flipNumber = cell2mat({trialmatrix_select.flipNumber})';
    answer = cell2mat({trialmatrix_select.answer})';
    condition = {trialmatrix_select.type}';
    amplitude = cell2mat({trialmatrix_select.STV_regress_eeg_final})';
    Pz_amplitude = cell2mat({trialmatrix_select.Pz_amplitude})';
    tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude','pCorrect_previous'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);
    
        participants(part).lm= fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'condition'},'CategoricalVars','condition');

        
        
%plot interaction with scatter plots
w = linspace(min(tbl.pCorrect),max(tbl.pCorrect));
fit = fitlm(tbl,'interactions','ResponseVar','confidence','PredictorVars',{'pCorrect', 'condition'},'CategoricalVars','condition');

figure()
gscatter(tbl.pCorrect,tbl.confidence,tbl.condition,'br','xo')
line(w,feval(fit,w,'decreasing'),'Color','b','LineWidth',2)
line(w,feval(fit,w,'fixed'),'Color','r','LineWidth',2)
title('Fitted Regression Lines by Condition')
savefilename = [save_filedir 'Part12_condition_sig_interaction.jpg'];
saveas(gca,savefilename);

pcorrect1 = cell2mat({trialmatrix_clean.majPCorrect})';
ix=cellfun(@isempty,confidence);
confidence(ix)={nan};
confidence = cell2mat(confidence);
comb = cat(2,pcorrect1,confidence);

variableNumber = 3;

for part = 1:length(participants)
    lm_beta(part,1) = table2cell(participants(part).lm.Coefficients(variableNumber,1));
    lm_beta(part,2) = table2cell(participants(part).lm.Coefficients(variableNumber,4));
end

save_filedir = 'C:\Github\IST_EEG_analysis\Regression_results\Answer\By_behaviour';
%for exploring interactions
figure;
plotInteraction(participants(15).lm, 'answer','pCorrect','predictions') %first variable indicates the line categories 
th = findall(gca, 'type', 'text', 'String', 'Interaction of answer and pCorrect'); 
th.String = sprintf('Participant15: Negative Significant interaction of answer and pCorrect');
savefilename = [save_filedir 'Part15_answer_sig_interaction.jpg'];
saveas(gca,savefilename);
