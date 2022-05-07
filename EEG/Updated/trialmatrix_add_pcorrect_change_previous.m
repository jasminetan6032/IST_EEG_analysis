
participants = struct;
filedir = 'C:\Github\IST_EEG_analysis\EEG\';
filename = '_trialmatrix_EEG_regression_weighted_STV_short.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\EEG\Updated\';

for part = 1:22
    trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    for row = 1:length(trialmatrix_clean)
        if ~(row == 1)
            if ~(trialmatrix_clean(row).flipNumber == 1)
                trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - trialmatrix_clean(row-1).majPCorrect;
                trialmatrix_clean(row).previousPCorrect = trialmatrix_clean(row-1).majPCorrect;
                
            elseif trialmatrix_clean(row).flipNumber == 1
                trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - 0.5;
                trialmatrix_clean(row).previousPCorrect = 0.5;
            end
        elseif row ==1
            trialmatrix_clean(row).PCorrectChange = trialmatrix_clean(row).majPCorrect - 0.5;
            trialmatrix_clean(row).previousPCorrect = 0.5;
        end
    end
        save([save_filedir 'Part' num2str(part) '_EEG_regression_weighted_STV.mat'], 'trialmatrix_clean', '-v7.3');

end

