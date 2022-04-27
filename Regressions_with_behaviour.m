

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
save_filedir =  'C:\Github\IST_EEG_analysis\EEG_csv\';
for part = 1:22
        trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    
    for row = 1:length(trialmatrix_clean)
        if ~(row == 1)
            if ~(trialmatrix_clean(row).flipNumber == 1)
                trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - trialmatrix_clean(row-1).majPCorrect;
            end
        end
    end
    
    save_filename = [save_filedir 'Part' num2str(part) '_EEG_regression_weighted_STV.csv'];
    writetable(struct2table(trialmatrix_clean),save_filename);
    
    % for row = 1:length(trialmatrix_clean)
    %     if trialmatrix_clean(row).PCorrectChange > 0
    %         trialmatrix_clean(row).PCorrectChangeCat = 1;
    %     elseif trialmatrix_clean(row).PCorrectChange < 0
    %         trialmatrix_clean(row).PCorrectChangeCat = 2;
    %     elseif trialmatrix_clean(row).PCorrectChange == 0
    %         trialmatrix_clean(row).PCorrectChangeCat = 1;
    %     end
    % end
    
    pcorrect = zscore(cell2mat({trialmatrix_clean.majPCorrect})');
    pcorrect_change = {trialmatrix_clean.PCorrectChange};
    pcorrect_change(cellfun('isempty',pcorrect_change)) = {NaN};
    pcorrect_change= zscore(cell2mat(pcorrect_change)');
    RT = zscore(cell2mat({trialmatrix_clean.timeSinceLastFlip})');
    flipNumber = cell2mat({trialmatrix_clean.flipNumber})';
    answer = cell2mat({trialmatrix_clean.answer})';
    condition = {trialmatrix_clean.type}';
    amplitude = zscore(cell2mat({trialmatrix_clean.STV_regress_eeg_final})');
    Pz_amplitude = zscore(cell2mat({trialmatrix_clean.Pz_amplitude})');
    tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);
    
    %test for additional effect of choosing to answer
    participants(part).lm_answer = fitlm(tbl,'amplitude~pCorrect+answer');
    %test for additional effect of condition
    participants(part).lm_condition = fitlm(tbl,'amplitude~pCorrect+condition');
    %test for additional effect of pcorrectChange
    participants(part).lm_pcorrectchange = fitlm(tbl,'amplitude~pCorrect+pCorrectChange');
    %without pcorrect double-dipping?
    participants(part).lm_time_pcorrectchange = fitlm(tbl,'amplitude~flipNumber+pCorrectChange');
    %plot(lm5)
    %test for effect of time,change in evidence and condition
    participants(part).lm_time_evidence_condition = fitlm(tbl,'amplitude~flipNumber+pCorrectChange+condition');
    %test for effect of time,evidence change including pcorrect
    participants(part).lm_time_evidence_pcorrect = fitlm(tbl,'amplitude~flipNumber+pCorrectChange+pCorrect');
    %with interaction terms
    participants(part).lm_time_condition_interaction = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'flipNumber', 'condition'},'CategoricalVars','condition');
    participants(part).lm_time_pcorrectchange_interaction = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'pCorrectChange'});
    
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