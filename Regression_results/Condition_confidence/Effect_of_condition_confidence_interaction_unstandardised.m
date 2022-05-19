participants = struct;
filedir = 'C:\Github\IST_EEG_analysis\EEG\Updated\';
filename = '_EEG_regression_weighted_STV.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\Regression_results\Condition_confidence\Unstandardised\';

for part = 1:22
        trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    
    %select trials with confidence
    confidence = {trialmatrix_clean.Cjsample}';
with_Cjsample = find(~cellfun(@isempty,confidence));
trialmatrix_select = trialmatrix_clean(with_Cjsample);

%remove outliers, i.e. high confidence at a lot pcorrect

    %unstandardised values
    pcorrect = cell2mat({trialmatrix_select.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_select.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_select.previousPCorrect})';
    %RT = zscore(cell2mat({trialmatrix_clean.timeSinceLastFlip})');
    flipNumber = cell2mat({trialmatrix_select.flipNumber})';
    answer = cell2mat({trialmatrix_select.answer})';
    condition = {trialmatrix_select.type}';
    confidence = cell2mat({trialmatrix_select.Cjsample})';
    amplitude = cell2mat({trialmatrix_select.STV_regress_eeg_final})';
    Pz_amplitude = cell2mat({trialmatrix_select.Pz_amplitude})';
    tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,confidence,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude','pCorrect_previous','confidence'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);
    
    %with interaction terms
    %effect of condition and if there is an interaction with interaction
    participants(part).lm= fitlm(tbl,'interactions','ResponseVar','confidence','PredictorVars',{'pCorrect', 'condition'},'CategoricalVars','condition');
    %participants(part).lm = fitlm(tbl,'amplitude~pCorrect+answer');
    
end

    save([save_filedir 'condition_regression_results.mat'], 'participants', '-v7.3');
    
    figname = [save_filedir 'pcorrect_betas.png'];
outputname = [save_filedir 'pcorrect_results.mat'];
output = ttest_betas(participants,figname,outputname,2);

%for exploring interactions
figure;
plotInteraction(participants(14).lm, 'condition','pCorrect','predictions') %first variable indicates the line categories 
th = findall(gca, 'type', 'text', 'String', 'Interaction of condition and pCorrect'); 
th.String = sprintf('Participant14: Significant interaction of condition and pCorrect');
savefilename = [save_filedir 'Part14_condition_sig_interaction.jpg'];
saveas(gca,savefilename);
