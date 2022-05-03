filedir = 'D:\Jasmine\EEG\IST\Electrode_regression\SingleTrialValue\';
filename = '_trialmatrix_EEG_regression_weighted_STV_final.mat';

cd C:\Github\IST_EEG_analysis\EEG

for part = 1:22
    %load data
    trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    
    %remove unnecessary fields
    trialmatrix_clean = rmfield(trialmatrix_clean, {'reconstruct_pcorrect_eeg_final','EEGdata','pcorrect_reg_regress_weights', 'reconstruct_pcorrect_reg', 'STV_reg_regress_electrodes', 'pcorrect_regress_weights', 'reconstruct_pcorrect', 'STV_regress_electrodes', 'pcorrect_regress_weights_eeg_alt'});
    save(['Part' num2str(part) '_trialmatrix_EEG_regression_weighted_STV_short.mat'], 'trialmatrix_clean', '-v7.3');
    
end

participants = struct;
filedir = 'C:\Github\IST_EEG_analysis\EEG\';
filename = '_trialmatrix_EEG_regression_weighted_STV_short.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\Regression_results\';

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
%     
%     save_filename = [save_filedir 'Part' num2str(part) '_EEG_regression_weighted_STV.csv'];
%     writetable(struct2table(trialmatrix_clean),save_filename);
%     
    % for row = 1:length(trialmatrix_clean)
    %     if trialmatrix_clean(row).PCorrectChange > 0
    %         trialmatrix_clean(row).PCorrectChangeCat = 1;
    %     elseif trialmatrix_clean(row).PCorrectChange < 0
    %         trialmatrix_clean(row).PCorrectChangeCat = 2;
    %     elseif trialmatrix_clean(row).PCorrectChange == 0
    %         trialmatrix_clean(row).PCorrectChangeCat = 1;
    %     end
    % end
    %standardised values
    pcorrect_raw = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect = zscore(cell2mat({trialmatrix_clean.majPCorrect})');
    pcorrect_change = zscore(cell2mat({trialmatrix_clean.PCorrectChange})');
    pcorrect_previous = zscore(vertcat(0.5, pcorrect_raw(2:end)));
    %RT = zscore(cell2mat({trialmatrix_clean.timeSinceLastFlip})');
    flipNumber = cell2mat({trialmatrix_clean.flipNumber})';
    answer = cell2mat({trialmatrix_clean.answer})';
    condition = {trialmatrix_clean.type}';
    amplitude = zscore(cell2mat({trialmatrix_clean.STV_regress_eeg_final})');
    Pz_amplitude = zscore(cell2mat({trialmatrix_clean.Pz_amplitude})');
    tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude','pCorrect_previous'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);
    
    %test for additional effect of choosing to answer
    participants(part).lm_answer = fitlm(tbl,'amplitude~pCorrect+answer');
    %test for additional effect of condition
    participants(part).lm_condition = fitlm(tbl,'amplitude~pCorrect+condition');
    %test for additional effect of pcorrectChange
    participants(part).lm_pcorrectchange = fitlm(tbl,'amplitude~pCorrect+pCorrectChange');
    %with interaction terms
    %effect of condition and if there is an interaction with interaction
    participants(part).lm_time_condition_interaction = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'condition'},'CategoricalVars','condition');
    participants(part).lm_time_pcorrectchange_interaction = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'pCorrectChange'});
    
    %unstandardised
    pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_clean.PCorrectChange})';
    pcorrect_previous = vertcat(0.5, pcorrect(2:end));
    %RT = cell2mat({trialmatrix_clean.timeSinceLastFlip})';
    flipNumber = cell2mat({trialmatrix_clean.flipNumber})';
    answer = cell2mat({trialmatrix_clean.answer})';
    condition = {trialmatrix_clean.type}';
    amplitude = cell2mat({trialmatrix_clean.STV_regress_eeg_final})';
    Pz_amplitude = cell2mat({trialmatrix_clean.Pz_amplitude})';
    tbl2 = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude','pCorrect_previous'});
    %test for effect of context, change and interaction - how certain you
    %were based on the context and how much the evidence changes
        participants(part).lm_pcorrect_pcorrectchange_interaction_unstandardised = fitlm(tbl2,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect_previous', 'pCorrectChange'});
    participants(part).lm_time_condition_interaction_unstandardised = fitlm(tbl2,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'condition'},'CategoricalVars','condition');

end

    save([save_filedir 'regression_results.mat'], 'participants', '-v7.3');


gscatter(tbl2.amplitude,tbl2.pCorrect,tbl2.answer)
hold on
xlabel('Correlation weighted average amplitude')
ylabel('PCorrect')

gscatter(tbl.amplitude,tbl.pCorrect,tbl.condition,'bm', '.', 18)
hold on
xlabel('Correlation weighted average amplitude')
ylabel('PCorrect')