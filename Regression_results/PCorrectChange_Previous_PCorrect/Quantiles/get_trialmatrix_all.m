trialmatrix_all = [];
%collate groups 
for part = 1:22
    
        trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    participant = trialmatrix_all;
    trialmatrix_all = [trialmatrix_all participant];
end

    pcorrect_change = cell2mat({trialmatrix_all.PCorrectChange})';
    pcorrect_previous = cell2mat({trialmatrix_all.previousPCorrect})';
    
Qu_change = quantile(unique(pcorrect_change),4);

Q_change = quantile(pcorrect_change,4);

for row = 1:length(trialmatrix_all)
    x = trialmatrix_all(row).PCorrectChange;
    if x <= Q_change(1) 
        trialmatrix_all(row).ChangeBin = 1;
    elseif x > Q_change(1) && x <= Q_change(2) 
        trialmatrix_all(row).ChangeBin = 2;
    elseif x > Q_change(2) && x <= Q_change(3)
        trialmatrix_all(row).ChangeBin = 3;
    elseif x > Q_change(3) && x <= Q_change(4)
        trialmatrix_all(row).ChangeBin = 4;
    elseif x > Q_change(4)
        trialmatrix_all(row).ChangeBin = 5;
    end
end 

figure;
subplot(2,1,1);
histogram(cell2mat({trialmatrix_all.ChangeBin}));
change_bins = cell2mat({trialmatrix_all.ChangeBin});
STV = cell2mat({trialmatrix_all.STV_regress_eeg_final});

for bin_number = 1:length(Q_change)+1
bin = find(change_bins == bin_number);
plotData(bin_number) = mean(STV(bin));
end 
subplot(2,1,2);
plot(plotData);


for row = 1:length(trialmatrix_all)
    x = trialmatrix_all(row).PCorrectChange;
    if x <= Qu_change(1) 
        trialmatrix_all(row).ChangeBin = 1;
    elseif x > Qu_change(1) && x <= Qu_change(2) 
        trialmatrix_all(row).ChangeBin = 2;
    elseif x > Qu_change(2) && x <= Qu_change(3)
        trialmatrix_all(row).ChangeBin = 3;
    elseif x > Qu_change(3) && x <= Qu_change(4)
        trialmatrix_all(row).ChangeBin = 4;
    elseif x > Qu_change(4)
        trialmatrix_all(row).ChangeBin = 5;
    end
end 

figure;
subplot(2,1,1);
histogram(cell2mat({trialmatrix_all.ChangeBin}));

change_bins = cell2mat({trialmatrix_all.ChangeBin});
STV = cell2mat({trialmatrix_all.STV_regress_eeg_final});

for bin_number = 1:length(Q_change)+1
bin = find(change_bins == bin_number);
plotData(bin_number) = mean(STV(bin));
end 
subplot(2,1,2);
plot(plotData);

Qu_previous = quantile(unique(pcorrect_previous),2);

Q_previous = quantile(pcorrect_previous,2);

for row = 1:length(trialmatrix_all)
    y = trialmatrix_all(row).previousPCorrect;
    if y <= Q_previous(1) 
        trialmatrix_all(row).PreviousBin = 1;
    elseif y > Q_previous(1) && y <= Q_previous(2) 
        trialmatrix_all(row).PreviousBin = 2;
    elseif y > Q_previous(2) 
        trialmatrix_all(row).PreviousBin = 3;
    end
end 

figure;
subplot(2,1,1);
histogram(cell2mat({trialmatrix_all.PreviousBin}));
previous_bins = cell2mat({trialmatrix_all.PreviousBin});
STV = cell2mat({trialmatrix_all.STV_regress_eeg_final});

for bin_number = 1:length(Q_previous)+1
bin = find(previous_bins == bin_number);
plotDataPrevious(bin_number) = mean(STV(bin));
end 
subplot(2,1,2);
plot(plotDataPrevious);

for row = 1:length(trialmatrix_all)
    y = trialmatrix_all(row).previousPCorrect;
    if y <= Qu_previous(1) 
        trialmatrix_all(row).PreviousBin = 1;
    elseif y > Qu_previous(1) && y <= Qu_previous(2) 
        trialmatrix_all(row).PreviousBin = 2;
    elseif y > Qu_previous(2) 
        trialmatrix_all(row).PreviousBin = 3;
    end
end 

figure;
subplot(2,1,1);
histogram(cell2mat({trialmatrix_all.PreviousBin}));
previous_bins = cell2mat({trialmatrix_all.PreviousBin});
STV = cell2mat({trialmatrix_all.STV_regress_eeg_final});

for bin_number = 1:length(Q_previous)+1
bin = find(previous_bins == bin_number);
plotDataPrevious(bin_number) = mean(STV(bin));
end 
subplot(2,1,2);
plot(plotDataPrevious);

for i = 1:length(Q_previous)+1
    for j = 1:length(Q_change)+1
bin = find(previous_bins == i & change_bins == j);
plotData(i,j) = mean(STV(bin));
    end 
end 

plotData = plotData';
line1 = plotData(:,1);
line2 = plotData(:,2);
line3 = plotData(:,3);
x = 1:5;
idx = ~any(isnan(line1),1);
figure;plot(x(idx),line1(idx));

idx = find(~isnan(line1));
line1 = interp1(x(idx),line1(idx),x,'linear');
idx = find(~isnan(line2));
line2 = interp1(x(idx),line2(idx),x,'linear');
idx = find(~isnan(line3));
line3 = interp1(x(idx),line3(idx),x,'spline');
figure;
plot(x,line1,x,line2,x,line3,'LineWidth',2);