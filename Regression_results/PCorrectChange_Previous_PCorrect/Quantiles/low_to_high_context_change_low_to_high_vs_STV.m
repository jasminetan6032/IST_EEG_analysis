filedir = '/local_mount/space/hypatia/2/users/Jasmine/github/IST_EEG_analysis/EEG/Updated/';
filename = '_EEG_regression_weighted_STV.mat';

participants = struct;

for part = 1:22

    trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    %extract context and divide it into quantiles
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
    %extract change, STV and bin numbers for context
    pcorrect_change = abs(cell2mat({trialmatrix_clean.PCorrectChange})');
    STV = cell2mat({trialmatrix_clean.STV_regress_eeg_final});
    previous_bins = cell2mat({trialmatrix_clean.PreviousBin});

    %subset by each context bin and divide further into change quantiles
    for bin = 1:3
        bin_previous = find(previous_bins == bin);
        STV_previous_bin = STV(bin_previous);
        pcorrect_previous_bin = pcorrect_previous(bin_previous);
        pcorrect_change_bin = pcorrect_change(bin_previous);
        Q_change = quantile(pcorrect_change_bin,2);

        for row = 1:length(pcorrect_change_bin)
            x = pcorrect_change_bin(row);
            if x <= Q_change(1)
                pcorrect_change_bin(row,2) = 1;
            elseif x > Q_change(1) && x <= Q_change(2)
                pcorrect_change_bin(row,2)= 2;
            elseif x > Q_change(2)
                pcorrect_change_bin(row,2) = 3;
            end
        end

        for change_bin = 1:3
            pcorrect_change_bin_index = find(pcorrect_change_bin(:,2)==change_bin);
            average_STV(bin,change_bin) = mean(STV_previous_bin(pcorrect_change_bin_index));
            average_context(bin,change_bin) = mean(pcorrect_previous_bin(pcorrect_change_bin_index));
            average_change(bin,change_bin) = mean(pcorrect_change_bin(pcorrect_change_bin_index));
            avg_context_bin(bin,change_bin) = bin;
        end


    end
    STV = reshape(average_STV',1,[]);
    change = reshape(average_change',1,[]);
    context = reshape(average_context',1,[]);
    context_bin = reshape(avg_context_bin',1,[]);
    participants(part).data = [context_bin',context',change',STV'];

end

all_data = [];
for part = 1:22
    participant = participants(part).data;
    all_data = cat(1,all_data, participant);
end

context = all_data(:,1);
change = all_data(:,3);
STV = all_data(:,4);

tbl = table(context,change, STV, 'VariableNames', {'context','change','EEG'});
s = scatter(tbl,'change','EEG','filled','ColorVariable','context');

figure; scatter(change,STV,[],context,'filled')
colorbar


avg_data = [];
for part = 1:22
    participant = participants(part).STVdata;
    avg_data = cat(3,avg_data, participant);
end

plotdata = mean(avg_data,3);
plotdata = plotdata(:,1:3);

plotdata = plotdata';
line1 = plotdata(:,1);
line2 = plotdata(:,2);
line3 = plotdata(:,3);
x = 1:3;
figure;plot(x,line1,x,line2,x,line3);

test = reshape(plotdata',1,[])';
context_bins = [1,1,1,2,2,2,3,3,3];
test_cat = cat(2,test,context_bins');

%if you want to calculate mean and SD on your own
y = rand(1,10); % your mean vector;
x = 1:numel(y);
std_dev = 1;
curve1 = y + std_dev;
curve2 = y - std_dev;
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
fill(x2, inBetween, 'g');
hold on;
plot(x, y, 'r', 'LineWidth', 2);