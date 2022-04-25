
   %load data
    trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename)

%remove unnecessary fields
    trialmatrix_clean = rmfield(trialmatrix_clean, 'reconstruct_pcorrect_eeg_final');
    trialmatrix_clean = rmfield(trialmatrix_clean, {'pcorrect_reg_regress_weights', 'reconstruct_pcorrect_reg', 'STV_reg_regress_electrodes', 'pcorrect_regress_weights', 'reconstruct_pcorrect', 'STV_regress_electrodes', 'pcorrect_regress_weights_eeg_alt'});
trialmatrix_clean = rmfield(trialmatrix_clean, 'EEGdata');

        
%remove noisy epochs
        noisy = [trialmatrix.noisy];
        clean_data = noisy == 0;
        trialmatrix_clean = trialmatrix(clean_data);

pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
condition = {trialmatrix_clean.type}';
amplitude = cell2mat({trialmatrix_clean.STV_regress_eeg_final})';
tbl = table(pcorrect,condition,amplitude,'VariableNames',{'pCorrect', 'condition','amplitude'});
tbl.condition = categorical(tbl.condition);
%with interaction term
lm = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'condition'},'CategoricalVars','condition'); 
%without interaction
lm2 = fitlm(tbl,'amplitude~pCorrect+condition');

answer = cell2mat({trialmatrix_clean.answer})';
tbl2 = table(pcorrect,answer,amplitude,'VariableNames',{'pCorrect', 'answer','amplitude'});
tbl2.answer = categorical(tbl2.answer);
lm3 = fitlm(tbl2,'amplitude~pCorrect+answer');

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

gscatter(tbl2.amplitude,tbl2.pCorrect,tbl2.answer)
hold on
xlabel('Correlation weighted average amplitude')
ylabel('PCorrect')

gscatter(tbl.amplitude,tbl.pCorrect,tbl.condition,'bm', '.', 18)
hold on
xlabel('Correlation weighted average amplitude')
ylabel('PCorrect')