%get_quantiles

%get fixed quantiles
load('C:\Github\IST_EEG_analysis\EEG\Updated\Part2_EEG_regression_weighted_STV.mat')
    pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_clean.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_clean.previousPCorrect})';
pcorrect_unique = unique(pcorrect);
Qu = quantile(pcorrect_unique,4);
pcorrect_change_unique = unique(pcorrect_change);
Qu_change = quantile(pcorrect_change_unique,4);
pcorrect_previous_unique = unique(pcorrect_previous);
Qu_previous = quantile(pcorrect_previous_unique,2);

%get individualised bins
    pcorrect = cell2mat({trialmatrix_clean.majPCorrect})';
    pcorrect_change = cell2mat({trialmatrix_clean.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_clean.previousPCorrect})';

Q = quantile(pcorrect,4);

Q_change = quantile(pcorrect_change,4);

Q_previous = quantile(pcorrect_previous,2);

%classify based on pcorrectchange quantile and pcorrect context quantile

%average STV

%plot
