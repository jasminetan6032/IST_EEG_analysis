participants = struct;
filedir = 'C:\Github\IST_EEG_analysis\EEG\Updated\';
filename = '_EEG_regression_weighted_STV.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\Regression_results\Answer\By_behaviour\';

for part = 1:22
        trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    
    %select trials with confidence
    confidence = {trialmatrix_clean.Cjsample}';
with_Cjsample = find(~cellfun(@isempty,confidence));
trialmatrix_select = trialmatrix_clean(with_Cjsample);

%remove outliers, i.e. high confidence at a lot pcorrect

    %unstandardised values
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
    participants(part).lm= fitlm(tbl,'interactions','ResponseVar','confidence','PredictorVars',{'pCorrect', 'answer'},'CategoricalVars','answer');
    %participants(part).lm = fitlm(tbl,'amplitude~pCorrect+answer');
    
end

    save([save_filedir 'answer_regression_results.mat'], 'participants', '-v7.3');
    
    figname = [save_filedir 'answer_interaction_betas.png'];
outputname = [save_filedir 'answer_interaction_results.mat'];
output = ttest_betas(participants,figname,outputname,4);

% %for exploring interactions
% figure;
% plotInteraction(participants(14).lm, 'condition','pCorrect','predictions') %first variable indicates the line categories 
% th = findall(gca, 'type', 'text', 'String', 'Interaction of condition and pCorrect'); 
% th.String = sprintf('Participant14: Significant interaction of condition and pCorrect');
% savefilename = [save_filedir 'Part14_condition_sig_interaction.jpg'];
% saveas(gca,savefilename);

variableNumber = 4;

for part = 1:length(participants)
    lm_beta(part,1) = table2cell(participants(part).lm.Coefficients(variableNumber,1));
    lm_beta(part,2) = table2cell(participants(part).lm.Coefficients(variableNumber,4));
end

%get groups 
sig_group = find(cell2mat(lm_beta(:,1))>0);
nonsig_group = find(cell2mat(lm_beta(:,1))<0);

sig_participants = participants(sig_group);
nonsig_participants = participants(nonsig_group);
save_filedir = 'C:\Github\IST_EEG_analysis\Regression_results\Answer\By_behaviour';
    figname = [save_filedir 'sig_group_answer_interaction_betas.png'];
outputname = [save_filedir 'sig_group_answer_interaction_results.mat'];
output_sig = ttest_betas(sig_participants,figname,outputname,4);

    figname = [save_filedir 'nonsig_group_answer_interaction_betas.png'];
outputname = [save_filedir 'nonsig_group_answer_interaction_results.mat'];
output_nonsig = ttest_betas(nonsig_participants,figname,outputname,4);

variableNumber = 4;

for part = 1:length(participants)
    lm_STV(part,1) = table2cell(participants(part).lm.Coefficients(variableNumber,1));
    lm_STV(part,2) = table2cell(participants(part).lm.Coefficients(variableNumber,4));
end


trialmatrix_sig = [];
%collate groups 
for part = 1:length(sig_group)
    
        trialmatrix_filename = [filedir 'Part' num2str(sig_group(part)) filename];
    load(trialmatrix_filename);
    participant = trialmatrix_clean;
    trialmatrix_sig = [trialmatrix_sig participant];
end 
    %unstandardised values
    pcorrect = cell2mat({trialmatrix_sig.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_sig.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_sig.previousPCorrect})';
    %RT = zscore(cell2mat({trialmatrix_clean.timeSinceLastFlip})');
    flipNumber = cell2mat({trialmatrix_sig.flipNumber})';
    answer = cell2mat({trialmatrix_sig.answer})';
    condition = {trialmatrix_sig.type}';
    confidence = cell2mat({trialmatrix_sig.Cjsample})';
    amplitude = cell2mat({trialmatrix_sig.STV_regress_eeg_final})';
    Pz_amplitude = cell2mat({trialmatrix_sig.Pz_amplitude})';
    tbl = table(pcorrect,pcorrect_change,condition,amplitude,answer,flipNumber,Pz_amplitude,pcorrect_previous,'VariableNames',{'pCorrect', 'pCorrectChange','condition','amplitude','answer','flipNumber','Pz_amplitude','pCorrect_previous'});
    tbl.condition = categorical(tbl.condition);
    tbl.answer = categorical(tbl.answer);
lm_sig = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'answer'},'CategoricalVars','answer');

trialmatrix_nonsig = [];

for part = 1:length(nonsig_group)
    
        trialmatrix_filename = [filedir 'Part' num2str(nonsig_group(part)) filename];
    load(trialmatrix_filename);
    participant = trialmatrix_clean;
    trialmatrix_nonsig = [trialmatrix_nonsig participant];
end 

    %unstandardised values
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
    
    lm_nonsig = fitlm(tbl,'interactions','ResponseVar','confidence','PredictorVars',{'pCorrect', 'answer'},'CategoricalVars','answer');
