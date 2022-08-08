filedir = 'C:\Github\IST_EEG_analysis\EEG\Updated\';
filename = '_EEG_regression_weighted_STV.mat';

for part = 1:22
    
    trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    pcorrect_previous = cell2mat({trialmatrix_clean.previousPCorrect})';
    Q_previous = quantile(pcorrect_previous,2);
    
    for row = 1:length(trialmatrix_clean)
        y = trialmatrix_clean(row).previousPCorrect;
        if y <= Q_previous(1)
            trialmatrix_clean(row).PreviousBin = 1;
        elseif y > Q_previous(1) && y <= Q_previous(2)
            trialmatrix_clean(row).PreviousBin = 2;
        elseif y > Q_previous(2)
            trialmatrix_clean(row).PreviousBin = 3;
        end
    end
    pcorrect_change = cell2mat({trialmatrix_clean.PCorrectChange})';
    STV = cell2mat({trialmatrix_clean.STV_regress_eeg_final});
    previous_bins = cell2mat({trialmatrix_clean.PreviousBin});
    
    for bin = 1:3
        bin_previous = find(previous_bins == bin);
        participants(part).plotdata(bin,1) = bin;
        participants(part).plotdata(bin,2) = mean(pcorrect_change(bin_previous));
        participants(part).plotdata(bin,3) = mean(STV(bin_previous));
    end
    
    
end

avg_data = [];
for part = 1:22
    participant = participants(part).plotdata;
    avg_data = cat(1,avg_data, participant);
end 

context = avg_data(:,1);
change = avg_data(:,2);
STV = avg_data(:,3);

tbl = table(context,change, STV, 'VariableNames', {'context','change','EEG'});
s = scatter(tbl,'change','EEG','filled','ColorVariable','context');

figure; scatter(change,STV,[],context,'filled')
 colorbar
    