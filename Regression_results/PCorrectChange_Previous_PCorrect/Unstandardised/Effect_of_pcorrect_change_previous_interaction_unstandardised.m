participants = struct;
filedir = 'C:\Github\IST_EEG_analysis\EEG\Updated\';
filename = '_EEG_regression_weighted_STV.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\Regression_results\PCorrectChange_Previous_PCorrect\Unstandardised\Fixed\';

for part = 1:22
        trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);

    %unstandardised values
    pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_clean.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_clean.previousPCorrect})';
    %RT = zscore(cell2mat({trialmatrix_clean.timeSinceLastFlip})');
    flipNumber = cell2mat({trialmatrix_clean.flipNumber})';
    answer = cell2mat({trialmatrix_clean.answer})';
    condition = {trialmatrix_clean.type}';
    amplitude = cell2mat({trialmatrix_clean.STV_regress_eeg_final})';
    Pz_amplitude = cell2mat({trialmatrix_clean.Pz_amplitude})';
    tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude','previous pCorrect'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);
    
    %with interaction terms
    %effect of condition and if there is an interaction with interaction
    participants(part).lm= fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrectChange', 'previous pCorrect'});
    
    
end

    save([save_filedir 'pcorrect_change_previous_interaction_unstandardised_regression_results.mat'], 'participants', '-v7.3');
    
    figname = [save_filedir 'pcorrect_change_interaction_betas.png'];
outputname = [save_filedir 'pcorrect_change_interaction_results.mat'];
output = ttest_betas(participants,figname,outputname,4);

%for exploring interactions
figure;
plotInteraction(participants(20).lm, 'previous pCorrect','pCorrectChange','predictions') %first variable indicates the line categories 
th = findall(gca, 'type', 'text', 'String', 'Interaction of previous pCorrect and pCorrectChange'); 
th.String = sprintf('Participant20: Non-significant interaction of context and change in pCorrect');
savefilename = [save_filedir 'Part2_pcorrectchange_previous_nonsig_interaction.jpg'];
saveas(gca,savefilename);
