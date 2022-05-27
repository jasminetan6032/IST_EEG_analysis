%get video plotting change over time
participants = struct;
%load file
filedir = 'D:\Jasmine\EEG\IST\Electrode_regression\Fixed\';
filename = '_trialmatrix_EEG_regression_weighted_STV.mat';
image_filedir = 'D:\Jasmine\EEG\IST\Images\Make_video\avg_all_parts\';

part = 2;
trialmatrix_filename = [filedir 'Part' num2str(part) filename];
load(trialmatrix_filename);

%average within flip
flip = cell2mat({trialmatrix_clean.flipNumber});

% vidObj = VideoWriter('erpmovietopoplot.mp4', 'MPEG-4');
% open(vidObj);
% counter = 0;
for part = 5:22
    trialmatrix_filename = [filedir 'Part' num2str(part) filename];
    load(trialmatrix_filename);
    flip = cell2mat({trialmatrix_clean.flipNumber});
    participant_data = [];
    for flipNo = 1:length(unique(flip))
        currentFlip = find(flip == flipNo);
        EEGdata = [];
        for row = 1:length(currentFlip)
            EEGdata_currentFlip = trialmatrix_clean(currentFlip(row)).EEGdata.data;
            EEGdata = cat(3,EEGdata, EEGdata_currentFlip);
        end
        FlipData = mean(EEGdata,3);
        timevec = [0 0.8];
        
        timepoints = find(trialmatrix_clean(1).EEGdata.times>=(timevec(1)*1000) & trialmatrix_clean(1).EEGdata.times<=(timevec(2)*1000));
        times = trialmatrix_clean(1).EEGdata.times(timepoints(1):timepoints(length(timepoints)));
        data = FlipData(:,timepoints(1):timepoints(length(timepoints)));
        participant_data = cat(3,participant_data, data);
    end
    participants(part).data = participant_data;
end

vidObj = VideoWriter('erpmovietopoplot_Pz_0-1.0.mp4', 'MPEG-4');
open(vidObj);
counter = 0;
%collate and average across participants
for flipNo = 1:25
    flipdata = [];
    for part = 1:22
        try
            currentflipdata = participants(part).data(:,:,flipNo);
            flipdata = cat(3,flipdata,currentflipdata);
            data = mean(flipdata,3);
        catch
            %nothing to do
        end
    end
    %plot topoplot of data
    topoplot_data = mean(data,2);
    chanlocs = trialmatrix_clean(1).EEGdata.chanlocs(1:64);
    figname = ['Flip ' num2str(flipNo) ' : topoplot and ERP at Pz'];
    figure; subplot(2,1,1); topoplot(topoplot_data,chanlocs,'maplimits','absmax'); 
    title(figname);
    
    % plot correlations over time window
    subplot(2,1,2);
    plot(times,data(31,:));title(['P300 at Pz']);  ylim([-2 12]);
    %plot(times,squeeze(mean(data([1:64],:,:),1))');title(['ERP']); %ylim([-0.08 0.07]);
    
    fignamesave =  [ 'Flip' num2str(flipNo) '_topoplot_ERP_Pz.png'];
    find_fig = [image_filedir 'Flip' num2str(flipNo) '_topoplot_ERP_Pz.png' ];
    
    saveas(gca, fignamesave); %save the figure
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);
    close;  % close current figure
end
close(vidObj);


%% Using topoplot to make movie frames
vidObj = VideoWriter('erpmovietopoplot.mp4', 'MPEG-4');
open(vidObj);
counter = 0;
for latency = -100:10:600 %-100 ms to 1000 ms with 10 time steps
    figure; pop_topoplot(EEG,1,latency, 'My movie', [] ,'electrodes', 'off'); % plot'
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);
    close;  % close current figure
end
close(vidObj);

for iChan = 1:size(FlipData,1)
    FlipData(iChan,:) = conv(FlipData(iChan,:) ,ones(1,5)/5, 'same');
end

% 2-D movie
figure; [Movie,Colormap] = eegmovie(FlipData, trialmatrix_clean(1).EEGdata.srate, chanlocs, 'framenum', 'off', 'vert', 0, 'startsec', -0.1, 'topoplotopt', {'numcontour' 0});
seemovie(Movie,-5,Colormap);

% save movie
vidObj = VideoWriter('erpmovie2d.mp4', 'MPEG-4');
open(vidObj);
writeVideo(vidObj, Movie);
close(vidObj);
