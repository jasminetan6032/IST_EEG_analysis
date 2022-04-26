

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
    save_filedir =  'C:\Github\IST_EEG_analysis\EEG_csv\';
    save_filename = [save_filedir 'Part' num2str(part) '_EEG_regression_weighted_STV.csv'];
    writetable(struct2table(trialmatrix_clean),save_filename);
end

for row = 1:length(trialmatrix_clean)
    if ~(row == 1)
        if ~(trialmatrix_clean(row).flipNumber == 1)
            trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - trialmatrix_clean(row-1).majPCorrect;
        end
    end
end

for row = 1:length(trialmatrix_clean)
    if trialmatrix_clean(row).PCorrectChange > 0
        trialmatrix_clean(row).PCorrectChangeCat = 1;
    elseif trialmatrix_clean(row).PCorrectChange < 0
        trialmatrix_clean(row).PCorrectChangeCat = 2;
    elseif trialmatrix_clean(row).PCorrectChange == 0
        trialmatrix_clean(row).PCorrectChangeCat = 1;
    end
end

pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect_change = {trialmatrix_clean.PCorrectChange};
    pcorrect_change(cellfun('isempty',pcorrect_change)) = {NaN};
    pcorrect_change= cell2mat(pcorrect_change)';
RT = cell2mat({trialmatrix_clean.timeSinceLastFlip})';
flipNumber = cell2mat({trialmatrix_clean.flipNumber})';
condition = {trialmatrix_clean.type}';
amplitude = cell2mat({trialmatrix_clean.STV_regress_eeg_final})';
tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber'});
tbl.condition = categorical(tbl.condition);
tbl.answer = categorical(tbl.answer);
%with interaction term
lm = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'flipNumber', 'condition'},'CategoricalVars','condition');
lm = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'pCorrectChange'});
%without interaction
lm2 = fitlm(tbl,'amplitude~pCorrect+condition');
lm = fitlm(tbl,'amplitude~pCorrect+pCorrectChange');

answer = cell2mat({trialmatrix_clean.answer})';
tbl2 = table(pcorrect,answer,amplitude,'VariableNames',{'pCorrect', 'answer','amplitude'});
tbl2.answer = categorical(tbl2.answer);
lm4 = fitlm(tbl2,'amplitude~pCorrect+answer');
lm3 = fitlm(tbl,'amplitude~flipNumber+pCorrectChange+condition');
lm5 = fitlm(tbl,'amplitude~flipNumber+pCorrectChange');
plot(lm5)
pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
condition = {trialmatrix_clean.type}';
amplitude = cell2mat({trialmatrix_clean.Pz_amplitude})';
tbl = table(pcorrect,condition,amplitude,'VariableNames',{'pCorrect', 'condition','amplitude'});
tbl.condition = categorical(tbl.condition);
lm4 = fitlm(tbl,'amplitude~pCorrect+condition');

answer = cell2mat({trialmatrix_clean.answer})';
tbl2 = table(pcorrect,answer,amplitude,'VariableNames',{'pCorrect', 'answer','amplitude'});
tbl2.answer = categorical(tbl2.answer);
lm5 = fitlm(tbl2,'amplitude~pCorrect+answer');
plot(lm5)

gscatter(tbl2.amplitude,tbl2.pCorrect,tbl2.answer)
hold on
xlabel('Correlation weighted average amplitude')
ylabel('PCorrect')

gscatter(tbl.amplitude,tbl.pCorrect,tbl.condition,'bm', '.', 18)
hold on
xlabel('Correlation weighted average amplitude')
ylabel('PCorrect')