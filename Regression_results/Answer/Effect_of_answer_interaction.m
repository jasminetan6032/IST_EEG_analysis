participants = struct;
filedir = 'C:\Github\IST_EEG_analysis\EEG\Updated\';
filename = '_EEG_regression_weighted_STV.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\Regression_results\Answer\';

for part = 1:22
        trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);

    %standardised values
    pcorrect_raw = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect = zscore(cell2mat({trialmatrix_clean.majPCorrect})');
    pcorrect_change = zscore(cell2mat({trialmatrix_clean.PCorrectChange})');
    pcorrect_previous = zscore(vertcat(0.5, pcorrect_raw(1:length(pcorrect_raw)-1)));
    %RT = zscore(cell2mat({trialmatrix_clean.timeSinceLastFlip})');
    flipNumber = cell2mat({trialmatrix_clean.flipNumber})';
    answer = cell2mat({trialmatrix_clean.answer})';
    condition = {trialmatrix_clean.type}';
    amplitude = zscore(cell2mat({trialmatrix_clean.STV_regress_eeg_final})');
    Pz_amplitude = zscore(cell2mat({trialmatrix_clean.Pz_amplitude})');
    tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude','pCorrect_previous'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);
    
    %with interaction terms
    %effect of condition and if there is an interaction with interaction
    participants(part).lm= fitlm(tbl,'interactions','ResponseVar','Pz_amplitude','PredictorVars',{'pCorrect', 'answer'},'CategoricalVars','answer');
    %participants(part).lm = fitlm(tbl,'Pz_amplitude~pCorrect+answer');
    
end

    save([save_filedir 'answer_Pz_regression_interaction_results.mat'], 'participants', '-v7.3');
    
    figname = [save_filedir 'answer_Pz_interaction_justAnswer_betas.png'];
outputname = [save_filedir 'answer_Pz_interaction_justAnswer_results.mat'];
output = ttest_betas(participants,figname,outputname,3);

%for exploring interactions
figure;
plotInteraction(participants(17).lm, 'answer','pCorrect','predictions') %first variable indicates the line categories 
th = findall(gca, 'type', 'text', 'String', 'Interaction of answer and pCorrect'); 
th.String = sprintf('Participant17: Significant interaction of answer and pCorrect');
saveas(gca,'C:\Github\IST_EEG_analysis\Regression_results\Answer\Part17_answer_pcorrect_sig_interaction.jpg');
