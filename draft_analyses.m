%plot histograms of reaction times by condition

%plot ERPs (Pz and weighted average EEG) for high and low pcorrect by condition

%Sensitivity to information inherent in flip is modulated by confidence
%(only confidence trials)


%Sensitivity to information provided by flip (strength of the P300-like
%activity) is modulated by the current available evidence

%what's the individual's average pcorrect threshold for fixed and
%decreasing win conditions?

%distinguish neural activity related to accumulating evidence for correct colour and other colour

%what happens in the long period where pcorrect stays the same? How does
%amplitude vary while pcorrect stays flat? People are calibrating
%confidence? Being extra sure? Still gathering evidence? Haven't picked up
%that there is already a clear answer?

%plot STV over flips (but how to account for different lengths of trials?)

%plot pcorrect and pcorrect change
figure;subplot(2,1,1);scatter(pcorrect,pcorrect_change)
title('Scatterplots for pcorrect,pcorrect in previous trial and change in pcorrect')
hold on
xlabel('PCorrect')
ylabel('Change in PCorrect')
subplot(2,1,2);scatter(pcorrect_previous,pcorrect_change)
hold on
xlabel('PCorrect on previous trial')
ylabel('Change in PCorrect')


%majority and minority still having a role to play at marking the two
%different options you are accumulating evidence for. 

    %test for effect of time,change in evidence and condition
    participants(part).lm_time_evidence_condition = fitlm(tbl,'amplitude~flipNumber+pCorrectChange+condition');
    %test for effect of time,evidence change including pcorrect
    participants(part).lm_time_evidence_pcorrect = fitlm(tbl,'amplitude~flipNumber+pCorrectChange+pCorrect');

    image_filedir =  'C:\Github\IST_EEG_analysis\Regression_results\Images\';

%extract beta estimates and run second order statistics comparing them to 0
for part = 1:22
answer_beta(part,1) = table2cell(participants(part).lm_answer.Coefficients(3,1));
%answer_beta(part,2) = table2cell(participants(part).lm_answer.Coefficients(3,4));
condition_beta(part,1) = table2cell(participants(part).lm_condition.Coefficients(3,1));
pcorrect_change_beta(part,1) = table2cell(participants(part).lm_pcorrectchange.Coefficients(3,1));
time_condition_interaction_beta(part,1) = table2cell(participants(part).lm_time_condition_interaction.Coefficients(4,1));
time_pcorrectchange_interaction_beta(part,1) = table2cell(participants(part).lm_time_pcorrectchange_interaction.Coefficients(4,1));
pcorrect_pcorrectchange_beta(part,1) = table2cell(participants(part).lm_pcorrect_pcorrectchange_interaction_unstandardised.Coefficients(3,1));
pcorrect_pcorrectchange_interaction_beta(part,1) = table2cell(participants(part).lm_pcorrect_pcorrectchange_interaction_unstandardised.Coefficients(4,1));
time_condition_unstandardised_interaction_beta(part,1) = table2cell(participants(part).lm_time_condition_interaction_unstandardised.Coefficients(4,1));
time_condition_unstandardised_beta(part,1) = table2cell(participants(part).lm_time_condition_interaction_unstandardised.Coefficients(3,1));
pcorrect_pcorrectchange1_beta(part,1) = table2cell(participants(part).lm_pcorrect_pcorrectchange_interaction_unstandardised.Coefficients(2,1));

end

[h,p,ci,stats] = ttest(cell2mat(answer_beta));
histogram(cell2mat(answer_beta),15);

    fignamesave =  [image_filedir 'betas_answer.png'];
    saveas(gca, fignamesave);

    [h,p,ci,stats] = ttest(cell2mat(pcorrect_pcorrectchange_beta));
histogram(cell2mat(pcorrect_pcorrectchange_beta),15);

    fignamesave =  [image_filedir 'betas_pcorrect_previous.png'];
    saveas(gca, fignamesave);

        [h,p,ci,stats] = ttest(cell2mat(pcorrect_pcorrectchange_interaction_beta));
histogram(cell2mat(pcorrect_pcorrectchange_interaction_beta),15);

    fignamesave =  [image_filedir 'betas_pcorrect_previous_interaction.png'];
    saveas(gca, fignamesave);

            [h,p,ci,stats] = ttest(cell2mat(condition_beta));
histogram(cell2mat(condition_beta),15);

    fignamesave =  [image_filedir 'betas_condition.png'];
    saveas(gca, fignamesave);

                [h,p,ci,stats] = ttest(cell2mat(time_condition_unstandardised_beta));
histogram(cell2mat(time_condition_unstandardised_beta),15);

    fignamesave =  [image_filedir 'betas_condition_time_unstandardised.png'];
    saveas(gca, fignamesave);

                [h,p,ci,stats] = ttest(cell2mat(pcorrect_change_beta));
histogram(cell2mat(pcorrect_change_beta),15);

    fignamesave =  [image_filedir 'betas_pcorrect_change.png'];
    saveas(gca, fignamesave);

                    [h,p,ci,stats] = ttest(cell2mat(time_pcorrectchange_interaction_beta));
histogram(cell2mat(time_pcorrectchange_interaction_beta),15);

    fignamesave =  [image_filedir 'betas_pcorrect_pcorrect_change_interaction.png'];
    saveas(gca, fignamesave);
    
    [h,p,ci,stats] = ttest(cell2mat(pcorrect_pcorrectchange1_beta));
histogram(cell2mat(pcorrect_pcorrectchange1_beta),15);
%run collinearity diagnostics on pcorrect and confidence
participants = struct;
filedir = 'C:\Github\IST_EEG_analysis\EEG\';
filename = '_trialmatrix_EEG_regression_weighted_STV_short.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\';

for part = 1:22
        trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    
    events = {trialmatrix_clean.Cjsample};
    events(cellfun('isempty',events)) = {[0]};
    events= cell2mat(events);
    all_events = find(events > 0);
    select = trialmatrix_clean(all_events);
pcorrect = cell2mat({select.majPCorrect})';
confidence = cell2mat({select.Cjsample})';
tbl = table(pcorrect,confidence,'VariableNames',{'pCorrect', 'confidence'});
participants(part).vif = diag(inv(corrcoef(pcorrect,confidence)));
% [sValue,condIdx,VarDecomp] = collintest(tbl);
% participants(part).sValue = sValue;
% participants(part).condIdx = condIdx;
% participants(part).VarDecomp = VarDecomp;
figure
participants(part).R = corrplot(tbl,TestR="on");


end 

save([save_filedir 'pcorrect_confidence_collinearity_test_results.mat'], 'participants', '-v7.3');

%I feel like since the vifs are all under 5, I can probably use this to run the model comparing pcorrect and  