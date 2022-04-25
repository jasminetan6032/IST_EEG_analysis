
   %load data
    trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename)
        
%remove noisy epochs
        noisy = [trialmatrix.noisy];
        clean_data = noisy == 0;
        trialmatrix_clean = trialmatrix(clean_data);

pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
condition = {trialmatrix_clean.type}';
amplitude = cell2mat({trialmatrix_clean.regression_amplitude})';
tbl = table(pcorrect,condition,amplitude,'VariableNames',{'pCorrect', 'condition','amplitude'});
tbl.condition = categorical(tbl.condition);
%with interaction term
lm = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'condition'},'CategoricalVars','condition'); 
%without interaction
lm2 = fitlm(tbl,'amplitude~pCorrect+condition');

answer = cell2mat({trialmatrix_clean.answer})';
tbl2 = table(pcorrect,answer,amplitude,'VariableNames',{'pCorrect', 'answer','amplitude'});
tbl2.answer = categorical(tbl2.answer);
lm2 = fitlm(tbl2,'amplitude~pCorrect+answer');

pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
condition = {trialmatrix_clean.type}';
amplitude = cell2mat({trialmatrix_clean.Pz_amplitude})';
tbl = table(pcorrect,condition,amplitude,'VariableNames',{'pCorrect', 'condition','amplitude'});
tbl.condition = categorical(tbl.condition);
lm3 = fitlm(tbl,'amplitude~pCorrect+condition');

answer = cell2mat({trialmatrix_clean.answer})';
tbl2 = table(pcorrect,answer,amplitude,'VariableNames',{'pCorrect', 'answer','amplitude'});
tbl2.answer = categorical(tbl2.answer);
lm4 = fitlm(tbl2,'amplitude~pCorrect+answer');

gscatter(tbl2.amplitude,tbl2.pCorrect,tbl2.answer)
hold on
xlabel('Correlation weighted average amplitude')
ylabel('PCorrect')

gscatter(tbl.amplitude,tbl.pCorrect,tbl.condition,'bm', '.', 18)
hold on
xlabel('Correlation weighted average amplitude')
ylabel('PCorrect')