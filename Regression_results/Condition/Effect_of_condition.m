participants = struct;
filedir = 'C:\Github\IST_EEG_analysis\EEG\';
filename = '_trialmatrix_EEG_regression_weighted_STV_short.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\Regression_results\Condition\';

for part = 1:22
        trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    
    for row = 1:length(trialmatrix_clean)
        if ~(row == 1)
            if ~(trialmatrix_clean(row).flipNumber == 1)
                trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - trialmatrix_clean(row-1).majPCorrect;
            elseif trialmatrix_clean(row).flipNumber == 1
                trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - 0.5;
            end
        elseif row ==1
            trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - 0.5;
        end
    end
    
    save_filename = ['C:\Github\IST_EEG_analysis\EEG\Updated\Part' num2str(part) '_EEG_regression_weighted_STV.mat'];
     save(save_filename, 'trialmatrix_clean', '-v7.3');

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
    participants(part).lm= fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'condition'},'CategoricalVars','condition');
    
    
end

    save([save_filedir 'condition_regression_results.mat'], 'participants', '-v7.3');
