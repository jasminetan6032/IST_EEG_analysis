%get video plotting change over time

%load file
filedir = 'C:\Github\IST_EEG_analysis\EEG\Updated\';
filename = '_EEG_regression_weighted_STV.mat';
save_filedir =  'C:\Github\IST_EEG_analysis\Regression_results\Condition_confidence\Unstandardised\';

part = 2;
trialmatrix_filename = [filedir 'Part' num2str(part) filename];
load(trialmatrix_filename);

%average within flip

%plot ERP
%plot topoplot


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

