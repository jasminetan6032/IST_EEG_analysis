    %select trials with confidence
    confidence = {trialmatrix_sig.Cjsample}';
with_Cjsample = find(~cellfun(@isempty,confidence));
trialmatrix_select = trialmatrix_sig(with_Cjsample);

 pcorrect = cell2mat({trialmatrix_select.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_select.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_select.previousPCorrect})';
    %RT = zscore(cell2mat({trialmatrix_clean.timeSinceLastFlip})');
    flipNumber = cell2mat({trialmatrix_select.flipNumber})';
    answer = cell2mat({trialmatrix_select.answer})';
    condition = {trialmatrix_select.type}';
    confidence = cell2mat({trialmatrix_select.Cjsample})';
    amplitude = cell2mat({trialmatrix_select.STV_regress_eeg_final})';
    Pz_amplitude = cell2mat({trialmatrix_select.Pz_amplitude})';
    tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,confidence,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude','pCorrect_previous','confidence'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);
    
    %with interaction terms
    %effect of condition and if there is an interaction with interaction
    lm_sig_conf= fitlm(tbl,'interactions','ResponseVar','confidence','PredictorVars',{'pCorrect', 'answer'},'CategoricalVars','answer');

    save_filedir = 'C:\Github\IST_EEG_analysis\Regression_results\Answer\By_behaviour\';

%plot interaction with scatter plots
w = linspace(min(tbl.pCorrect),max(tbl.pCorrect));

figure()
gscatter(tbl.pCorrect,tbl.confidence,tbl.answer,'br','xo')
line(w,feval(lm_sig_conf,w,'0'),'Color','b','LineWidth',2)
line(w,feval(lm_sig_conf,w,'1'),'Color','r','LineWidth',2)
title('Fitted Regression Lines by decisionPoint')
savefilename = [save_filedir 'sig_participants_regression_answer_conf.jpg'];
saveas(gca,savefilename);


    %select trials with confidence
    confidence = {trialmatrix_nonsig.Cjsample}';
with_Cjsample = find(~cellfun(@isempty,confidence));
trialmatrix_select = trialmatrix_nonsig(with_Cjsample);

 pcorrect = cell2mat({trialmatrix_select.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_select.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_select.previousPCorrect})';
    %RT = zscore(cell2mat({trialmatrix_clean.timeSinceLastFlip})');
    flipNumber = cell2mat({trialmatrix_select.flipNumber})';
    answer = cell2mat({trialmatrix_select.answer})';
    condition = {trialmatrix_select.type}';
    confidence = cell2mat({trialmatrix_select.Cjsample})';
    amplitude = cell2mat({trialmatrix_select.STV_regress_eeg_final})';
    Pz_amplitude = cell2mat({trialmatrix_select.Pz_amplitude})';
    tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,confidence,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude','pCorrect_previous','confidence'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);
    
    %with interaction terms
    %effect of condition and if there is an interaction with interaction
    lm_nonsig_conf= fitlm(tbl,'interactions','ResponseVar','confidence','PredictorVars',{'pCorrect', 'answer'},'CategoricalVars','answer');

    save_filedir = 'C:\Github\IST_EEG_analysis\Regression_results\Answer\By_behaviour\';

%plot interaction with scatter plots
w = linspace(min(tbl.pCorrect),max(tbl.pCorrect));

figure()
gscatter(tbl.pCorrect,tbl.confidence,tbl.answer,'br','xo')
line(w,feval(lm_nonsig_conf,w,'0'),'Color','b','LineWidth',2)
line(w,feval(lm_nonsig_conf,w,'1'),'Color','r','LineWidth',2)
title('Fitted Regression Lines by decisionPoint')
savefilename = [save_filedir 'nonsig_participants_regression_answer_conf.jpg'];
saveas(gca,savefilename);