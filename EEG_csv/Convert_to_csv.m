filedir = 'C:\Github\IST_EEG_analysis\EEG\Updated\';
filename = '_EEG_regression_weighted_STV.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\EEG_csv\';

for part = 1:22
trialmatrix_filename = [filedir 'Part' num2str(part) filename];
load(trialmatrix_filename);
save_filename = [save_filedir 'Part' num2str(part) '_EEG_regression_weighted_STV_fixed.csv'];
writetable(struct2table(trialmatrix_clean),save_filename);
end 
