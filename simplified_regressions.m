%run regression with only variables you want

 %standardised values
    pred1 = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect = zscore(cell2mat({trialmatrix_clean.majPCorrect})');
    pcorrect_change = zscore(cell2mat({trialmatrix_clean.PCorrectChange})');
    pcorrect_previous = zscore(vertcat(0.5, pred1(2:end)));
    %RT = zscore(cell2mat({trialmatrix_clean.timeSinceLastFlip})');
    flipNumber = cell2mat({trialmatrix_clean.flipNumber})';
    answer = cell2mat({trialmatrix_clean.answer})';
    condition = {trialmatrix_clean.type}';
    amplitude = zscore(cell2mat({trialmatrix_clean.STV_regress_eeg_final})');
    Pz_amplitude = zscore(cell2mat({trialmatrix_clean.Pz_amplitude})');
    tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude','pCorrect_previous'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);

    participants(part).lm= fitlm(tbl,'amplitude~pCorrect+answer');
    %with interaction terms
    %effect of condition and if there is an interaction with interaction
    participants(part).lm_time_condition_interaction = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'condition'},'CategoricalVars','condition');