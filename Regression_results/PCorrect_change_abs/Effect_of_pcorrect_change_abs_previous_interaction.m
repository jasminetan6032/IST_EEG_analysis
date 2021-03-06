participants = struct;
filedir = 'C:\Github\IST_EEG_analysis\EEG\Updated\';
filename = '_EEG_regression_weighted_STV.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\Regression_results\PCorrect_change_abs\';

for part = 1:22
        trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);

    %standardised values
    pcorrect_raw = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect = zscore(cell2mat({trialmatrix_clean.majPCorrect})');
    pcorrect_change_abs = zscore(abs(cell2mat({trialmatrix_clean.PCorrectChange}))');
    pcorrect_previous = zscore(vertcat(0.5, pcorrect_raw(1:length(pcorrect_raw)-1)));
    %RT = zscore(cell2mat({trialmatrix_clean.timeSinceLastFlip})');
    flipNumber = cell2mat({trialmatrix_clean.flipNumber})';
    answer = cell2mat({trialmatrix_clean.answer})';
    condition = {trialmatrix_clean.type}';
    amplitude = zscore(cell2mat({trialmatrix_clean.STV_regress_eeg_final})');
    Pz_amplitude = zscore(cell2mat({trialmatrix_clean.Pz_amplitude})');
    tbl = table(pcorrect,pcorrect_change_abs,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,'VariableNames',{'pCorrect', 'pCorrectChangeAbs','condition','amplitude','answer','flipNumber','Pz_amplitude','pCorrect_previous'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);
    
    %with interaction terms
    %effect of condition and if there is an interaction with interaction
    participants(part).lm= fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrectChangeAbs', 'pCorrect_previous'});
    
    
end

    save([save_filedir 'pcorrect_change_abs_previous_interaction_regression_results.mat'], 'participants', '-v7.3');
    
    figname = [save_filedir 'pcorrect_previous_abs_betas.jpg'];
outputname = [save_filedir 'pcorrect_previous_abs_results.mat'];
output = ttest_betas(participants,figname,outputname,3);