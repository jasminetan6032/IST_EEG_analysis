%get_quantiles

%get fixed quantiles
participants = struct;
filedir = 'C:\Github\IST_EEG_analysis\EEG\Updated\';
filename = '_EEG_regression_weighted_STV.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\Regression_results\PCorrectChange_Previous_PCorrect\Quantiles\';

for part = 1:22
        trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);

    pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_clean.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_clean.previousPCorrect})';
    
pcorrect_unique = unique(pcorrect);
Qu2 = quantile(pcorrect_unique,4);
pcorrect_change_unique = unique(pcorrect_change);
Qu_change = quantile(pcorrect_change_unique,4);
pcorrect_previous_unique = unique(pcorrect_previous);
Qu2_previous = quantile(pcorrect_previous_unique,2);

%get individualised bins
    pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_clean.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_clean.previousPCorrect})';

Q = quantile(pcorrect,4);

Q_change = quantile(pcorrect_change,4);

Q_previous = quantile(pcorrect_previous,2);

%classify based on pcorrectchange quantile and pcorrect context quantile
for row = 1:length(trialmatrix_clean)
    x = trialmatrix_clean(row).PCorrectChange;
    if x <= Q_change(1) 
        trialmatrix_clean(row).ChangeBin = 1;
    elseif x > Q_change(1) && x <= Q_change(2) 
        trialmatrix_clean(row).ChangeBin = 2;
    elseif x > Q_change(2) && x <= Q_change(3)
        trialmatrix_clean(row).ChangeBin = 3;
    elseif x > Q_change(3) && x <= Q_change(4)
        trialmatrix_clean(row).ChangeBin = 4;
    elseif x > Q_change(4)
        trialmatrix_clean(row).ChangeBin = 5;
    end
end 
%average STV and save in participants struct


end

%plot
